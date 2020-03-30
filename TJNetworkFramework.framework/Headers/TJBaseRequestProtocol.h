//
//  TJBaseRequestProtocol.h
//  TJNetworking
//  Created by Tang杰 on 2019/3/22.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#ifndef TJBaseRequestProtocol_h
#define TJBaseRequestProtocol_h

/**
 请求序列化方式
 
 详情参见：AFURLRequestSerialization.h
 */
typedef NS_ENUM(NSUInteger, TJRequestSerializer) {
    TJHTTPRequestSerializer,
    TJJSONRequestSerializer,
};

/**
 响应序列化方式
 
 详情参见：AFURLResponseSerialization.h
 */
typedef NS_ENUM(NSUInteger, TJResponseSerializer) {
    TJHTTPResponseSerializer,
    TJJSONResponseSerializer,
    TJXMLParserResponseSerializer,
    TJXMLDocumentResponseSerializer,
    TJPropertyListResponseSerializer,
    TJImageResponseSerializer,
    TJCompoundResponseSerializer,
};

@protocol TJBaseRequestProtocol <NSObject>

/**
 请求序列化方式，默认TJHTTPRequestSerializerr
 @see TJRequestSerializer
 */
@property (nonatomic, assign) TJRequestSerializer requestSerializer;

/**
 请求序列化方式，默认TJHTTPResponseSerializer
 @see TJResponseSerializer
 */
@property (nonatomic, assign) TJResponseSerializer responseSerializer;

/// 请求超时时长，默认60秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/// 请求用户名
@property (nonatomic, copy, nullable) NSString *username;

/// 请求用户密码
@property (nonatomic, copy, nullable) NSString *password;

/// 是否缓存请求结果，缓存的转换后的结果
@property (nonatomic, assign) BOOL isCache;

/** 请求头字段值。
 
 @discussion AF默认添加以下内容:
 
 User-Agent : 'TJNetworking/0.0.1 (iPhone; iOS 12.0; Scale/2.00)',
 
 Accept-Language : 'zh-Hans-CN;q=1',
 */
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> * _Nullable requestHeaders;

@end


#endif /* TJBaseRequestProtocol_h */
