//
//  PhotoBrowseViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/17.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowseViewControllerDelegate <NSObject>

- (void)deleteImageWithIndex:(NSInteger)index;

@end

@interface PhotoBrowseViewController : UIViewController

- (void)setimageArray:(NSMutableArray*)imageArray andCurrentIndex:(NSUInteger)currentIndex;
@property(assign,nonatomic) id<PhotoBrowseViewControllerDelegate> delegate;

@end
