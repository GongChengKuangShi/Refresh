//
//  APIBuilder.h
//  MangoFinance
//
//  Created by wim on 16/8/17.
//  Copyright © 2016年 wim. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaseUrl @"http://192.168.80.158:8080/mgjr-web-app/V2.0/"
//#define BaseUrl @"https://www.testhnmgjr.com/mgjr-web-app/V2.0/"

@interface APIBuilder : NSObject

+ (NSString*)getKeyString:(NSArray *)list;

+ (NSString*)tenderingList;

@end
