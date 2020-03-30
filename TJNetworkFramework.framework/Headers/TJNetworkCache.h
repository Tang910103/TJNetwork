//
//  TJNetworkCache.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/18.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJBaseRequest;

@interface TJNetworkCache : NSObject

#pragma mark --------------- Propertys
/// ---------------------------------------------------
/// @name Propertys
/// ---------------------------------------------------

#pragma mark ------------ Class Methods
/// ---------------------------------------------------
/// @name Class Methods
/// ---------------------------------------------------

/**
 缓存请求结果, block != nil异步执行，block == nil同步执行

 @param request 需要缓存的请求对象 TJBaseRequest
 @param block 完成回调
 */
+ (void)cacheDataWithRequest:(TJBaseRequest *)request withBlock:(void (^)(void))block;

/**
 异步读取缓存请求

 @param request 需要读取缓存的请求对象 TJBaseRequest
 @return 缓存结果
 */
+ (id)readCacheWithRequest:(TJBaseRequest *)request;

/**
 异步读取缓存请求, 异步执行

 @param request 需要读取缓存的请求对象 TJBaseRequest
 @param block 完成回调
 */
+ (void)readCacheWithRequest:(TJBaseRequest *)request withBlock:(void(^)(NSString *key, id<NSCoding> object))block;

/**
 异步删除指定请求缓存 , block != nil异步执行，block == nil同步执行

 @param request 需要清空缓存的请求对象 TJBaseRequest
 @param block 完成回调
 */
+ (void)removeCacheWithRequest:(TJBaseRequest *)request withBlock:(void(^)(NSString *key))block;

/**
 清空所有请求缓存, block != nil异步执行，block == nil同步执行

 @param block 清空完成回调
 */
+ (void)removeAllRequestsWithBlock:(void(^)(void))block;

/**
 请求是否存在缓存
 */
+ (BOOL)containsObjectForKey:(NSString *)key;

/**
 请求是否存在缓存, 异步执行

 @param request 查找缓存的请求体 TJBaseRequest
 @param block 获取缓存回调
 */
+ (void)containsRequestForRequest:(TJBaseRequest *)request withBlock:( void(^)(NSString *key, BOOL contains))block;

/**
 获取缓存key
 
 @param request 请求体 TJBaseRequest
 */
+ (NSString *)cacheKeyWithRequest:(TJBaseRequest *)request;


#pragma mark ------------ Instance Methods
/// ---------------------------------------------------
/// @name Instance Methods
/// ---------------------------------------------------

@end


