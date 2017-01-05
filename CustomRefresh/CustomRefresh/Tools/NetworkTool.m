//
//  NetworkTool.m
//  MangoFinance
//
//  Created by 叶明君 on 16/8/12.
//  Copyright © 2016年 wim. All rights reserved.
//

#import "NetworkTool.h"
#import "NSString+Unicode.h"
#import "NSString+Util.h"
#import "APIBuilder.h"
#import "NSDictionary+SafeObject.h"

@interface NetworkTool() <NetworkDelegate>
{
    AFURLSessionManager *_manager;
    NSDictionary *_parameters;
//    NSURL *_url;
    NSMutableURLRequest *_request;
    NSURLSessionDataTask *_sessionDataTask;
    NSString *_describe;
}

@end

@implementation NetworkTool

static NSString *sole = @"d0c2993aaaff1af2bf3725f858fb8b5b";

- (id)init{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"app3" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = YES;
//        securityPolicy.pinnedCertificates = certSet;
//        _manager.securityPolicy = securityPolicy;
    }
    return self;
}


- (void)getWithURLString:(NSString *)urlString
              parameters:(NSArray*)parameterArray
            unParameters:(NSDictionary *)unParameters {
    _parameters = [self md5Parameter:parameterArray withUrlString:urlString];
    NSDictionary *requestDictionary = [self mergeParameter:_parameters unParameter:unParameters];
    
    urlString = [BaseUrl stringByAppendingPathComponent:urlString];
    _request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                URLString:urlString
                                                                parameters:requestDictionary
                                                                error:nil];
    [_request setTimeoutInterval:10];
    _sessionDataTask = [_manager dataTaskWithRequest:_request
                                             completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error){
        if (responseObject) {
            if ([_delegate respondsToSelector:@selector(request:didReceiveData:)]) {
                [_delegate request:self didReceiveData:responseObject];
            }
        }
        if (error) {
            _describe = error.description;
            [self performSelector:@selector(setReceiveErrer) withObject:nil afterDelay:2.0f];
            if ([_delegate respondsToSelector:@selector(request:didReceiveError:)]) {
                [error.description unicodeToString];
                [_delegate request:self didReceiveError:error.description];
            }
            if (error.code == NSURLErrorTimedOut) {
                [self sendTimeOut];
            }
        }
     }];
    [_sessionDataTask resume];
    if ([_delegate respondsToSelector:@selector(requestStart:)]) {
        [_delegate requestStart:self];
    }
}

// cancel
- (void)cancel {
    [_sessionDataTask cancel];
}


// sendTimeOut
- (void)sendTimeOut{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RequstStatus" object:nil];
}




// md5Key
- (NSDictionary *)md5Parameter:(NSArray *)parameterArray withUrlString:(NSString *)urlStr {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [array addObject:urlStr];
    for (NSDictionary *dic in parameterArray) {
        NSString *key = [dic.allKeys objectAtIndex:0];
        NSString *value = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:key]];
        [array addObject:value];
        [parameters setObject:value forKey:key];
    }
    NSString *keyStr = [APIBuilder getKeyString:array];
    [parameters setValue:keyStr forKey:@"keyStr"];
    return parameters;
}


- (NSDictionary *)mergeParameter:(NSDictionary *)parameter unParameter:(NSDictionary *)unParameter {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    [mDic addEntriesFromDictionary:unParameter];
    return mDic;
}





@end
