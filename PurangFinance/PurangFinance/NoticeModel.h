//
//  NoticeModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/8.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property(copy,nonatomic)NSDictionary* billInformation;

- (void)query:(NSDictionary*)billNo success:(void (^)(id responseObject))success failure:(void (^)(NSInteger responseCode))failure;

@end
