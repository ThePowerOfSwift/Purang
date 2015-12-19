//
//  NoticeDetailViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDetailModel.h"

@interface NoticeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@end

@implementation NoticeDetailViewController
{
    NoticeDetailModel* noticeDetailModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    noticeDetailModel = [NoticeDetailModel new];
    
    _resultTableView.dataSource = self;
//    _resultTableView.delegate = 
    // Do any additional setup after loading the view.
}

- (void)setDetailDictionary:(NSDictionary *)detailDictionary
{
    _detailDictionary = detailDictionary;
    [self.resultTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
    titleLabel.text = [noticeDetailModel.titleArray objectAtIndex:[indexPath row]];
    
    UILabel* detailLabel = (UILabel*)[cell viewWithTag:2];
    detailLabel.text = [noticeDetailModel.detailArray objectAtIndex:[indexPath row]];
    switch ([indexPath row])
    {
        case 0:
            
            detailLabel.text = self.detailDictionary[@"billnum"];
            
            break;
        case 1:
            
            detailLabel.text = self.detailDictionary[@"party"];
            detailLabel.numberOfLines = 0;
            detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            break;
        case 2:
            
            detailLabel.text = self.detailDictionary[@"noticeDate"];
            
            break;
        case 3:
            
            detailLabel.text = self.detailDictionary[@"publicName"];
            
            break;
            
        default:
            break;
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
