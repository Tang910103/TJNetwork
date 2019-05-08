//
//  TJNetworkManager.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/11.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJNetworkManager.h"
#import "TJBaseRequest.h"
#import "TJNetworkConfig.h"
#import "TJNetworkCache.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif



#define weakObj(self) __weak typeof(self) weak_##self = self;
#define strongObj(self) __strong typeof(self) self = weak_##self;

#define LOCK() dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
#define UNLOCK() dispatch_semaphore_signal(self->_semaphore);

@interface TJBaseRequest ()
@property (nonatomic, strong) NSURLSessionTask *requestTask;
@end

@interface TJNetworkManager ()
{
    NSMutableDictionary<NSNumber *, TJBaseRequest *> *_requests;
    dispatch_semaphore_t _semaphore;
    TJNetworkConfig *_config;
}
/// AF网络管理
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation TJNetworkManager
#pragma mark --------------- system methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        _config = [TJNetworkConfig shareObject];
        _requests = @{}.mutableCopy;
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}
#pragma mark --------------- public methods

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)addRequest:(TJBaseRequest *)request
{
    NSParameterAssert(request != nil);
    if (![self requestWillStart:request]) return;
    
    [self setupRequestSerializer:request];
    [self sessionTaskByRequest:request];
    
    LOCK()
    [_requests setObject:request forKey:@(request.requestTask.taskIdentifier)];
    UNLOCK()
}

- (void)cancelRequest:(TJBaseRequest *)request
{
    [request.requestTask cancel];
    LOCK()
    [_requests removeObjectForKey:@(request.requestTask.taskIdentifier)];
    UNLOCK()
}

- (void)cancelAllRequests
{
    LOCK()
    NSArray *allKeys = [_requests allKeys];
    UNLOCK()
    if (allKeys.count > 0) {
        for (NSNumber *key in allKeys) {
            LOCK()
            TJBaseRequest *request = _requests[key];
            UNLOCK()
            [request cancel];
        }
    }
}

#pragma mark --------------- delegate methods

#pragma mark --------------- private methods

- (TJBaseRequest *)requestByTask:(NSURLSessionTask *)task {
    LOCK()
    TJBaseRequest *re = _requests[@(task.taskIdentifier)];
    UNLOCK()
    return re;
}

/** 设置请求序列化器 */
- (void)setupRequestSerializer:(TJBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if (request.requestSerializer == TJJSONRequestSerializer) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (request.username.length > 0 && request.password.length >0) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:request.username password:request.password];
    }
    requestSerializer.timeoutInterval = request.timeoutInterval;
    [request.requestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    _manager.requestSerializer = requestSerializer;
}

- (void)sessionTaskByRequest:(TJBaseRequest *)request
{
    void (^progress)(NSProgress *pr) = ^(NSProgress *pr){
        if (request.progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                request.progress(pr);
            });
        }
    
    };

    __block NSError *requestError = nil;
    __block NSURLSessionTask *task = nil;
//    断点续传路径
    NSString *resumePath = request.resumePath;
    NSMutableURLRequest *urlRequest = [self requestWithrepuest:request error:&requestError];
    if (requestError) {
        [self handelRequestResult:nil error:requestError request:request];
        return;
    }
    
    if (resumePath.length) {
//        设置断点续传的Range
        NSData *resumeData = [[NSData alloc] initWithContentsOfFile:resumePath];
        NSString *bytesStr = [NSString stringWithFormat:@"bytes=%lu-",(unsigned long)resumeData.length];
        [urlRequest addValue:bytesStr forHTTPHeaderField:@"Range"];
    }
    
    weakObj(self)
    [_manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        strongObj(self)
        if (resumePath.length && request.downloadCachePathBlock) {
            //                追加数据到文件
            [self writeData:data toFilePath:resumePath];
        }
    }];

    if (request.requestMethod == TJRequestMethodPOST && request.constructingBodyBlock) {
        
//        上传文件
        task = [_manager uploadTaskWithStreamedRequest:urlRequest progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handelRequestResult:responseObject error:error request:request];
        }];
    } else {
        
        task = [_manager dataTaskWithRequest:urlRequest uploadProgress:progress downloadProgress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            requestError = error;
            if (request.downloadCachePathBlock) {
                NSString *filePath = request.downloadCachePathBlock(response);
                NSLog(@"下载完成");
                if (resumePath.length) {
//                    移动断点续传路径的文件到缓存路径
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&requestError];
                    }
                    [[NSFileManager defaultManager] moveItemAtPath:resumePath toPath:filePath error:&requestError];
                } else {
                    [self writeData:responseObject toFilePath:filePath];
                }
                responseObject = filePath;
            }
            [self handelRequestResult:responseObject error:requestError request:request];
        }];
    }
    
    [request setRequestTask:task];
    [self startSession:request];
}

