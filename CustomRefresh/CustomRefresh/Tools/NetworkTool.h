//
//  NetworkTool.h
//  MangoFinance
//
//  Created by 叶明君 on 16/8/12.
//  Copyright © 2016年 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)

@class NetworkTool;

@protocol NetworkDelegate <NSObject>

@optional

- (void)requestStart:(NetworkTool*)networkTool;
- (void)request:(NetworkTool*)networkTool didReceiveData:(NSDictionary*)data;
- (void)request:(NetworkTool*)networkTool didReceiveError:(NSString*)error;

@end

@interface NetworkTool : NSObject

@property (nonatomic, weak) id <NetworkDelegate> delegate;


// get
- (void)getWithURLString:(NSString *)urlString
              parameters:(NSArray*)parameterArray
            unParameters:(NSDictionary*)unParameters;

// post
- (void)postWithURLString:(NSString *)urlString
               parameters:(NSArray*)parameterArray
             unParameters:(NSDictionary*)unParameters;

// upData
- (void)postWithURLString:(NSString *)urlString
               parameters:(NSArray *)parameterArray
                 withData:(NSData *)imageData;

//upbug
- (void)postWithURLString:(NSString *)urlString
            parametersDic:(NSDictionary *)parameter
             unParameters:(NSDictionary *)unParameters;


// cancel
- (void)cancel;



@end
