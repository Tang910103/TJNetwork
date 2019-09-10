//
//  TJNetworkManager.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/11.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJBaseRequest;

NS_ASSUME_NONNULL_BEGIN

@interface TJNetworkManager : NSObject
#pragma mark --------------- Propertys
/// ---------------------------------------------------
/// @name Propertys
/// ---------------------------------------------------

#pragma mark ------------ Class Methods
/// ---------------------------------------------------
/// @name Class Methods
/// ---------------------------------------------------

/// 共享管理对象
+ (instancetype)sharedManager;


#pragma mark ------------ Instance Methods
/// ---------------------------------------------------
/// @name Instance Methods
/// ---------------------------------------------------

/**
 添加会话请求并启动会话

 @param request 即将开始的请求体 TJBaseRequest
 */
- (void)addRequest:(TJBaseRequest *)request;

/**
 取消会话请求

 @param request 将要取消的请求体 TJBaseRequest
 */
- (void)cancelRequest:(TJBaseRequest *)request;

/**
 取消所有会话请求
 */
- (void)cancelAllRequests;
@end

NS_ASSUME_NONNULL_END
