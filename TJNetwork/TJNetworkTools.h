//
//  TJNetworkTools.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/15.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJNetworkTools : NSObject
#pragma mark --------------- Propertys
/// ---------------------------------------------------
/// @name Propertys
/// ---------------------------------------------------

#pragma mark ------------ Class Methods
/// ---------------------------------------------------
/// @name Class Methods
/// ---------------------------------------------------

/**
 URL拼接

 @param urlPath 接口路径
 @param basePath 服务器基地址
 @return 完整的接口地址
 */
+ (NSString *)URLWithPath:(NSString *)urlPath basePath:(NSString *)basePath;

/**
 字符串转MD5
 
 @param str 待转字符串
 @return MD5字符串
 */
+ (NSString *)stringToMD5:(NSString *)str;

#pragma mark ------------ Instance Methods
/// ---------------------------------------------------
/// @name Instance Methods
/// ---------------------------------------------------

@end

NS_ASSUME_NONNULL_END
