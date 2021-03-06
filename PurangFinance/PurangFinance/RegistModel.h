//
//  RegistModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/7.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol RegistModelDelegate <NSObject>
//
//- (void)getVerify
//
//@end

@interface RegistModel : NSObject

- (void)getVerifyCode:(NSString*)userString success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;
- (void)registWithUserInformation:(NSDictionary*)userInformation success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
