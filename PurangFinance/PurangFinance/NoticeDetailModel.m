//
//  NoticeDetailModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "NoticeDetailModel.h"

@implementation NoticeDetailModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _titleArray = @[@"汇票票号",@"申请人",@"公示日期",@"公示法院"];
        _detailArray = @[@"12345678 00000000",@"青岛宇航金属制品有限公司",@"2015-04-16",@"[山东]青岛市黄岛区人民法院"];
    }
    return self;
}


@end
