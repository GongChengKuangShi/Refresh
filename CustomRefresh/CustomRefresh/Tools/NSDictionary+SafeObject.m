//
//  NSDictionary+SafeObject.m
//  NTV_Main
//
//  Created by 邬明 on 15/5/21.
//  Copyright (c) 2015年 hktv. All rights reserved.
//

#import "NSDictionary+SafeObject.h"

#define checkNull(__X__)  (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]



@implementation NSDictionary (SafeObject)


- (NSString *)safeObjectForKey:(id)key{
    return checkNull([self objectForKey:key]);
}

- (BOOL)checkObjectExit:(NSString *)key
{
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]] || [[self objectForKey:key] isEqual:[NSNull null]]) {
        return NO;
    }
    return YES;
}


- (void)setSafeValue:(id)value key:(NSString*)key{
    if (value == nil && [value isKindOfClass:[NSNull class]]) {
        value = @"";
    }
    [self setValue:value forKey:key];
}


@end
