//
//  ChangePersonalViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/25.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ChangePersonalViewController.h"
#import "ChangPersonalModel.h"
#import "PRFileManager.h"
#import "NSString+MD5.h"
#import "PersnoalCenterViewController.h"
#import "LogoutModel.h"
//#import "LoginNaviViewController.h"
#import "HomepageViewController.h"

#define MaxSecond 60

@interface ChangePersonalViewController ()<UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChangePersonalViewController
{
    ChangPersonalModel* changeModel;
    UITextField* nameTextField;
    UITextField* telNumTextField;
    UIButton* verifyButton;
    UITextField* verifyTextField;
    NSInteger second;
}

static NSString* nameString;
static NSString* telNumString;
static NSString* verifyCodeString;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    second = MaxSecond;
    // Do any additional setup after loading the view.
}


#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    if ([indexPath row] == 0)
    {
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        label.text = @"姓   名";
        nameTextField = (UITextField*)[cell viewWithTag:2];
        nameTextField.placeholder = @"请输入姓名";
        nameTextField.delegate = self;
    }
    else if ([indexPath row] == 1)
    {
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        label.text = @"手机号";
        telNumTextField = (UITextField*)[cell viewWithTag:2];
        telNumTextField.placeholder = @"请输入手机号码";
        telNumTextField.delegate = self;
        telNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([indexPath row] == 2)
    {
        UILabel* label = (UILabel*)[cell viewWithTag:1];
        label.text = @"验证码";
        verifyTextField = (UITextField*)[cell viewWithTag:2];
        verifyTextField.placeholder = @"请输入验证码";
        verifyTextField.delegate = self;
        verifyTextField.keyboardType =  UIKeyboardTypeNumberPad;
        
        verifyButton = (UIButton*)[cell viewWithTag:3];
        [verifyButton addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        [nameTextField becomeFirstResponder];
    }
    else if ([indexPath row] == 1)
    {
        [telNumTextField becomeFirstResponder];
    }
}


#pragma mark - textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == telNumTextField)
    {
        telNumString = textField.text;
    }
    else if (textField == nameTextField)
    {
        nameString = textField.text;
    }
    else if (textField == verifyTextField)
    {
        verifyCodeString = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    
    if (textField == nameTextField)
    {
        if (textField.text.length > 29)
        {
            return NO;
        }
    }
    
    if (textField == telNumTextField)
    {
        NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        if (textField.text.length > 10)
        {
            return NO;
        }
    }
    
    if (textField == verifyTextField)
    {
        NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        if (textField.text.length > 6)
        {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - IBAction

- (void)verifyButtonClick:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (telNumString == nil || [telNumString isEqualToString:@""])
    {
        alterView.message = @"请输入手机号";
        [alterView show];
    }
    else
    {
        verifyButton.enabled = NO;
        if (changeModel == nil)
        {
            changeModel = [ChangPersonalModel new];
        }
        [changeModel getVerifyCode:@{@"userName":telNumString} success:^{
            
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSecondCheck:) userInfo:nil repeats:YES];
            NSString* string = [NSString stringWithFormat:@"%lds后重新获取",(long)second];
            [verifyButton setTitle:string forState:UIControlStateNormal];
            [timer fire];

            
        } failure:^(NSInteger responseCode) {
            
            verifyButton.enabled = YES;
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
//                case 2:
//                    alterView.message = @"用户名已存在";
//                    break;
                    
                case 4:
                    alterView.message = @"验证码已过期";
                    break;
                    
                case 3:
                    alterView.message = @"系统错误";
                    break;
                    
                case 5:
                    alterView.message = @"验证码发送次数超过限制";
                    break;
                    
                case 11:
                    alterView.message = @"验证码不存在";
                    break;
                    
                case 19:
                    alterView.message = @"用户已存在";
                    break;
                    
                default:
                    alterView.message = @"系统错误";
                    break;
            }
            [alterView show];
            
        }];
    }
}

- (IBAction)submitButtonClick:(id)sender
{
    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"认证失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (telNumString == nil || [telNumString isEqualToString:@""])
    {
        alterView.message = @"请输入手机号";
        [alterView show];
    }
    else if (nameString == nil || [nameString isEqualToString:@""])
    {
        alterView.message = @"请输入联系人";
        [alterView show];
    }
    else if (telNumString.length > 11)
    {
        alterView.message = @"请输入正确的手机号码";
        [alterView show];
    }
    else if (nameString.length > 30)
    {
        alterView.message = @"联系人姓名过长(不超过30个汉字)";
        [alterView show];
    }
    else
    {
        if (changeModel == nil)
        {
            changeModel = [ChangPersonalModel new];
        }
        PRFileManager* fileManager = [PRFileManager sharePRFileManager];
        NSDictionary* dictionary = [fileManager readUserInformationFile];
        NSString* mac = [[[NSString stringWithFormat:@"%@%@%@%@",dictionary[@"userId"],nameString,telNumString,dictionary[@"encryptRandom"]] md5] lowercaseString];
        
        [[MainNaviViewController shareMainNaviViewController]waitingConnect];
        [changeModel changePersonal:@{@"userId":dictionary[@"userId"],@"mobile":telNumString,@"userRealName":nameString,@"mac":mac,@"code":verifyCodeString} success:^{
            
            [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"修改个人信息成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
            
        } failure:^(NSInteger responseCode) {
            
            [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
            switch (responseCode)
            {
                case 13:
                    alterView.message = @"数据不完整";
                    [alterView show];
                    break;
                    
                case 14:
                    alterView.message = @"更新用户失败";
                    [alterView show];
                    break;
                
                case 19:
                    alterView.message = @"用户已存在";
                    [alterView show];
                    break;
                    
                default:
                    alterView.message = @"服务器错误";
                    [alterView show];
                    break;
            }
            
        }];
    }
}

- (void)changeSecondCheck:(id)sender
{
    second --;
    NSString* string = [NSString stringWithFormat:@"%lds后重新获取",(long)second];
    [verifyButton setTitle:string forState:UIControlStateNormal];
    if (second == 0)
    {
        NSTimer* timer = (NSTimer*)sender;
        [timer invalidate];
        [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        second = MaxSecond;
        verifyButton.enabled = YES;
    }
}


#pragma mark - alterViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[PersnoalCenterViewController sharePersnoalCenterViewController] getPersonalInformation];
    NSDictionary* dictionary = [[PRFileManager sharePRFileManager]readUserInformationFile];
    if ([dictionary[@"userName"] isEqualToString:telNumString])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[PersnoalCenterViewController sharePersnoalCenterViewController] getPersonalInformation];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [LogoutModel logoutSuccess:^{
        
            [[HomepageViewController shareHomepageViewController] showLogin];
            
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
