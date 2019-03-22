//
//  XCNetworkTools.h
//  XCNetworking
//  Created by Tang杰 on 2019/3/15.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCNetworkTools : NSObject
#pragma mark ------------ 属性

#pragma mark ------------ 类方法
+ (NSString *)URLWithString:(nullable NSString *)URLString relativeToURL:(nullable NSURL *)baseURL;

+ (NSString *)stringToMD5:(NSString *)str;

#pragma mark ------------ 实例方法
@end

NS_ASSUME_NONNULL_END
