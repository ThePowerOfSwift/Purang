//
//  MainNaviViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNaviViewController : UINavigationController

+ (MainNaviViewController*)shareMainNaviViewController;
- (void)waitingConnect;
- (void)removeWaitingView;

@end
