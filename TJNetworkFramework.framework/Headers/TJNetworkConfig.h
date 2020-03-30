//
//  TJNetworkConfig.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/13.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBaseRequestProtocol.h"
@class TJBaseRequest;

@protocol TJNetworkDelegate <NSObject>

/**
 请求即将开始,返回true开始请求，false需手动开始请求

 @param request 请求对象 TJBaseRequest
 @return 是否开始请求
 */
- (BOOL)requestWillStart:(TJBaseRequest *)request;

/**
 请求即将结束，优先级低于request自身的requestWillStopBlock,可统一处理请求结果

 @param request 请求对象 TJBaseRequest
 */
- (void)requestWillStop:(TJBaseRequest *)request;
@end


/** 网络请求配置，应当在框架使用之前 */
@interface TJNetworkConfig : NSObject<TJBaseRequestProtocol>
#pragma mark --------------- Propertys
/// ---------------------------------------------------
/// @name Propertys
/// ---------------------------------------------------
@property (nonatomic, weak) id<TJNetworkDelegate> delegate;
/// 网络数据缓存文件夹路径
@property (nonatomic, copy) NSString *cachePath;

#pragma mark ------------ Class Methods
/// ---------------------------------------------------
/// @name Class Methods
/// ---------------------------------------------------
+ (TJNetworkConfig *)shareObject;

#pragma mark ------------ Instance Methods
/// ---------------------------------------------------
/// @name Instance Methods
/// ---------------------------------------------------


@end


