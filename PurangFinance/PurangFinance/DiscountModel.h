//
//  DiscountModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountModel : NSObject

- (void)submit:(NSDictionary*)information frontImage:(NSArray*)frontImage backImage:(NSArray*)backImage success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
