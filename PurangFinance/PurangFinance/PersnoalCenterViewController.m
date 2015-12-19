//
//  PersnoalCenterViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PersnoalCenterViewController.h"
#import "PersonalCenterModel.h"
//#import "CityTableViewController.h"
#import "LogoutModel.h"
#import "ComfirmViewController.h"
#import "ResetViewController.h"
#import "ChangePersonalViewController.h"
#import "PRFileManager.h"

@interface PersnoalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *personalTableView;

@end

@implementation PersnoalCenterViewController
{
    PersonalCenterModel* personalCenterMdoel;
    NSInteger status;
//    CityTableViewController* cityTableViewController;
}

static PersnoalCenterViewController* g_persnoalCenterViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    personalCenterMdoel = [PersonalCenterModel new];
    _personalTableView.dataSource = self;
    _personalTableView.delegate = self;
    status = -1;
    
    NSDictionary* dictionary = [[PRFileManager sharePRFileManager] readUserInformationFile];
    NSLog(@"dictionary:%@",dictionary);
    if ([dictionary[@"accountStatus"] integerValue] == 1 || [dictionary[@"accountStatus"] integerValue] == 0)
    {
        if (dictionary[@"userRealName"])
        {
            if (dictionary[@"userRealName"])
            {
                if (dictionary[@"companyName"])
                {
                    personalCenterMdoel.information = @{@"companyName":dictionary[@"companyName"],@"userRealName":dictionary[@"userRealName"],@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"]};
                }
                else
                {
                    personalCenterMdoel.information = @{@"userRealName":dictionary[@"userRealName"],@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"]};
                }
                
            }
            else
            {
                personalCenterMdoel.information = @{@"companyName":dictionary[@"companyName"],@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"]};
            }
        }
        else
        {
            personalCenterMdoel.information = @{@"companyName":dictionary[@"companyName"],@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"]};
        }
        
    }
    else if ([dictionary[@"accountStatus"] integerValue] == -1 || [dictionary[@"accountStatus"] integerValue] == -2)
    {
        if (dictionary[@"userRealName"])
        {
            personalCenterMdoel.information = @{@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"],@"userRealName":dictionary[@"userRealName"],};
        }
        else
        {
            personalCenterMdoel.information = @{@"accountStatus":dictionary[@"accountStatus"],@"phoneNumber":dictionary[@"userName"]};
        }
        [self.personalTableView reloadData];
    }
    else
    {
        [personalCenterMdoel getPersonalInformationSuccess:^{
            
            [self.personalTableView reloadData];
            NSLog(@"getPersonalInformationSuccess");
            
        } failure:^(NSInteger responseCode) {
            
            NSLog(@"getPersonalInformationFailure:%ld",(long)responseCode);
            
        }];
    }
    
    
    g_persnoalCenterViewController = self;
    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return personalCenterMdoel.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId;
    if ([indexPath row] == 2)
    {
        cellId = @"cellId2";
    }
    else
    {
        cellId = @"cellId";
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UILabel* label = (UILabel*)[cell viewWithTag:1];
    label.text = [personalCenterMdoel.titleArray objectAtIndex:[indexPath row]];
    NSInteger row = [indexPath row];
    if (row == 0)
    {
        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
        detailLabel.text = personalCenterMdoel.information[@"phoneNumber"];
    }
    else if (row == 1)
    {
        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
        detailLabel.text = personalCenterMdoel.information[@"companyName"];
    }
//    else if (row == 2)
//    {
//        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
//        detailLabel.text = @"上海";
//    }
    
    else if (row == 2)
    {
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:2];
        status = [personalCenterMdoel.information[@"accountStatus"] integerValue];
        if ([personalCenterMdoel.information[@"accountStatus"] integerValue] == 0)
        {
            imageView.image = [UIImage imageNamed:@"personal_inComform.png"];
        }
        else if ([personalCenterMdoel.information[@"accountStatus"] integerValue] == -1)
        {
            imageView.image = [UIImage imageNamed:@"personal_waitingComform.png"];
        }
        else if ([personalCenterMdoel.information[@"accountStatus"] integerValue] == 1)
        {
            imageView.image = [UIImage imageNamed:@"personal_comformSuccess.png"];
        }
        else if ([personalCenterMdoel.information[@"accountStatus"] integerValue] == -2)
        {
            imageView.image = [UIImage imageNamed:@"personal_comformFailure.png"];
        }
    }
    else if (row == 3)
    {
        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
        detailLabel.text = personalCenterMdoel.information[@"userRealName"];
    }
    else if (row == 4)
    {
        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
        detailLabel.hidden = YES;
    }
    else if (row == 5)
    {
        UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
        detailLabel.hidden = YES;
    }
    return cell;
}


#pragma mark - tabkeViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 2)
    {
        if (status == -1 || status == -2)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ComfirmViewController* comfirmViewController = [mainSB instantiateViewControllerWithIdentifier:@"comfirm"];
            [self.navigationController pushViewController:comfirmViewController animated:YES];
        }
    }
    else if ([indexPath row] == 4)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ResetViewController* resetViewController = [mainSB instantiateViewControllerWithIdentifier:@"reset"];
        [self.navigationController pushViewController:resetViewController animated:YES];
    }
    else if ([indexPath row] == 5)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ChangePersonalViewController* changeViewController = [mainSB instantiateViewControllerWithIdentifier:@"changePersonal"];
        [self.navigationController pushViewController:changeViewController animated:YES];
    }
}


#pragma mark - IBAction

- (IBAction)logoutButtonClick:(id)sender
{
    [[MainNaviViewController shareMainNaviViewController]waitingConnect];

    [LogoutModel logoutSuccess:^{
        
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];

        [self.navigationController popViewControllerAnimated:YES];
//        self = nil;
        
    }];
}


#pragma mark - self method

+ (PersnoalCenterViewController *)sharePersnoalCenterViewController
{
    return g_persnoalCenterViewController;
}

- (void)getPersonalInformation
{
    [personalCenterMdoel getPersonalInformationSuccess:^{
        
        [self.personalTableView reloadData];
        NSLog(@"getPersonalInformationSuccess");
        
    } failure:^(NSInteger responseCode) {
        
        NSLog(@"getPersonalInformationFailure:%ld",(long)responseCode);
        
    }];

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
