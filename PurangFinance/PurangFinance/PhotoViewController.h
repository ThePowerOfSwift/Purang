//
//  PhotoViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewControllerDelegate <NSObject>

- (void)usePhoto:(NSDictionary*)imageDictionary;

@end

@interface PhotoViewController : UIViewController

@property(retain,nonatomic)UIImage* photo;
@property(retain,nonatomic)id<PhotoViewControllerDelegate> delegate;

@end
