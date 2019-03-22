//
//  XCNetworkConfig.h
//  XCNetworking
//  Created by Tang杰 on 2019/3/13.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCBaseRequestProtocol.h"
@class XCBaseRequest;

@protocol XCNetworkDelegate <NSObject>
/** 请求即将开始 */
- (void)requestWillStart:(XCBaseRequest *)request;
/** 请求即将结束，优先级低于request自身的requestWillStopBlock,可统一处理请求结果 */
- (void)requestWillStop:(XCBaseRequest *)request;
@end


/** 网络请求配置，应当在 */
@interface XCNetworkConfig : NSObject<XCBaseRequestProtocol>
#pragma mark ------------ 属性
@property (nonatomic, weak) id<XCNetworkDelegate> delegate;
/// 网络数据缓存文件夹路径
@property (nonatomic, copy) NSString *cachePath;

#pragma mark ------------ 类方法
+ (XCNetworkConfig *)shareObject;
#pragma mark ------------ 实例方法

@end


