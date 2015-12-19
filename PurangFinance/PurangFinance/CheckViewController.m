//
//  CheckViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CheckViewController.h"
#import "CheckModel.h"
#import <MJRefresh.h>

@interface CheckViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *checkTableView;
@property (weak, nonatomic) IBOutlet PRView *topBackView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *inButton;
@property (weak, nonatomic) IBOutlet UIButton *classButton;

@end

@implementation CheckViewController
{
    CheckModel* checkModel;
    UIView* buttomLine;
    NSArray* buttonArray;
    __weak UIButton* oldButton;
}

static NSString* status;
static NSString* refresh;
static NSString* discountType;

#define PAGESIZE @"10"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkModel = [CheckModel new];
    _checkTableView.dataSource = self;
    _checkTableView.delegate = self;
    CGRect rect = self.topBackView.frame;
    CGFloat width = [UIDevice width]/4.0;
    buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-3, width, 3)];
    buttomLine.backgroundColor = [UIColor colorFromHexCode:@"4e98d5"];
    [self.topBackView addSubview:buttomLine];
    
    self.checkTableView.tableFooterView = [[UIView alloc]init];
    oldButton = _allButton;
    
    buttonArray = @[self.allButton,self.doneButton,self.inButton,self.classButton];

    status = @"0";
    
    refresh = @"new";
    NSDictionary* dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE};
    [self getCheckListWithDictionary:dict];
    
    [self.checkTableView addLegendHeaderWithRefreshingBlock:^{
        
        refresh = @"new";
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }
        [checkModel getCheck:dict success:^{
            
            [_checkTableView reloadData];
            
        } failure:^(NSInteger responseCode) {
            
            
        }];
        
        [self.checkTableView.header endRefreshing];

        
    }];
    
        [self.checkTableView addLegendFooterWithRefreshingBlock:^{
       
        refresh = @"more";
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }

        [checkModel getCheck:dict success:^{
            
            [_checkTableView reloadData];

        } failure:^(NSInteger responseCode) {
            
//            [self.checkTableView.footer endRefreshing];
            
        }];
        
        CGPoint point = self.checkTableView.contentOffset;
        CGPoint point2 = CGPointMake(point.x, point.y-44);
        if (point.y + self.checkTableView.bounds.size.height >= [UIDevice height]-64-44)//解决上拉不回滚问题(storyboard会产生这个问题)
        {
            [self.checkTableView setContentOffset:point2 animated:YES];
        }
        
        [self.checkTableView.footer endRefreshing];
        
    }];
    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return checkModel.checkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    NSInteger row = [indexPath row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    NSDictionary* dictionary = [checkModel.checkList objectAtIndex:row];
    
    UILabel* bankLabel = (UILabel*)[cell viewWithTag:1];
    bankLabel.text = dictionary[@"acceptingBank"];
    
    UILabel* statusLabel = (UILabel*)[cell viewWithTag:2];
    
    statusLabel.text = dictionary[@"status"];
    if ([dictionary[@"status"] isEqualToString:@"待撮合"] || [dictionary[@"status"] isEqualToString:@"待调度"] || [dictionary[@"status"] isEqualToString:@"已调度"] || [dictionary[@"status"] isEqualToString:@"手续办理中"] || [dictionary[@"status"] isEqualToString:@"正在等款"] || [dictionary[@"status"] isEqualToString:@"明日做"])
    {
        statusLabel.textColor = [UIColor colorFromHexCode:@"ff8921"];//橘红  进行中状态
    }
    else if([dictionary[@"status"] isEqualToString:@"已完成"] || [dictionary[@"status"] isEqualToString:@"已入库"] )
    {
        statusLabel.textColor = [UIColor colorFromHexCode:@"4e98d5"];//蓝色  已完成状态
    }
    else if ([dictionary[@"status"] isEqualToString:@"已放弃"])
    {
        statusLabel.textColor = [UIColor colorFromHexCode:@"838383"];//灰色  其他状态
    }
    UILabel* percentLabel = (UILabel*)[cell viewWithTag:3];
    percentLabel.text = [NSString stringWithFormat:@"%@%@",dictionary[@"price"],dictionary[@"priceUnit"]];
    
    UILabel* dateLabel = (UILabel*)[cell viewWithTag:4];
    dateLabel.text = [NSString stringWithFormat:@"%@天",dictionary[@"days"]];
    
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:5];
    amountLabel.text = [NSString stringWithFormat:@"%@万",dictionary[@"sum"]];
    
    UILabel* discountDateLabel = (UILabel*)[cell viewWithTag:6];
    discountDateLabel.text = [NSString stringWithFormat:@"贴现日:%@",dictionary[@"discountDate"]];
    
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:7];
    if ([dictionary[@"billType"] isEqualToString:@"商票"])
    {
        imageView.image = [UIImage imageNamed:@"bill_shang.png"];
    }
    else if ([dictionary[@"billType"] isEqualToString:@"银票"])
    {
        imageView.image = [UIImage imageNamed:@"bill_yin.png"];
    }
    
    UIImageView* imageView2 = (UIImageView*)[cell viewWithTag:8];
    if ([dictionary[@"billMedia"] isEqualToString:@"纸票"])
    {
        imageView2.image = [UIImage imageNamed:@"bill_zhi.png"];
    }
    else if ([dictionary[@"billMedia"] isEqualToString:@"电票"])
    {
        imageView2.image = [UIImage imageNamed:@"bill_dian.png"];
    }
    
    return cell;
}


