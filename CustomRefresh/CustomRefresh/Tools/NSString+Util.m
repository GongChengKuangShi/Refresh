//
//  NSString+Utils.m
//  MangoFinance
//
//  Created by 叶明君 on 16/9/6.
//  Copyright © 2016年 wim. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Util)

#pragma mark  正则



#pragma mark 删除字符串空格
- (NSString *)deleteStringSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 加密
- (NSString *)md5ToString {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [[NSMutableString alloc] init];
    for(int i = 0; i< CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)base64{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}














@end
