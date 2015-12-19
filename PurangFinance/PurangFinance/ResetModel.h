//
//  ResetModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/7.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResetModel : NSObject

- (void)getVerifyCode:(NSString*)userString success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;
- (void)resetWithUserInformation:(NSDictionary*)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
