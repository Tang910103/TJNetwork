//
//  TJNetworkCache.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/18.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJNetworkCache.h"
#import "TJBaseRequest.h"
#import "TJNetworkConfig.h"
#import "TJNetworkTools.h"
#import <YYCache/YYCache.h>

@interface TJNetworkCache ()
@property (nonatomic, strong) YYCache *cache;
@end

@implementation TJNetworkCache

#define MY_CLASS TJNetworkCache

+ (MY_CLASS *)shareObject
{
    static MY_CLASS *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[super allocWithZone:NULL] init];
        shareObject.cache = [[YYCache alloc] initWithPath:[TJNetworkConfig shareObject].cachePath];
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

+ (void)cacheDataWithRequest:(TJBaseRequest *)request withBlock:(void (^)(void))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (!block) {
        [[TJNetworkCache shareObject].cache setObject:request.result forKey:key];
    } else {
        [[TJNetworkCache shareObject].cache setObject:request.result forKey:key withBlock:block];
    }
}

+ (id)readCacheWithRequest:(TJBaseRequest *)request
{
    return [[TJNetworkCache shareObject].cache objectForKey:[self cacheKeyWithRequest:request]];
}

+ (void)readCacheWithRequest:(TJBaseRequest *)request withBlock:(void (^)(NSString *, id<NSCoding>))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    [[TJNetworkCache shareObject].cache objectForKey:key withBlock:block];
}

+ (void)removeCacheWithRequest:(TJBaseRequest *)request withBlock:(void (^)(NSString *))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    if (block) {
        [[TJNetworkCache shareObject].cache removeObjectForKey:key withBlock:block];
    } else {
        [[TJNetworkCache shareObject].cache removeObjectForKey:key];
    }
}

+ (void)removeAllRequestsWithBlock:(void (^)(void))block
{
    if (block) {
        [[TJNetworkCache shareObject].cache removeAllObjectsWithBlock:block];
    } else {
        [[TJNetworkCache shareObject].cache removeAllObjects];
    }
}

+ (BOOL)containsObjectForKey:(NSString *)key
{
    return [[TJNetworkCache shareObject].cache containsObjectForKey:key];
}

+ (void)containsRequestForRequest:(TJBaseRequest *)request withBlock:(void (^)(NSString *, BOOL))block
{
    NSString *key = [self cacheKeyWithRequest:request];
    [[TJNetworkCache shareObject].cache containsObjectForKey:key withBlock:block];
}

+ (NSString *)cacheKeyWithRequest:(TJBaseRequest *)request
{
    NSString *string = [NSString stringWithFormat:@"%@%@",request.url ,request.parameter];
    return [TJNetworkTools stringToMD5:string];
}

@end
