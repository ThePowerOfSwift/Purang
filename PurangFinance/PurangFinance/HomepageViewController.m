//
//  HomepageViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "HomepageViewController.h"
#import "HomepageModel.h"
#import "DiscountViewController.h"
#import "LoginNaviViewController.h"
#import "NoticeViewController.h"
#import "CalculatorViewController.h"
#import "PersnoalCenterViewController.h"
#import "CheckViewController.h"
#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "PRFileManager.h"
#import <JXBAdPageView.h>

@interface HomepageViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *naviCollectionView;

typedef NS_ENUM(NSInteger, ScrollViewState)
{
    ScrollViewStateOne ,
    ScrollViewStateTwo ,
    ScrollViewStateThree ,
};

@end

@implementation HomepageViewController

{
    HomepageModel* homepageModel;
//    DiscountViewController* discountViewController;
//    NoticeViewController* noticeViewController;
//    CalculatorViewController* calculatorViewController;
//    LoginNaviViewController* loginNavi;
    PersnoalCenterViewController* personalCenterController;
    CheckViewController* checkViewController;
    
    UIImageView* imageView1;
    UIImageView* imageView2;
    UIImageView* imageView3;
    UIImage* image1;
    UIImage* image2;
    UIImage* image3;
    
    ScrollViewState state;
    CGFloat width;
}

static HomepageViewController* g_HomepageViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    isLogin = NO;
//    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    g_HomepageViewController = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];//隐藏导航栏返回按钮文字

    self.navigationItem.title = @"普兰票据";
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Homepage_Login.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = buttonItem;

    homepageModel = [HomepageModel new];
    
    self.naviCollectionView.dataSource = self;
    self.naviCollectionView.delegate = self;
    
    if ([[PRFileManager sharePRFileManager]checkUserInformationFileExist])
    {
        [[MainNaviViewController shareMainNaviViewController]waitingConnect];
        [LoginModel autoLoginSuccess:^{
            
            [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
            
        } failure:^(NSInteger responseCode) {
            
            [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
            
        }];
    }
    
    // Do any additional setup after loading the view.
}

- (void)rightClick:(id)sender
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.isLogin == NO)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
    else
    {
        if (personalCenterController == nil)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            personalCenterController = [mainSB instantiateViewControllerWithIdentifier:@"personalCenter"];
        }
        [self.navigationController pushViewController:personalCenterController animated:YES];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString* cellId = @"cellId";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    UILabel* label = (UILabel*)[cell viewWithTag:2];
    label.text = [homepageModel.titleArray objectAtIndex:row];
    
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:[homepageModel.imageArray objectAtIndex:row]];
    
    return cell;
}


#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == 0)
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.isLogin == NO)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }
        else
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            DiscountViewController* discountViewController = [mainSB instantiateViewControllerWithIdentifier:@"Discount"];
            [self.navigationController pushViewController:discountViewController animated:YES];
        }
    }
    else if (row == 1)
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.isLogin == NO)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }
        else
        {
            if (checkViewController == nil)
            {
                UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                checkViewController = [mainSB instantiateViewControllerWithIdentifier:@"check"];
            }
            [self.navigationController pushViewController:checkViewController animated:YES];
        }
    }
    else if (row == 2)
    {
//        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//        if (appDelegate.isLogin == NO)
//        {
//            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
//            [self presentViewController:loginNavi animated:YES completion:nil];
//        }
//        else
//        {
//            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            CalculatorViewController* calculatorViewController = [mainSB instantiateViewControllerWithIdentifier:@"calculator"];
//            [self.navigationController pushViewController:calculatorViewController animated:YES];
//        }
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CalculatorViewController* calculatorViewController = [mainSB instantiateViewControllerWithIdentifier:@"calculator"];
        [self.navigationController pushViewController:calculatorViewController animated:YES];
    }
    else if (row == 3)
    {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.isLogin == NO)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }
        else
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            NoticeViewController* noticeViewController = [mainSB instantiateViewControllerWithIdentifier:@"notice"];
            [self.navigationController pushViewController:noticeViewController animated:YES];
        }
    }
    else if (row == 4)
    {
//        if (personalCenterController == nil)
//        {
//            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            personalCenterController = [mainSB instantiateViewControllerWithIdentifier:@"personalCenter"];
//        }
//        [self.navigationController pushViewController:personalCenterController animated:YES];
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        if (appDelegate.isLogin == NO)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }
        else
        {
            if (personalCenterController == nil)
            {
                UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                personalCenterController = [mainSB instantiateViewControllerWithIdentifier:@"personalCenter"];
            }
            [self.navigationController pushViewController:personalCenterController animated:YES];
        }
    }
    else if (row == 5)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        AboutUsViewController* aboutUsViewController = [mainSB instantiateViewControllerWithIdentifier:@"aboutUs"];
        [self.navigationController pushViewController:aboutUsViewController animated:YES];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIDevice width]/3.0-1, 110);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.1, 0.1, 1, 0.1);
}


#pragma mark - scrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat x = scrollView.contentOffset.x;
//    if (x == 0)
//    {
//        switch (state)
//        {
//            case ScrollViewStateOne:
//                
//                imageView2.image = image3;
//                imageView1.image = image2;
//                imageView3.image = image1;
//                state = ScrollViewStateThree;
//                
//                break;
//            case ScrollViewStateTwo:
//                
//                imageView2.image = image1;
//                imageView1.image = image3;
//                imageView3.image = image2;
//                state = ScrollViewStateOne;
//                
//                break;
//            case ScrollViewStateThree:
//                
//                imageView2.image = image2;
//                imageView1.image = image1;
//                imageView3.image = image3;
//                state = ScrollViewStateTwo;
//                
//                break;
//                
//            default:
//                break;
//        }
//        scrollView.contentOffset = CGPointMake(width, 0);
//    }
//    else if (x == width*2.0)
//    {
//        switch (state)
//        {
//            case ScrollViewStateOne:
//                
//                imageView2.image = image2;
//                imageView1.image = image1;
//                imageView3.image = image3;
//                state = ScrollViewStateTwo;
//                
//                break;
//                
//            case ScrollViewStateTwo:
//                
//                imageView2.image = image3;
//                imageView1.image = image2;
//                imageView3.image = image1;
//                state = ScrollViewStateThree;
//                
//                break;
//                
//            case ScrollViewStateThree:
//                
//                imageView2.image = image1;
//                imageView1.image = image3;
//                imageView3.image = image2;
//                state = ScrollViewStateOne;
//                
//                break;
//                
//            default:
//                break;
//        }
//        scrollView.contentOffset = CGPointMake(width, 0);
//    }
////    [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
//////        [scrollView setContentOffset:CGPointMake(width, 0)];
////    [scrollView scrollRectToVisible:CGRectMake(width, 0, 0, 0) animated:NO];
//}

#pragma mark - self method

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.isLogin == NO)
    {
        personalCenterController = nil;
    }
}

+ (HomepageViewController *)shareHomepageViewController
{
    return g_HomepageViewController;
}

- (void)showLogin
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.isLogin == NO)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        LoginNaviViewController* loginNavi = [mainSB instantiateViewControllerWithIdentifier:@"LoginNavi"];
        [self presentViewController:loginNavi animated:YES completion:nil];
    }
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
