//
//  XCNetworkCache.m
//  XCNetworking
//  Created by Tang杰 on 2019/3/18.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "XCNetworkCache.h"
#import "XCBaseRequest.h"
#import "XCNetworkConfig.h"
#import "XCNetworkTools.h"
#import <YYCache/YYCache.h>

@interface XCNetworkCache ()
@property (nonatomic, strong) YYCache *cache;
@end

@implementation XCNetworkCache

#define MY_CLASS XCNetworkCache

+ (MY_CLASS *)shareObject
{
    static MY_CLASS *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[super allocWithZone:NULL] init];
        shareObject.cache = [[YYCache alloc] initWithPath:[XCNetworkConfig shareObject].cachePath];
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

+ (void)cacheDataWithRequest:(XCBaseRequest *)request withBlock:(void (^)(void))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (!block) {
        [[XCNetworkCache shareObject].cache setObject:request.result forKey:key];
    } else {
        [[XCNetworkCache shareObject].cache setObject:request.result forKey:key withBlock:block];
    }
}

+ (id)readCacheWithRequest:(XCBaseRequest *)request withBlock:(void(^)(id result))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (block) {
        [[XCNetworkCache shareObject].cache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
            if (block) {
                block(object);
            }
        }];
        return nil;
    } else {
        return [[XCNetworkCache shareObject].cache objectForKey:key];
    }
}

+ (void)removeCacheWithRequest:(XCBaseRequest *)request withBlock:(void (^)(id))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (block) {
        [[XCNetworkCache shareObject].cache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
            if (block) {
                block(key);
            }
        }];
    } else {
        [[XCNetworkCache shareObject].cache removeObjectForKey:key];
    }
}

+ (void)removeAllRequestsWithBlock:(void (^)(void))block
{
    if (block) {
        [[XCNetworkCache shareObject].cache removeAllObjectsWithBlock:block];
    } else {
        [[XCNetworkCache shareObject].cache removeAllObjects];
    }
}
+ (BOOL)containsRequestForRequest:(XCBaseRequest *)request withBlock:(void (^)(NSString *, BOOL))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (block) {
        [[XCNetworkCache shareObject].cache containsObjectForKey:key withBlock:block];
        return NO;
    } else {
        return [[XCNetworkCache shareObject].cache containsObjectForKey:key];
    }
}

+ (NSString *)cacheKeyWithRequest:(XCBaseRequest *)request
{
    NSString *string = [NSString stringWithFormat:@"%@%@",request.url ,request.parameter];
    return [XCNetworkTools stringToMD5:string];
}

@end
