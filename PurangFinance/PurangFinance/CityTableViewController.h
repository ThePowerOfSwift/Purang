//
//  CityTableViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityTableViewControllerDelegate <NSObject>

- (void)getCityWithCityName:(NSString*)cityName;
- (void)getCityCode:(NSString*)cityCode;

@end

@interface CityTableViewController : UIViewController

typedef NS_ENUM(NSInteger, CityTableViewControllerType)
{
    DiscountType ,//贴现
    PersonalCenterType ,//个人中心
};

@property(assign,nonatomic) id<CityTableViewControllerDelegate> delegate;
@property(assign,nonatomic) CityTableViewControllerType type;

@end
