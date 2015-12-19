//
//  PRWaitingView.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PRWaitingView.h"

@implementation PRWaitingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat width = [UIDevice width];
        CGFloat height = [UIDevice height];
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.center = CGPointMake(width/2.0, height/2.0);
        [activityIndicatorView startAnimating];
        [self addSubview:activityIndicatorView];
        
    }
    return self;
}

- (void)showInView:(UIView*)supView
{
    [supView addSubview:self];
}

- (void)remove
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
