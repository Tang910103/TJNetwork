//
//  TJNetworkConfig.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/13.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJNetworkConfig.h"

@implementation TJNetworkConfig

@synthesize timeoutInterval = _timeoutInterval,
responseSerializer = _responseSerializer,
requestSerializer = _requestSerializer,
isCache = _isCache,
password = _password,
username = _username,
requestHeaders = _requestHeaders;

#define MY_CLASS TJNetworkConfig

+ (MY_CLASS *)shareObject
{
    static MY_CLASS *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[super allocWithZone:NULL] init];
    });
    return shareObject;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [MY_CLASS shareObject];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [MY_CLASS shareObject];
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [MY_CLASS shareObject];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeoutInterval = 60;
        _responseSerializer = TJHTTPResponseSerializer;
        _requestSerializer = TJHTTPRequestSerializer;
        _isCache = NO;
    }
    return self;
}

#pragma mark --------------- property getter

- (NSString *)cachePath
{
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"TJNetworkCache"];
    }
    return _cachePath;
}

@end

