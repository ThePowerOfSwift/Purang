//
//  CameraViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewControllerDelegate <NSObject>

- (void)getPhoto:(NSDictionary*)imageDictionary;

@end

@interface CameraViewController : UIViewController

@property(assign,nonatomic) id<CameraViewControllerDelegate> delegate;

@end
