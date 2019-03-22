//
//  TJNetworkTools.m
//  TJNetworking
//  Created by Tang杰 on 2019/3/15.
//  Copyright © 2019 Tang杰. All rights reserved.
//

#import "TJNetworkTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation TJNetworkTools
+ (NSString *)URLWithString:(nullable NSString *)URLString relativeToURL:(nullable NSURL *)baseURL
{
    NSURL *temp = [NSURL URLWithString:URLString];
    //        如果URLString是一个完整的URL则不需要拼接baseUrl
    if (temp && temp.host && temp.scheme) {
        return URLString;
    }
    NSURL *URL = baseURL;
    if (baseURL.absoluteString.length > 0 && ![baseURL.absoluteString hasSuffix:@"/"]) {
        URL = [URL URLByAppendingPathComponent:@""];
    }
    
    URL = [NSURL URLWithString:URLString relativeToURL:URL];
    NSAssert((URL && URL.host && URL.scheme), @"请检查baseURL与URLString的值是否正确");
    return URL.absoluteString;
}

+ (NSString *)stringToMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
