//
//  XCNetworkCache.h
//  XCNetworking
//  Created by Tang杰 on 2019/3/18.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCBaseRequest;

@interface XCNetworkCache : NSObject
#pragma mark ------------ 属性

#pragma mark ------------ 类方法
/** 缓存请求结果, block != nil异步执行，block == nil同步执行*/
+ (void)cacheDataWithRequest:(XCBaseRequest *)request withBlock:(void (^)(void))block;
/** 异步读取缓存请求, block != nil异步执行，block == nil同步执行*/
+ (id)readCacheWithRequest:(XCBaseRequest *)request withBlock:(void(^)(id result))block;
/** 异步删除指定请求缓存 , block != nil异步执行，block == nil同步执行*/
+ (void)removeCacheWithRequest:(XCBaseRequest *)request withBlock:(void(^)(id result))block;
/** 清空所有请求缓存, block != nil异步执行，block == nil同步执行*/
+ (void)removeAllRequestsWithBlock:(void(^)(void))block;
/** 请求是否已经缓存, block != nil异步执行，block == nil同步执行*/
+ (BOOL)containsRequestForRequest:(XCBaseRequest *)request withBlock:(void (^)(NSString *, BOOL))block;

/** 获取缓存key */
+ (NSString *)cacheKeyWithRequest:(XCBaseRequest *)request;
#pragma mark ------------ 实例方法
@end