- (unsigned long long)writeData:(NSData *)data toFilePath:(NSString *)filePath {
    if (![data isKindOfClass:[NSData class]]) return 0;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
//        如果文件不存在先创建文件
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    unsigned long long length = data.length;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    length += [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    [fileHandle writeData:data]; //追加写入数据
    [fileHandle closeFile];
    NSLog(@"文件写入完成:%llu",length);
    return length;
}


- (NSMutableURLRequest *)requestWithrepuest:(TJBaseRequest *)request error:(NSError *__autoreleasing *)error
{
    NSString *URLString = request.url;
    id parameters = request.parameter;
    AFHTTPRequestSerializer *requestSerializer = _manager.requestSerializer;
    NSString *method = @"GET";
    switch (request.requestMethod) {
        case TJRequestMethodDELETE:
            method = @"DELETE";
            break;
        case TJRequestMethodPOST:
        {
            if (request.constructingBodyBlock) {
                return [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:request.constructingBodyBlock error:error];
            }
            method = @"POST";
        }
            break;
        default:
            method = @"GET";
            break;
    }
    return [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
}

/** 处理请求结果 */
- (void)handelRequestResult:(id)responseObject error:(NSError *)error request:(TJBaseRequest *)request {
    NSError *requestError = error;
    if (!requestError) {
        request.result = responseObject;
        if ([responseObject isKindOfClass:[NSData class]] && !request.downloadCachePathBlock) {
            if (request.responseSerializer == TJHTTPResponseSerializer) {
                request.result = [[AFHTTPResponseSerializer serializer] responseObjectForResponse:request.requestTask.response data:responseObject error:&requestError];
            } else if (request.responseSerializer == TJJSONResponseSerializer) {
                request.result = [[AFJSONResponseSerializer serializer] responseObjectForResponse:request.requestTask.response data:responseObject error:&requestError];
            } else if (request.responseSerializer == TJXMLParserResponseSerializer) {
                request.result = [[AFXMLParserResponseSerializer serializer] responseObjectForResponse:request.requestTask.response data:responseObject error:&requestError];
            } else if (request.responseSerializer == TJPropertyListResponseSerializer) {
                request.result = [[AFPropertyListResponseSerializer serializer] responseObjectForResponse:request.requestTask.response data:responseObject error:&requestError];
            }
        }
    }
    request.originalResult = responseObject;
    request.error = requestError;
    [self requestDidCompletion:request];
}

/** 即将开始请求 */
- (BOOL)requestWillStart:(TJBaseRequest *)request {
    if ([[TJNetworkConfig shareObject].delegate respondsToSelector:@selector(requestWillStart:)]) {
        return [TJNetworkConfig.shareObject.delegate requestWillStart:request];
    }
    return YES;
}


/** 开始请求 */
- (void)startSession:(TJBaseRequest *)request {
    //    开始执行会话
    [request.requestTask resume];
}

/** 请求完成 */
- (void)requestDidCompletion:(TJBaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[TJNetworkConfig shareObject].delegate respondsToSelector:@selector(requestWillStop:)]) {
            [TJNetworkConfig.shareObject.delegate requestWillStop:request];
        }
        BOOL isCache = request.isCache;
        if (request.complete) {
            request.complete(request, &isCache);
        }
        if (isCache) {
            [TJNetworkCache cacheDataWithRequest:request withBlock:^{
                
            }];
        }
        [request cancel];
    });
}

#pragma mark --------------- event response

#pragma mark --------------- property getter

#pragma mark --------------- property setter

@end
