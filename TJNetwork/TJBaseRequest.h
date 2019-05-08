//
//  TJBaseRequest.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBaseRequestProtocol.h"

///  HTTP Request method.
typedef NS_ENUM(NSInteger, TJRequestMethod) {
    TJRequestMethodGET      = 0 ,
    TJRequestMethodPOST         ,
    TJRequestMethodDELETE       ,
};

@class TJBaseRequest;
typedef void(^TJBaseRequestCompletionBlock)(TJBaseRequest * _Nonnull request,BOOL * _Nonnull isCache);
typedef void(^TJBaseRequestProgressBlock)(NSProgress * _Nullable progress);
typedef NSString *_Nonnull(^TJRequestDownloadCachePathBlock)(NSURLResponse * _Nonnull response);

@protocol AFMultipartFormData;
/// 根据AF上传接口声明文件配置回调
typedef void (^TJConstructBodyBlock)(id<AFMultipartFormData> _Nullable formData);



@interface TJBaseRequest : NSObject<TJBaseRequestProtocol>
/// 请求会话
@property (nonatomic, strong, readonly) NSURLSessionTask * _Nullable requestTask;
///  Shortcut for `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest * _Nullable currentRequest;
///  Shortcut for `requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest * _Nullable originalRequest;
/// 请求地址
@property (nonatomic, copy) NSString * _Nullable url;
/// 请求参数
@property (nonatomic, strong, nullable) id parameter;
/// 请求模式，默认TJRequestMethodGET
@property (nonatomic, assign) TJRequestMethod requestMethod;
/// 断点续传的恢复路径
@property (nonatomic, copy) NSString * _Nullable resumePath;
/// 请求转换后结果，默认 result = originalResult;
@property (nonatomic, strong, nullable) id result;
/// 请求原始结果，默认返回NSData，下载返回NSString（文件缓存路径）
@property (nonatomic, strong, nullable) id originalResult;
/// 请求错误
@property (nonatomic, strong, nullable) NSError *error;
/// 请求完成回调,响应序列化为NSData，下载result返回NSURL（文件缓存路径）
@property (nonatomic, copy) TJBaseRequestCompletionBlock _Nullable complete;
/// 请求进度（上传、下载）
@property (nonatomic, copy) TJBaseRequestProgressBlock _Nullable progress;
/// 配置下载缓存路径，是否可继续下载
@property (nonatomic, copy) TJRequestDownloadCachePathBlock _Nullable downloadCachePathBlock;
/// 可以使用它构造HTTP主体上传文件，默认是nil。
/// 上传文件应当用“POST”模式请求，不支持@"GET",@"HEAD"请求
@property (nonatomic, copy, nullable) TJConstructBodyBlock constructingBodyBlock;
#pragma mark --------------- 类方法

+ (instancetype _Nonnull )request;

/** 配置get请求URL和参数，并启动会话 */
+ (void)get:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 配置post请求URL和参数，并启动会话 */
+ (void)post:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 配置delete请求URL和参数，并启动会话 */
+ (void)delet:(NSString *_Nullable)url parameter:(id _Nullable )parameter complete:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 配置上传文件,参数,上传的数据，并启动会话,该函数用“POST” */
+ (void)upload:(NSString *_Nullable)url parameter:(id _Nullable )parameter bodyBlock:(TJConstructBodyBlock _Nullable )bodyBlock complete:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 配置上传目的地URL,参数,下载内容存储地，并启动会话,该函数用“GET” */
+ (TJBaseRequest *_Nonnull)download:(NSString *_Nullable)url parameter:(id _Nullable )parameter resumePath:(NSString *_Nullable)resumePath downloadCachePath:(TJRequestDownloadCachePathBlock _Nullable )cachePath progress:(TJBaseRequestProgressBlock _Nullable )progress complete:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 配置自定义请求，并启动会话 */
+ (TJBaseRequest *_Nonnull)custom:(TJBaseRequest *_Nullable(^_Nullable)(void))request complete:(TJBaseRequestCompletionBlock _Nullable )complete;


#pragma mark --------------- 实例方法
/** 开始当前请求 */
- (void)startRequest;

- (void)startRequestWithCompleteBlock:(TJBaseRequestCompletionBlock _Nullable )complete;
/** 读取缓存 */
- (void)readCacheBlock:(void(^_Nullable)(id _Nullable result))block;
/** 取消当前请求 */
- (void)cancel;

@end

