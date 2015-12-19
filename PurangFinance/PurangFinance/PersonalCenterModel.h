//
//  PersonalCenterModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalCenterModel : NSObject

@property(retain,nonatomic)NSArray* titleArray;
@property(retain,nonatomic)NSArray* detailArray;
@property(retain,nonatomic)NSDictionary* information;

- (void)getPersonalInformationSuccess:(void (^)())success failure:(void (^)(NSInteger responseCode))failure;

@end
