//
//  NSString+Unicode.m
//  URLSessionDemo
//
//  Created by wim on 16/8/26.
//  Copyright © 2016年 wim. All rights reserved.
//

#import "NSString+Unicode.h"

@implementation NSString (Unicode)

- (NSString*)unicodeToString{
    NSData *unicodedStringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *string = [[NSString alloc] initWithData:unicodedStringData encoding:NSNonLossyASCIIStringEncoding];
    return string;
}

- (NSDictionary *)dictionaryWithJsonString{
    if (self.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
