//
//  PRActionSheetPickerView.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PRActionSheetPickerViewDelegate <NSObject>

- (void)getDateWithDate:(NSDate*)date andId:(NSInteger)idNum;

@end

@interface PRActionSheetPickerView : UIView

@property(assign,nonatomic) id<PRActionSheetPickerViewDelegate> delegate;

- (void)showDatePickerInView:(UIView*)view withId:(NSInteger)idNum;


@end
