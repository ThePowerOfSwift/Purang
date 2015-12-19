//
//  LocationModel.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/22.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationModelDelegate <NSObject>

- (void)getCityName:(NSString*)cityName;

@end

@interface LocationModel : NSObject

@property(assign,nonatomic) id<LocationModelDelegate> delegate;
@property(assign,nonatomic) BOOL isShow;

@end
