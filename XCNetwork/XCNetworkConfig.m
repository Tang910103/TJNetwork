//
//  XCNetworkConfig.m
//  XCNetworking
//  Created by Tang杰 on 2019/3/13.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "XCNetworkConfig.h"

@implementation XCNetworkConfig

@synthesize timeoutInterval = _timeoutInterval,
responseSerializer = _responseSerializer,
requestSerializer = _requestSerializer,
isCache = _isCache,
password = _password,
username = _username,
requestHeaders = _requestHeaders;

#define MY_CLASS XCNetworkConfig

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
        _responseSerializer = XCHTTPResponseSerializer;
        _requestSerializer = XCHTTPRequestSerializer;
        _isCache = NO;
    }
    return self;
}

#pragma mark --------------- property getter

- (NSString *)cachePath
{
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"XCNetworkCache"];
    }
    return _cachePath;
}

@end

