//
//  RegistModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/7.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "RegistModel.h"
#import "LoginModel.h"

@implementation RegistModel

- (void)getVerifyCode:(NSString*)userString success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* getCodeManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_GETREGISTCODE);
    NSLog(@"regist:url = %@",url);

    NSDictionary* userInformation = @{@"userName":userString};
    NSLog(@"regist:user = %@",userInformation);
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

- (void)registWithUserInformation:(NSDictionary *)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* registManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_REGIST);
    NSLog(@"registModel:url = %@",url);
    NSLog(@"registModel:user = %@",userInformation);
    [registManager POST:url parameters:userInformation success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            
            LoginModel* loginModel = [LoginModel new];
            [loginModel loginWithuserImformation:userInformation success:^{
                
                success();
                
            } failure:^(NSInteger responseCode) {
                
                failure([responseObject[@"responseCode"] integerValue]);
                
            }];
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
}



@end
