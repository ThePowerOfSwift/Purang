//
//  PersonalCenterModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PersonalCenterModel.h"
#import "PRHTTPSessionManager.h"
#import "LoginModel.h"

@implementation PersonalCenterModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleArray = @[@"手机号",@"公司名称",@"实名认证",@"联系人",@"修改密码",@"修改账号信息"];
//        _detailArray = @[@"139 1676 2345",@"上海普兰金融服务有限公司",@"上海",@"已认证",@"张三",@""];
        _information = @{@"accountStatus":@"-1",@"contactName":@"",@"phoneNumber":@""};
    }
    return self;
}

- (void)getPersonalInformationSuccess:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* personalManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_PERSONALCENTER);
    NSLog(@"url:%@",url);
    
    [personalManager POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        self.information = responseObject;
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            success();
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error%@",error);
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self getPersonalInformationSuccess:success failure:failure];
                    
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
                
                [self getPersonalInformationSuccess:success failure:failure];
                
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