#pragma mark - button click

- (IBAction)allButtonClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (oldButton != _allButton)
    {
        [self setButtomLineWithTag:button.tag];
        [self setButtonColorWithTag:button.tag];
        
        status = @"0";//全部
        refresh = @"new";
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }
        [self getCheckListWithDictionary:dict];
        oldButton = _allButton;
    }
}

- (IBAction)doneButtonClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (oldButton != _doneButton)
    {
        [self setButtomLineWithTag:button.tag];
        [self setButtonColorWithTag:button.tag];
        
        status = @"2";//已完成
        refresh = @"new";
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }
        [self getCheckListWithDictionary:dict];
        oldButton = _doneButton;
    }
    
//    [self.checkTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)inButtonClick:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (oldButton != _inButton)
    {
        [self setButtomLineWithTag:button.tag];
        [self setButtonColorWithTag:button.tag];
        
        status = @"1";//进行中
        refresh = @"new";
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }
        [self getCheckListWithDictionary:dict];
        oldButton = _inButton;
    }
    
//    [self.checkTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)classButtonClick:(id)sender
{
//    UIButton* button = (UIButton*)sender;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择类别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"银票-纸票",@"银票-电票",@"商票-纸票",@"商票-电票", @"全部",nil];
    [actionSheet showInView:self.view];
//    [self setButtomLineWithTag:button.tag];
//    [self setButtonColorWithTag:button.tag];
}

- (void)setButtonColorWithTag:(NSInteger)tag
{
    for (UIButton* button in buttonArray)
    {
        if (button.tag == tag)
        {
            [button setTitleColor:[UIColor colorFromHexCode:@"101010"] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor colorFromHexCode:@"929292"] forState:UIControlStateNormal];
        }
    }
}

- (void)setButtomLineWithTag:(NSInteger)tag
{
    [UIView animateWithDuration:0.2 animations:^{
       
        CGRect rect = buttomLine.frame;
        buttomLine.frame = CGRectMake(rect.size.width * tag, rect.origin.y, rect.size.width, rect.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)getCheckListWithDictionary:(NSDictionary*)dictionary
{
    
    [checkModel getCheck:dictionary success:^{
        
        [_checkTableView reloadData];
        
    } failure:^(NSInteger responseCode) {
        
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        discountType = @"银票-纸票";
        refresh = @"new";
        NSDictionary* dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        [self getCheckListWithDictionary:dict];
    }
    else if (buttonIndex == 1)
    {
        discountType = @"银票-电票";
        refresh = @"new";
        NSDictionary* dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        [self getCheckListWithDictionary:dict];
    }
    else if (buttonIndex == 2)
    {
        discountType = @"商票-纸票";
        refresh = @"new";
        NSDictionary* dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        [self getCheckListWithDictionary:dict];
    }
    else if (buttonIndex == 3)
    {
        discountType = @"商票-电票";
        refresh = @"new";
        NSDictionary* dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        [self getCheckListWithDictionary:dict];
    }
    else if (buttonIndex == 4)
    {
        refresh = @"new";
        discountType = nil;
        NSDictionary* dict;
        if ([discountType isEqualToString:@""] || discountType == nil)
        {
            dict = @{@"status":status,@"pageSize":PAGESIZE,@"refresh":refresh};
        }
        else
        {
            dict = @{@"status":status,@"refresh":refresh,@"pageSize":PAGESIZE,@"discountType":discountType};
        }
        [self getCheckListWithDictionary:dict];
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
