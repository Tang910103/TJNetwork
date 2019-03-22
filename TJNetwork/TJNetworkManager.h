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
#pragma mark ------------ 属性

#pragma mark ------------ 类方法
/// 共享管理对象
+ (instancetype)sharedManager;

/// 添加会话请求并启动会话
- (void)addRequest:(TJBaseRequest *)request;
/// 取消会话请求
- (void)cancelRequest:(TJBaseRequest *)request;
/// 取消所有会话请求
- (void)cancelAllRequests;

#pragma mark ------------ 实例方法
@end

NS_ASSUME_NONNULL_END
