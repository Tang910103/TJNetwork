//
//  XCBaseRequest.m
//  XCNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "XCBaseRequest.h"
#import "XCNetworkManager.h"
#import "XCNetworkCache.h"
#import "XCNetworkConfig.h"

@interface XCBaseRequest ()
@property (nonatomic, strong) NSURLSessionTask *requestTask;
@end


@implementation XCBaseRequest

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
        XCNetworkConfig *config = [XCNetworkConfig shareObject];
        _requestSerializer = config.requestSerializer;
        _responseSerializer = config.responseSerializer;
        _timeoutInterval = config.timeoutInterval;
        _username = config.username;
        _password = config.password;
        _requestHeaders = config.requestHeaders;
        _isCache = config.isCache;
        _requestMethod = XCRequestMethodGET;
        _requestTask = nil;
    }
    return self;
}

#pragma mark --------------- public methods

+ (instancetype)request
{
    return [[self alloc] init];
}

- (void)startRequestWithCompleteBlock:(XCBaseRequestCompletionBlock)complete
{
    [[XCNetworkManager sharedManager] addRequest:self];
    if (complete) {
        self.complete = complete;
    }
}

- (void)cancel
{
    [[XCNetworkManager sharedManager] cancelRequest:self];
    [self clearBlock];
}

- (void)readCacheBlock:(void (^)(id))block
{
    [XCNetworkCache readCacheWithRequest:self withBlock:block];
}

+ (void)get:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete
{
    [self custom:^XCBaseRequest *{
        XCBaseRequest *re = [XCBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = XCRequestMethodGET;
        return re;
    } complete:complete];
}

+ (void)post:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete
{
    [self custom:^XCBaseRequest *{
        XCBaseRequest *re = [XCBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = XCRequestMethodPOST;
        return re;
    } complete:complete];
}
+ (void)delet:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete
{
    [self custom:^XCBaseRequest *{
        XCBaseRequest *re = [XCBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = XCRequestMethodDELETE;
        return re;
    } complete:complete];
}
+ (void)upload:(NSString *)url parameter:(id)parameter bodyBlock:(XCConstructBodyBlock)bodyBlock complete:(XCBaseRequestCompletionBlock)complete
{
    [self custom:^XCBaseRequest *{
        XCBaseRequest *re = [XCBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = XCRequestMethodPOST;
        re.constructingBodyBlock = bodyBlock;
        return re;
    } complete:complete];
}
+ (XCBaseRequest *)download:(NSString *)url parameter:(id)parameter resumePath:(NSString *)resumePath downloadCachePath:(XCRequestDownloadCachePathBlock)cachePath progress:(XCBaseRequestProgressBlock)progress complete:(XCBaseRequestCompletionBlock)complete
{
    return [self custom:^XCBaseRequest *{
        XCBaseRequest *re = [XCBaseRequest request];
        re.url = url;
        re.parameter = parameter;
        re.requestMethod = XCRequestMethodGET;
        re.resumePath = resumePath;
        re.progress = progress;
        re.downloadCachePathBlock = cachePath;
        return re;
    } complete:complete];
}
+ (XCBaseRequest *)custom:(XCBaseRequest *(^)(void))request complete:(XCBaseRequestCompletionBlock)complete
{
    XCBaseRequest *re = request();
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
