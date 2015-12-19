//
//  PRView.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface PRView : UIView

@property(assign,nonatomic)IBInspectable CGFloat cornerRadius;
@property(assign,nonatomic)IBInspectable CGFloat borderWidth;
@property(retain,nonatomic)IBInspectable UIColor* borderColor;

@end
