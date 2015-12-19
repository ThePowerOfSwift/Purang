//
//  CalulatorResultViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/22.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CalulatorResultViewController.h"

@interface CalulatorResultViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end

@implementation CalulatorResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultTableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)setResultDicitonary:(NSDictionary *)resultDicitonary
{
    _resultDicitonary = resultDicitonary;
    [self.resultTableView reloadData];
}


#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId1";
    NSInteger row = [indexPath row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
//    NSDictionary* dictionary = @{@"interestAccrualDays":interestAccrualDays,@"interest":interest,@"paidInAmount":paidInAmount};
    if (row == 0)
    {
        UILabel* label1 = (UILabel*)[cell viewWithTag:1];
        label1.text = @"计息天数";
        UILabel* label2 = (UILabel*)[cell viewWithTag:2];
        label2.text = [[self.resultDicitonary valueForKey:@"interestAccrualDays"] stringValue];
        UILabel* label3 = (UILabel*)[cell viewWithTag:3];
        label3.text = @"天";
    }
    else if (row == 1)
    {
        UILabel* label1 = (UILabel*)[cell viewWithTag:1];
        label1.text = @"应付利息";
        UILabel* label2 = (UILabel*)[cell viewWithTag:2];
        label2.text = [[self.resultDicitonary valueForKey:@"interest"]stringValue];
        UILabel* label3 = (UILabel*)[cell viewWithTag:3];
        label3.text = @"元";
    }
    else if (row == 2)
    {
        UILabel* label1 = (UILabel*)[cell viewWithTag:1];
        label1.text = @"实收金额";
        UILabel* label2 = (UILabel*)[cell viewWithTag:2];
        label2.text = [[self.resultDicitonary valueForKey:@"paidInAmount"]stringValue];
        UILabel* label3 = (UILabel*)[cell viewWithTag:3];
        label3.text = @"元";
    }
    return cell;

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
