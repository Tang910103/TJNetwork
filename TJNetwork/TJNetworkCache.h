//
//  TJNetworkCache.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/18.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJBaseRequest;

@interface TJNetworkCache : NSObject
#pragma mark ------------ 属性

#pragma mark ------------ 类方法
/** 缓存请求结果, block != nil异步执行，block == nil同步执行*/
+ (void)cacheDataWithRequest:(TJBaseRequest *)request withBlock:(void (^)(void))block;
/** 异步读取缓存请求, block != nil异步执行，block == nil同步执行*/
+ (id)readCacheWithRequest:(TJBaseRequest *)request withBlock:(void(^)(id result))block;
/** 异步删除指定请求缓存 , block != nil异步执行，block == nil同步执行*/
+ (void)removeCacheWithRequest:(TJBaseRequest *)request withBlock:(void(^)(id result))block;
/** 清空所有请求缓存, block != nil异步执行，block == nil同步执行*/
+ (void)removeAllRequestsWithBlock:(void(^)(void))block;
/** 请求是否已经缓存, block != nil异步执行，block == nil同步执行*/
+ (BOOL)containsRequestForRequest:(TJBaseRequest *)request withBlock:(void (^)(NSString *, BOOL))block;

/** 获取缓存key */
+ (NSString *)cacheKeyWithRequest:(TJBaseRequest *)request;
#pragma mark ------------ 实例方法
@end


