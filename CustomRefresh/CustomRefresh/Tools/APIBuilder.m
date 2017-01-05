//
//  APIBuilder.m
//  MangoFinance
//
//  Created by wim on 16/8/17.
//  Copyright © 2016年 wim. All rights reserved.
//

#import "APIBuilder.h"
#import "NSString+Util.h"
@implementation APIBuilder

static NSString *sole = @"d0c2993aaaff1af2bf3725f858fb8b5b";

+ (NSString*)getKeyString:(NSArray *)list {
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (NSString *str in list) {
        [mStr appendString:str];
    }
    [mStr appendString:sole];
    NSString *keyStr = [mStr md5ToString] ;
    return  keyStr ;
}

+ (NSString*)tenderingList{
    return @"appJmg/tenderingList";
}


@end
