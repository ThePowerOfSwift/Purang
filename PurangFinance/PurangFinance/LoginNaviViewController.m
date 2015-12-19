//
//  LoginNaviViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "LoginNaviViewController.h"
#import "PRWaitingView.h"

@interface LoginNaviViewController ()

@end

@implementation LoginNaviViewController
{
    PRWaitingView* waitingView;
}
static LoginNaviViewController* g_LoginNaviViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    g_LoginNaviViewController = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Do any additional setup after loading the view.
}

+ (LoginNaviViewController *)shareLoginNaviViewController
{
    return g_LoginNaviViewController;
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


#pragma mark - 状态栏白色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
