//
//  LoginNaviViewController.h
//  PurangFinance
//
//  Created by liumingkui on 15/4/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginNaviViewController : UINavigationController

+ (LoginNaviViewController*)shareLoginNaviViewController;
- (void)waitingConnect;
- (void)removeWaitingView;

@end
