//
//  LoginModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

- (void)loginWithuserImformation:(NSDictionary*)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;
+ (void)autoLoginSuccess:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
