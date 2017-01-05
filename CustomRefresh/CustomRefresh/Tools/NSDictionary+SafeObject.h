//
//  NSDictionary+SafeObject.h
//  NTV_Main
//
//  Created by 邬明 on 15/5/21.
//  Copyright (c) 2015年 hktv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeObject)

- (NSString *)safeObjectForKey:(id)key;

- (void)setSafeValue:(id)value key:(NSString*)key;

- (BOOL)checkObjectExit:(NSString *)key;


@end
