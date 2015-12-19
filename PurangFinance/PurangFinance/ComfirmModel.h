//
//  ComfirmModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComfirmModel : NSObject

- (void)comfirm:(NSDictionary*)companyInformation license:(NSDictionary*)license success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
