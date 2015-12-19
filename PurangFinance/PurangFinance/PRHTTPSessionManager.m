//
//  PRHTTPSessionManager.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PRHTTPSessionManager.h"

static PRHTTPSessionManager *client = nil;

@implementation PRHTTPSessionManager

+ (PRHTTPSessionManager*)sharePRHTTPSessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[PRHTTPSessionManager alloc] initWithBaseURL:nil];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //        client.securityPolicy.allowInvalidCertificates = YES;
    });
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    return client;
}


@end
