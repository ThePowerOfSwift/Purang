//
//  MainNaviViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "MainNaviViewController.h"
#import "PRWaitingView.h"

@interface MainNaviViewController ()

@end

@implementation MainNaviViewController
{
    PRWaitingView* waitingView;
}
static MainNaviViewController* g_MainNaviViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_MainNaviViewController = self;
    // Do any additional setup after loading the view.
}

+ (MainNaviViewController *)shareMainNaviViewController
{
    return g_MainNaviViewController;
}

- (void)waitingConnect
{
    if (waitingView == nil)
    {
        waitingView = [[PRWaitingView alloc]initWithFrame:self.view.bounds];
    }
    [self.view addSubview:waitingView];
}

- (void)removeWaitingView
{
    [waitingView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
