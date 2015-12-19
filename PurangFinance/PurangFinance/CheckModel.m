//
//  CheckModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CheckModel.h"
#import "PRHTTPSessionManager.h"
#import "LoginModel.h"

@implementation CheckModel
{
    NSUInteger pageNum;
}

static NSString* hasMore;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        NSDictionary* dictionary = @{@"type":@"check_yinpiao.png",@"bankCode":@"check_icbc.png",@"bankName":@"工商银行上海分行",@"percent":@"6.35‰",@"date":@"2015-10-14到期",@"limit":@"185天",@"amount":@"300.85万",@"state":@"待撮合"};
        _checkList = [[NSMutableArray alloc]init];
        pageNum = 1;
    }
    return self;
}

- (void)getCheck:(NSDictionary*)check success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* checkManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_SEARCH);
    NSLog(@"url:%@",url);
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]initWithDictionary:check];
    if ([dictionary[@"refresh"] isEqualToString:@"new"])
    {
        pageNum = 1;
        [dictionary setObject:[NSString stringWithFormat:@"%ld",(unsigned long)pageNum] forKey:@"pageIndex"];
        NSLog(@"%@",dictionary);
        [checkManager POST:url parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject%@",responseObject);
            
            hasMore = responseObject[@"hasMore"];
            
            if ([responseObject[@"success"] isEqualToString:@"true"])
            {
                NSArray* response = responseObject[@"data"];
                [_checkList removeAllObjects];
                [_checkList addObjectsFromArray:response];
                success();
            }
            else
            {
                failure(1);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"error:%@",error);
            if ([UIDevice getiOSVersion] < 8.0)
            {
                NSRange range = [error.localizedDescription rangeOfString:@"401"];
                if (range.location > 0 && range.location < error.localizedDescription.length)
                {
                    [LoginModel autoLoginSuccess:^{
                        
                        [self getCheck:check success:success failure:failure];
                        
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
                    
                    [self getCheck:check success:success failure:failure];
                    
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
    else
    {
        if ([hasMore isEqualToString:@"true"])
        {
            pageNum ++;
            [dictionary setObject:[NSString stringWithFormat:@"%ld",(unsigned long)pageNum] forKey:@"pageIndex"];
            NSLog(@"%@",dictionary);
            [checkManager POST:url parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"responseObject%@",responseObject);
                
                hasMore = responseObject[@"hasMore"];
                
                if ([responseObject[@"success"] isEqualToString:@"true"])
                {
                    NSArray* response = responseObject[@"data"];
                    [_checkList addObjectsFromArray:response];
                    success();
                }
                else
                {
                    failure(1);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"error:%@",error);
                if ([UIDevice getiOSVersion] < 8.0)
                {
                    NSRange range = [error.localizedDescription rangeOfString:@"401"];
                    if (range.location > 0 && range.location < error.localizedDescription.length)
                    {
                        [LoginModel autoLoginSuccess:^{
                            
                            [self getCheck:check success:success failure:failure];
                            
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
                        
                        [self getCheck:check success:success failure:failure];
                        
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
        else
        {
            failure(0);
        }
    }
    
    
    
}

@end
