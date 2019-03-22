//
//  XCBaseRequest.h
//  XCNetworking
//  Created by Tang杰 on 2019/3/21.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCBaseRequestProtocol.h"

///  HTTP Request method.
typedef NS_ENUM(NSInteger, XCRequestMethod) {
    XCRequestMethodGET      = 0 ,
    XCRequestMethodPOST         ,
    XCRequestMethodDELETE       ,
};

@class XCBaseRequest;
typedef void(^XCBaseRequestCompletionBlock)(XCBaseRequest *request,BOOL *isCache);
typedef void(^XCBaseRequestProgressBlock)(NSProgress *progress);
typedef NSString *(^XCRequestDownloadCachePathBlock)(NSURLResponse *response);

@protocol AFMultipartFormData;
/// 根据AF上传接口声明文件配置回调
typedef void (^XCConstructBodyBlock)(id<AFMultipartFormData> formData);

@interface XCBaseRequest : NSObject<XCBaseRequestProtocol>
/// 请求会话
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;
///  Shortcut for `requestTask.currentRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *currentRequest;
///  Shortcut for `requestTask.originalRequest`.
@property (nonatomic, strong, readonly) NSURLRequest *originalRequest;
/// 请求地址
@property (nonatomic, copy) NSString *url;
/// 请求参数
@property (nonatomic, strong, nullable) id parameter;
/// 请求模式，默认XCRequestMethodGET
@property (nonatomic, assign) XCRequestMethod requestMethod;
/// 断点续传的恢复路径
@property (nonatomic, copy) NSString *resumePath;
/// 请求转换后结果，默认 result = originalResult;
@property (nonatomic, strong, nullable) id result;
/// 请求原始结果，默认返回NSData，下载返回NSString（文件缓存路径）
@property (nonatomic, strong, nullable) id originalResult;
/// 请求错误
@property (nonatomic, strong, nullable) NSError *error;
/// 请求完成回调,响应序列化为NSData，下载result返回NSURL（文件缓存路径）
@property (nonatomic, copy) XCBaseRequestCompletionBlock complete;
/// 请求进度（上传、下载）
@property (nonatomic, copy) XCBaseRequestProgressBlock progress;
/// 配置下载缓存路径，是否可继续下载
@property (nonatomic, copy) XCRequestDownloadCachePathBlock downloadCachePathBlock;
/// 可以使用它构造HTTP主体上传文件，默认是nil。
/// 上传文件应当用“POST”模式请求，不支持@"GET",@"HEAD"请求
@property (nonatomic, copy, nullable) XCConstructBodyBlock constructingBodyBlock;
#pragma mark --------------- 类方法

+ (instancetype)request;

/** 配置get请求URL和参数，并启动会话 */
+ (void)get:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete;
/** 配置post请求URL和参数，并启动会话 */
+ (void)post:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete;
/** 配置delete请求URL和参数，并启动会话 */
+ (void)delet:(NSString *)url parameter:(id)parameter complete:(XCBaseRequestCompletionBlock)complete;
/** 配置上传文件,参数,上传的数据，并启动会话,该函数用“POST” */
+ (void)upload:(NSString *)url parameter:(id)parameter bodyBlock:(XCConstructBodyBlock)bodyBlock complete:(XCBaseRequestCompletionBlock)complete;
/** 配置上传目的地URL,参数,下载内容存储地，并启动会话,该函数用“GET” */
+ (XCBaseRequest *)download:(NSString *)url parameter:(id)parameter resumePath:(NSString *)resumePath downloadCachePath:(XCRequestDownloadCachePathBlock)cachePath progress:(XCBaseRequestProgressBlock)progress complete:(XCBaseRequestCompletionBlock)complete;
/** 配置自定义请求，并启动会话 */
+ (XCBaseRequest *)custom:(XCBaseRequest *(^)(void))request complete:(XCBaseRequestCompletionBlock)complete;


#pragma mark --------------- 实例方法
/** 开始当前请求 */
- (void)startRequestWithCompleteBlock:(XCBaseRequestCompletionBlock)complete;
/** 读取缓存 */
- (void)readCacheBlock:(void(^)(id result))block;
/** 取消当前请求 */
- (void)cancel;

@end

