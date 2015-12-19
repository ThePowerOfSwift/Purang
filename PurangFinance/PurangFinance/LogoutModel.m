//
//  LogoutModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/7.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "LogoutModel.h"
#import "AppDelegate.h"
#import "PRFileManager.h"

@implementation LogoutModel

+ (void)logoutSuccess:(void (^)())success
{
    PRHTTPSessionManager* logout = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_LOGOUT);
    
    [logout POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        app.isLogin = NO;
        [[PRFileManager sharePRFileManager]removeUserInformationFile];
        success();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        app.isLogin = NO;
        [[PRFileManager sharePRFileManager]removeUserInformationFile];
        success();
        
    }];
}

@end
