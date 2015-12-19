//
//  DiscountPhotoViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscountPhotoViewControllerDelegate;

@interface DiscountPhotoViewController : UIViewController

@property(assign,nonatomic) id<DiscountPhotoViewControllerDelegate> delegate;

+ (DiscountPhotoViewController*)shareDiscountPhotoViewController;

@end

@protocol DiscountPhotoViewControllerDelegate <NSObject>

- (void)discountPhotoViewController:(DiscountPhotoViewController*)discountPhotoViewController getPhotoImage:(NSArray*)imageArray;

@end