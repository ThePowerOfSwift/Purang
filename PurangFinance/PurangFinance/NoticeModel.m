//
//  NoticeModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/8.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "NoticeModel.h"
#import "LoginModel.h"

@implementation NoticeModel

- (void)query:(NSDictionary*)billNo success:(void (^)(id responseObject))success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* noticeManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_QUERY);
    NSLog(@"url = %@",url);
    NSLog(@"billNo: %@",billNo);
    [noticeManager POST:url parameters:billNo success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        
        if ([[responseObject class] isSubclassOfClass:[NSDictionary class]])
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self query:billNo success:success failure:failure];
                    
                } failure:^(NSInteger responseCode) {
                    
                    failure(0);
                    
                }];
            }
            else
            {
                failure(0);
            }
        }
        else if ([error.localizedDescription containsString:@"401"])
        {
            [LoginModel autoLoginSuccess:^{
                
                [self query:billNo success:success failure:failure];
                
            } failure:^(NSInteger responseCode) {
                
                failure(0);
                
            }];
        }
        else
        {
            failure(0);
        }

    }];
}

@end
