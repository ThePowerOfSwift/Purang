//
//  LoginModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "LoginModel.h"
#import "AppDelegate.h"
#import "PRFileManager.h"

@implementation LoginModel

- (void)loginWithuserImformation:(NSDictionary*)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* loginManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_LOGIN);
    NSLog(@"login:url = %@",url);
    NSLog(@"login:user = %@",userInformation);
    [loginManager POST:url parameters:userInformation success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            AppDelegate* app = [[UIApplication sharedApplication] delegate];
            app.isLogin = YES;
            
            NSMutableDictionary* userDic = [[NSMutableDictionary alloc]initWithDictionary:userInformation];
            [userDic setObject:[responseObject valueForKey:@"userId"] forKey:@"userId"];
            [userDic setObject:[responseObject valueForKey:@"encryptRandom"] forKey:@"encryptRandom"];
            [userDic setObject:[responseObject valueForKey:@"accountStatus"] forKey:@"accountStatus"];
            if ([responseObject valueForKey:@"userRealName"])
            {
                [userDic setObject:[responseObject valueForKey:@"userRealName"] forKey:@"userRealName"];
            }
            
            if ([[responseObject valueForKey:@"accountStatus"] integerValue] == 1 || [[responseObject valueForKey:@"accountStatus"] integerValue] == 0 )
            {
                if ([responseObject valueForKey:@"companyName"]) {
                    [userDic setObject:[responseObject valueForKey:@"companyName"] forKey:@"companyName"];
                }
                if ([responseObject valueForKey:@"userRealName"]) {
                    [userDic setObject:[responseObject valueForKey:@"userRealName"] forKey:@"userRealName"];
                }
                
            }
//            NSLog(@"userDic:%@",userDic);
            PRFileManager* fileManager = [PRFileManager sharePRFileManager];
            [fileManager removeUserInformationFile];
            [fileManager writeUserInformationTofileWithUserInformation:userDic];
            
            success();
        }
        else
        {
            AppDelegate* app = [[UIApplication sharedApplication] delegate];
            app.isLogin = NO;
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(0);
        NSLog(@"error:%@",error);
        
    }];
}

+ (void)autoLoginSuccess:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRFileManager* fileManager = [PRFileManager sharePRFileManager];
    if ([fileManager checkUserInformationFileExist])
    {
        NSMutableDictionary* userInformation = [fileManager readUserInformationFile];
        PRHTTPSessionManager* loginManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
        NSString* url = URL_HEAD(URL_LOGIN);
        NSLog(@"login:url = %@",url);
//        NSLog(@"login:user = %@",userInformation);
        [loginManager POST:url parameters:@{@"userName":userInformation[@"userName"],@"password":userInformation[@"password"]} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"responseObject:%@",responseObject);
            if ([responseObject[@"success"] isEqualToString:@"true"])
            {
                AppDelegate* app = [[UIApplication sharedApplication] delegate];
                app.isLogin = YES;
                NSMutableDictionary* userDic = [[NSMutableDictionary alloc]initWithDictionary:userInformation];
                
                [userDic setObject:[responseObject valueForKey:@"userId"] forKey:@"userId"];
                [userDic setObject:[responseObject valueForKey:@"encryptRandom"] forKey:@"encryptRandom"];
                [userDic setObject:[responseObject valueForKey:@"accountStatus"] forKey:@"accountStatus"];
                if ([responseObject valueForKey:@"userRealName"])
                {
                    [userDic setObject:[responseObject valueForKey:@"userRealName"] forKey:@"userRealName"];
                }
                if ([[responseObject valueForKey:@"accountStatus"] integerValue] == 1 || [[responseObject valueForKey:@"accountStatus"] integerValue] == 0 )
                {
                    
                    if ([responseObject valueForKey:@"companyName"])
                    {
                        [userDic setObject:[responseObject valueForKey:@"companyName"] forKey:@"companyName"];
                    }
                    if ([responseObject valueForKey:@"userRealName"])
                    {
                        [userDic setObject:[responseObject valueForKey:@"userRealName"] forKey:@"userRealName"];
                    }
                }
//                else if ([[responseObject valueForKey:@"accountStatus"] integerValue] == 1 || [[responseObject valueForKey:@"accountStatus"] integerValue] == 0 )
//                {
//                    
//                    [userDic setObject:[responseObject valueForKey:@"companyName"] forKey:@"companyName"];
//                    [userDic setObject:[responseObject valueForKey:@"userRealName"] forKey:@"userRealName"];
//                }
                
                PRFileManager* fileManager = [PRFileManager sharePRFileManager];
                [fileManager removeUserInformationFile];
                [fileManager writeUserInformationTofileWithUserInformation:userDic];
                success();
            }
            else
            {
                AppDelegate* app = [[UIApplication sharedApplication] delegate];
                app.isLogin = NO;
                failure([responseObject[@"responseCode"] integerValue]);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failure(0);
            NSLog(@"error:%@",error);
            
        }];
    }
}

@end
