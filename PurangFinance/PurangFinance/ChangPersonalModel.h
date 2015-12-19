//
//  ChangPersonalModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/25.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangPersonalModel : NSObject

- (void)changePersonal:(NSDictionary*)personalInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

- (void)getVerifyCode:(NSDictionary*)phoneNumber success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
