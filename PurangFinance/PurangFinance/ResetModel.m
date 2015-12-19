//
//  ResetModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/7.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ResetModel.h"
#import "LoginModel.h"

@implementation ResetModel

- (void)getVerifyCode:(NSString *)userString success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* getCodeManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_GETRESETCODE);
    NSLog(@"reset:url = %@",url);
    
    NSDictionary* userInformation = @{@"userName":userString};
    NSLog(@"reset:user = %@",userInformation);
    [getCodeManager POST:url parameters:userInformation success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            success();
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(0);
        NSLog(@"error:%@",error);
        
    }];
}

- (void)resetWithUserInformation:(NSDictionary *)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* resetManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_RESET);
    NSLog(@"resetModel:url:url = %@",url);
    NSLog(@"resetModel:url:user = %@",userInformation);
    [resetManager POST:url parameters:userInformation success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            success();
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(0);
        NSLog(@"error:%@",error);
        
    }];
}


@end
