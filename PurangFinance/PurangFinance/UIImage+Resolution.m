//
//  UIImage+Resolution.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "UIImage+Resolution.h"

@implementation UIImage (Resolution)

-(UIImage*)imageScaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
