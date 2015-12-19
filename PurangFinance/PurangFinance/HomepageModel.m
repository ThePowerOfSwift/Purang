//
//  HomepageModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "HomepageModel.h"

@implementation HomepageModel


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _imageArray = @[@"Homepage_Discount.png",@"Homepage_Bill.png",@"Homepage_Calculator.png",@"Homepage_Notice.png",@"Homepage_PersonalCenter.png",@"Homepage_AboutUs.png"];
        _titleArray = @[@"我要贴现",@"我的账单",@"贴现计算器",@"公告票据",@"个人中心",@"关于我们"];
    }
    return self;
}


@end
