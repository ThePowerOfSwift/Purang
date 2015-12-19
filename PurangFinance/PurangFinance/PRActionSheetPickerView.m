//
//  PRActionSheetPickerView.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PRActionSheetPickerView.h"

@implementation PRActionSheetPickerView
{
    UIDatePicker* datePicker;
    UIView* backView;
    UIView* buttomView;
    
    CGFloat width;
    CGFloat height;
    UIButton* cancelButton;
    UIButton* doneButton;
    NSInteger _idNum;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        width = [UIDevice width];
        height = [UIDevice height];
//        self.alpha = 0.5;
        self.frame = CGRectMake(0, 0, width, height);
        self.backgroundColor = [UIColor clearColor];
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height - 300)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0;
        [self addSubview:backView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [backView addGestureRecognizer:tap];
        
        buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, 300)];
        buttomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttomView];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, height + 40, width, 0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor whiteColor];
        
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
//        cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        cancelButton.frame = CGRectMake(10, height - 300, 60, 40);
//        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
////        cancelButton.backgroundColor = [UIColor blueColor];
//        cancelButton.layer.masksToBounds = YES;
//        cancelButton.layer.cornerRadius = 5;
//        [self addSubview:cancelButton];
        
        doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneButton.frame = CGRectMake(width - 70, height, 50, 40);
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor colorFromHexCode:@"4E98D5"] forState:UIControlStateNormal];
//        doneButton.backgroundColor = [UIColor blueColor];
        doneButton.layer.masksToBounds = YES;
        doneButton.layer.cornerRadius = 5;
        [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
    }
    return self;
}

- (void)dateChanged:(id)sender
{
//    UIDatePicker* picker = (UIDatePicker*)sender;
//    NSDate* date = picker.date;
//    NSLog(@"%@",date);
}

- (void)showDatePickerInView:(UIView*)view withId:(NSInteger)idNum
{
    _idNum = idNum;
    [view addSubview:self];
    if (_idNum == 1)
    {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:15552000];
//        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:-15552000];
        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
////        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
////        NSUInteger numberOfDaysInMonth = range.length;
//        
//        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
//        [dateformat setDateFormat:@"yyyy-MM-dd"];
//        
//        NSDate* date = [dateformat dateFromString:@"2015-3-1"];
//        
//        NSDateComponents *comps = nil;
//        
//        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
////
//        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//        
//        [adcomps setYear:0];
//        
//        [adcomps setMonth:0];
//        
//        [adcomps setDay:-1];//时差问题，显示结果2.27
//        [adcomps setHour:8];
////
////        
//        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
//
        [datePicker setDate:date animated:NO];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        buttomView.frame = CGRectMake(0, height - 300, width, 300);
        datePicker.frame = CGRectMake(0, height - 260, width, 0);
        doneButton.frame = CGRectMake(width - 70, height - 300, 50, 40);
        backView.alpha = 0.5;
        
    }];
}

- (void)tap:(UITapGestureRecognizer*)tap
{
    [self dismissFromSuperView];
}

- (void)doneButtonClick:(id)sender
{
    NSDate* date = datePicker.date;
//    NSLog(@"%@",date);
    [_delegate getDateWithDate:date andId:_idNum];
    [self dismissFromSuperView];
}

- (void)dismissFromSuperView
{
    [UIView animateWithDuration:0.2 animations:^{
        
        datePicker.frame = CGRectMake(0, height + 40, width, 0);
        doneButton.frame = CGRectMake(width - 70, height, 50, 40);
        buttomView.frame = CGRectMake(0, height, width, 300);
        backView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
