//
//  FrameView.m
//  LLSimpleCameraExample
//
//  Created by purang756 on 15/4/28.
//  Copyright (c) 2015年 Ömer Faruk Gül. All rights reserved.
//

#import "FrameView.h"
#import "UIDevice+UIDeviceCategory.h"

@implementation FrameView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(con, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
    
    CGContextFillRect(con, rect);
    
    CGContextClearRect(con, CGRectMake([UIDevice width]/8,[UIDevice height]/5*2,[UIDevice width]/4*3,[UIDevice height]/5));
    
//    //获得上下文句柄
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    //创建图形路径句柄
//    CGMutablePathRef path = CGPathCreateMutable();
//    //添加矩形到路径中         //设置矩形的边界
//    CGPathAddRect(path,NULL, CGRectMake([UIDevice width]/8, [UIDevice height]/5*2, [UIDevice width]- [UIDevice width]/4 , [UIDevice height]/5));
//    //添加路径到上下文中
//    CGContextAddPath(currentContext, path);
//    //填充颜色
//    [[UIColor clearColor] setFill];
//    //设置画笔颜色
//    [[UIColor greenColor] setStroke];
//    //设置边框线条宽度
//    CGContextSetLineWidth(currentContext,3.0f);
//    //画图
//    CGContextDrawPath(currentContext, kCGPathEOFillStroke);
//    /* 释放路径 */
//    CGPathRelease(path);
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //左上
    const CGPoint points1[] = {CGPointMake([UIDevice width]/8, [UIDevice height]/5*2),CGPointMake([UIDevice width]/4, [UIDevice height]/5*2),CGPointMake([UIDevice width]/8, [UIDevice height]/5*2),CGPointMake([UIDevice width]/8, [UIDevice height]/20*9)};
    CGContextStrokeLineSegments(ctx, points1, 4);
    //右上
    const CGPoint points2[] = {CGPointMake([UIDevice width]/8*7, [UIDevice height]/5*2),CGPointMake([UIDevice width]/4*3, [UIDevice height]/5*2),CGPointMake([UIDevice width]/8*7, [UIDevice height]/5*2),CGPointMake([UIDevice width]/8*7, [UIDevice height]/20*9)};
    CGContextStrokeLineSegments(ctx, points2, 4);
    //左下
    const CGPoint points3[] = {CGPointMake([UIDevice width]/8, [UIDevice height]/5*3),CGPointMake([UIDevice width]/4, [UIDevice height]/5*3),CGPointMake([UIDevice width]/8, [UIDevice height]/5*3),CGPointMake([UIDevice width]/8, [UIDevice height]/20*11)};
    CGContextStrokeLineSegments(ctx, points3, 4);
    //右下
    const CGPoint points4[] = {CGPointMake([UIDevice width]/8*7, [UIDevice height]/5*3),CGPointMake([UIDevice width]/4*3, [UIDevice height]/5*3),CGPointMake([UIDevice width]/8*7, [UIDevice height]/5*3),CGPointMake([UIDevice width]/8*7, [UIDevice height]/20*11)};
    CGContextStrokeLineSegments(ctx, points4, 4);

    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
