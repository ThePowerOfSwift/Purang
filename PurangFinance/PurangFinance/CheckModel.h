//
//  CheckModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckModel : NSObject

@property(retain,nonatomic)NSMutableArray* checkList;

- (void)getCheck:(NSDictionary*)check success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
