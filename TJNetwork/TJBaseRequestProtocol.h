//
//  TJBaseRequestProtocol.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/22.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#ifndef TJBaseRequestProtocol_h
#define TJBaseRequestProtocol_h

/// 请求序列化方式
typedef NS_ENUM(NSUInteger, TJRequestSerializer) {
    TJHTTPRequestSerializer,
    TJJSONRequestSerializer,
};
/// 响应序列化方式
typedef NS_ENUM(NSUInteger, TJResponseSerializer) {
    TJHTTPResponseSerializer,
    TJJSONResponseSerializer,
    TJXMLParserResponseSerializer,
    TJXMLDocumentResponseSerializer,
    TJPropertyListResponseSerializer,
    TJImageResponseSerializer,
};

@protocol TJBaseRequestProtocol <NSObject>

/// 请求序列化方式，默认TJHTTPRequestSerializerr
@property (nonatomic, assign) TJRequestSerializer requestSerializer;
/// 请求序列化方式，默认TJHTTPResponseSerializer
@property (nonatomic, assign) TJResponseSerializer responseSerializer;
/// 请求超时时长，默认60秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 请求用户名
@property (nonatomic, copy, nullable) NSString *username;
/// 请求用户密码
@property (nonatomic, copy, nullable) NSString *password;
/// 是否缓存请求结果，缓存的转换后的结果
@property (nonatomic, assign) BOOL isCache;
/** 请求头字段值。AF默认添加以下内容:
 User-Agent : '项目标示和设备信息',TJNetworking/0.0.1 (iPhone; iOS 12.0; Scale/2.00),
 Accept-Language : '系统语言',zh-Hans-CN;q=1,
 */
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *requestHeaders;

@end


#endif /* TJBaseRequestProtocol_h */
