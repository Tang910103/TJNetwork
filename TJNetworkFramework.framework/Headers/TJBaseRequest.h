//
//  TJBaseRequest.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBaseRequestProtocol.h"

@class TJBaseRequest;

@protocol AFMultipartFormData;

/**
 下载缓存路径配置回调
 
 response 下载响应体
 
 return 缓存路径
 */
typedef NSString *(^TJRequestDownloadCachePathBlock)(NSURLResponse * _Nonnull response);

/**
 请求完成回调
 
 request 当前请求对象
 
 isCache 是否需要缓存请求结果（*isCache = true;）
 */
typedef void(^TJBaseRequestCompletionBlock)(TJBaseRequest * _Nonnull request,BOOL * _Nonnull isCache);

/**
 请求进度回调
 
 progress 当前进度
 */
typedef void(^TJBaseRequestProgressBlock)(NSProgress * _Nullable progress);

/**
 根据AF上传接口声明文件配置回调
 
 formData 表单数据
 */
typedef void (^TJConstructBodyBlock)(id<AFMultipartFormData> _Nullable formData);

/** HTTP Request method.*/
typedef NS_ENUM(NSInteger, TJRequestMethod) {
    TJRequestMethodGET      = 0 ,///< get 请求
    TJRequestMethodPOST         ,///< post 请求
    TJRequestMethodDELETE       ,///< delete 请求
};

/**
 该类为整个框架的核心，在项目中主要使用该类相关API即可完成数据获取、下载、上传等操作；

 该类遵循TJBaseRequestProtocol协议，用于使用TJNetworkConfig类对框架做一些全局配置
 */
@interface TJBaseRequest : NSObject<TJBaseRequestProtocol>
#pragma mark --------------- Propertys
/// ---------------------------------------------------
/// @name Propertys
/// ---------------------------------------------------
/// 请求会话
@property (nonatomic, strong, readonly) NSURLSessionTask * _Nullable requestTask;

///  当前请求，等同于 `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest * _Nullable currentRequest;

///  原始请求，等同于`requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest * _Nullable originalRequest;

/// 请求地址
@property (nonatomic, copy) NSString * _Nullable url;

/// 请求参数
@property (nonatomic, strong, nullable) id parameter;

/** 请求模式，默认TJRequestMethodGET
 
 @see TJRequestMethod
 */
@property (nonatomic, assign) TJRequestMethod requestMethod;

/// 断点续传的恢复路径
@property (nonatomic, copy) NSString * _Nullable resumePath;

/// 请求转换后结果，默认 result = originalResult;
@property (nonatomic, strong, nullable) id result;

/// 请求原始结果，默认返回NSData，下载返回NSString（文件缓存路径）
@property (nonatomic, strong, nullable) id originalResult;

/// 请求错误
@property (nonatomic, strong, nullable) NSError *error;

/**
 请求完成回调,响应序列化为NSData，下载result返回NSURL（文件缓存路径）
 
 @see TJBaseRequestCompletionBlock
 */
@property (nonatomic, copy) TJBaseRequestCompletionBlock _Nullable complete;

/**
 请求进度（上传、下载）
 
 @see TJBaseRequestProgressBlock
 */
@property (nonatomic, copy) TJBaseRequestProgressBlock _Nullable progress;

/**
 配置下载缓存路径，是否可继续下载
 
 @see TJRequestDownloadCachePathBlock
 */
@property (nonatomic, copy) TJRequestDownloadCachePathBlock _Nullable downloadCachePathBlock;

/**
 可以使用它构造HTTP主体上传文件，默认是nil。
 
 @warning 上传文件应当用“POST”模式请求，不支持@"GET",@"HEAD"请求
 @see TJConstructBodyBlock
 */
@property (nonatomic, copy, nullable) TJConstructBodyBlock constructingBodyBlock;

#pragma mark --------------- Class Methods
/// ---------------------------------------------------
/// @name Class Methods
/// ---------------------------------------------------
/**
 构建一个TJBaseRequest实例
 */
+ (instancetype _Nonnull )request;

/*!
 *  配置get请求URL和参数，并启动会话
 *
 *  @param url          接口地址
 *  @param parameter    请求参数
 *  @param complete     请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (void)get:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;

/*!
 *  配置post请求URL和参数，并启动会话
 *
 *  @param url     请求地址URL
 *  @param parameter 参数
 *  @param complete  请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (void)post:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;

/*!
 *  配置delete请求URL和参数，并启动会话
 *
 *  @param url     请求地址URL
 *  @param parameter 参数
 *  @param complete  请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (void)delet:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;

/*!
 *  配置上传文件,参数,上传的数据，并启动会话,该函数用“POST”
 *
 *  @param url     上传服务器URL
 *  @param parameter 参数
 *  @param bodyBlock 需要上传的表单数据（详细使用参见：AFURLRequestSerialization.h）TJConstructBodyBlock
 *  @param complete  请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (void)upload:(NSString *_Nullable)url parameter:(id _Nullable )parameter bodyBlock:(TJConstructBodyBlock _Nullable )bodyBlock complete:(TJBaseRequestCompletionBlock _Nullable )complete;

/*!
 *  配置上传目的地URL,参数,下载内容存储地，并启动会话,该函数用“GET”
 *
 *  @param url     下载URL
 *  @param parameter 参数
 *  @param resumePath 断点继续下载地址
 *  @param cachePath 下载内容缓存地址 TJRequestDownloadCachePathBlock
 *  @param progress 下载进度 TJBaseRequestProgressBlock
 *  @param complete  请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (void)download:(NSString *_Nullable)url parameter:(id _Nullable )parameter resumePath:(NSString *_Nullable)resumePath downloadCachePath:(TJRequestDownloadCachePathBlock _Nullable )cachePath progress:(TJBaseRequestProgressBlock _Nullable )progress complete:(TJBaseRequestCompletionBlock _Nullable )complete;

/*!
 *  配置自定义请求，并启动会话
 *
 *  @param request   请求对象配置
 *  @param complete  请求完成的回调 TJBaseRequestCompletionBlock
 */
+ (TJBaseRequest *_Nonnull)custom:(TJBaseRequest *_Nullable(^_Nullable)(void))request complete:(TJBaseRequestCompletionBlock _Nullable )complete;

#pragma mark --------------- Instance Methods
/// ---------------------------------------------------
/// @name Instance Methods
/// ---------------------------------------------------
/** 开始当前请求 */
- (void)startRequest;

/**
 开始当前请求,带请求完成回调

 @param complete 请求完成回调 TJBaseRequestCompletionBlock
 */
- (void)startRequestWithCompleteBlock:(TJBaseRequestCompletionBlock _Nullable )complete;

/**
 读取缓存

 @return 缓存结果,无缓存返回nil
 */
- (id<NSCoding>_Nullable)readCache;

/**
 读取缓存,异步
 
 @param block 读取到缓存结果回调
 */
- (void)readCacheBlock:(void(^_Nullable)(NSString * _Nonnull key, id<NSCoding> _Nullable object))block;

/** 取消当前请求 */
- (void)cancel;

@end

