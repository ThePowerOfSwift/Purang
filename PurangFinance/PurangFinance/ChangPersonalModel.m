//
//  ChangPersonalModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/25.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ChangPersonalModel.h"
#import "LoginModel.h"

@implementation ChangPersonalModel

- (void)changePersonal:(NSDictionary*)personalInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* changeManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_CHANGEINFORMATION);
    NSLog(@"url:%@",url);
    NSLog(@"personalInformation:%@",personalInformation);
//    NSLog(@"companyInformation:%@",companyInformation);
    
    [changeManager POST:url parameters:personalInformation success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"change responseObject:%@",responseObject);
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            success();
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error:%@",error);
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self changePersonal:personalInformation success:success failure:failure];
                    
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
                
                [self changePersonal:personalInformation success:success failure:failure];
                
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

- (void)getVerifyCode:(NSDictionary*)phoneNumber success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* verifyManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_CHANGECODE);
    NSLog(@"personal:url = %@",url);
    NSLog(@"phoneNumber:%@",phoneNumber);
    [verifyManager POST:url parameters:phoneNumber success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        
        NSLog(@"error:%@",error);
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self getVerifyCode:phoneNumber success:success failure:failure];
                    
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
                
                [self getVerifyCode:phoneNumber success:success failure:failure];
                
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
