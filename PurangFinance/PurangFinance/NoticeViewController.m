//
//  NoticeViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "NoticeViewController.h"
#import "HomeViewController.h"
#import "NoticeModel.h"
#import "NoticeDetailViewController.h"

static NoticeViewController* g_NoticeViewController;

@interface NoticeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bankDraftTextField;

@end

@implementation NoticeViewController
{
    NoticeModel* noticeModel;
    NSString* billNo;
}

+(NoticeViewController*)shareNoticeViewController
{
    return g_NoticeViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    g_NoticeViewController = self;
    _bankDraftTextField.leftViewMode = UITextFieldViewModeAlways;
//    UIImageView* leftImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notice_search.png"]];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.text = @"票号";
    label.font = [UIFont systemFontOfSize:17];
    _bankDraftTextField.leftView = label;
    _bankDraftTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bankDraftTextField.delegate = self;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    // Do any additional setup after loading the view.
}

- (IBAction)cameraButtonClick:(id)sender
{
    HomeViewController* homeView = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:homeView animated:YES];
}

- (IBAction)searchButtonClick:(id)sender
{
    [self.view endEditing:YES];
//    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    NoticeDetailViewController* noticeDetailViewController = [mainSB instantiateViewControllerWithIdentifier:@"noticeDetail"];
//    [self.navigationController pushViewController:noticeDetailViewController animated:YES];
    
    if (billNo != nil && ![billNo isEqualToString:@""])
    {
        if (noticeModel == nil)
        {
            noticeModel = [NoticeModel new];
        }
        
        [[MainNaviViewController shareMainNaviViewController] waitingConnect];

        [noticeModel query:@{@"billNo":billNo} success:^(id responseObject) {
            
            [[MainNaviViewController shareMainNaviViewController]removeWaitingView];

//            NSLog(@"searchButtonClick%@",responseObject);
            if ([responseObject[@"success"] isEqualToString:@"true"])
            {
                UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                NoticeDetailViewController* noticeDetailViewController = [mainSB instantiateViewControllerWithIdentifier:@"noticeDetail"];
                noticeDetailViewController.detailDictionary = responseObject;
                [self.navigationController pushViewController:noticeDetailViewController animated:YES];
            }
            else
            {
                UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"该票号无公示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alterView show];
            }
            
            
        } failure:^(NSInteger responseCode) {
            
            

        }];
    }
    else
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"查询失败" message:@"请输入票号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    if (textField.text.length >= 16)
    {
        return NO;
    }
    
    return YES;
}

- (void)BankDraftTextField:(NSString *)str
{
    _bankDraftTextField.text = str;
    billNo = str;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    billNo = textField.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)tap:(id)sender
{
    [self.view endEditing:YES];
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
