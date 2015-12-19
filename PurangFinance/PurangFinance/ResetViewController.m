//
//  ResetViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/15.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ResetViewController.h"
#import "ResetModel.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PRFileManager.h"
#import "LogoutModel.h"
#import "HomepageViewController.h"

@interface ResetViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

#define MaxSecond 60

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet PRButton *getCodeButton;
@property (weak, nonatomic) IBOutlet PRButton *resetButton;

@end

@implementation ResetViewController
{
    NSInteger second;
    ResetModel* resetModel;
}

static NSString* resetUserString;
static NSString* resetPasswordString;
static NSString* resetPasswordAgainString;
static NSString* resetVerfiyString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    second = MaxSecond;
    
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_User.png"]];
    self.userTextField.leftView = imageView;
    self.userTextField.delegate = self;
    
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_Password.png"]];
    self.passwordTextField.leftView = imageView2;
    self.passwordTextField.delegate = self;
    
    self.passwordAgainTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_Password.png"]];
    self.passwordAgainTextField.leftView = imageView3;
    self.passwordAgainTextField.delegate = self;
    
    self.verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_Verify.png"]];
    self.verifyCodeTextField.delegate = self;
    self.verifyCodeTextField.leftView = imageView4;
    
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    
    if (app.isLogin == YES)
    {
        NSDictionary* dictionary = [[PRFileManager sharePRFileManager] readUserInformationFile];
        self.userTextField.text = dictionary[@"userName"];
        self.userTextField.enabled = NO;
        resetUserString = dictionary[@"userName"];
    }
    // Do any additional setup after loading the view.
}


#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    if (textField == self.userTextField)
    {
        NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        
        if (textField.text.length >= 11)
        {
            return NO;
        }
    }
    else if (textField == self.verifyCodeTextField)
    {
        NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        
        if (textField.text.length >= 6)
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userTextField)
    {
        resetUserString = textField.text;
    }
    else if (textField == self.passwordTextField)
    {
        resetPasswordString = textField.text;
    }
    else if (textField == self.passwordAgainTextField)
    {
        resetPasswordAgainString = textField.text;
    }
    else if (textField == self.verifyCodeTextField)
    {
        resetVerfiyString = textField.text;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - IBAction

- (IBAction)verifyButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (resetUserString.length != 11)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else
    {
        self.getCodeButton.enabled = NO;
        if (resetModel == nil)
        {
            resetModel = [ResetModel new];
        }
        [resetModel getVerifyCode:resetUserString success:^{
            
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerSecondCheck:) userInfo:nil repeats:YES];
            NSString* string = [NSString stringWithFormat:@"%lds后重新获取",(long)second];
            [self.getCodeButton setTitle:string forState:UIControlStateNormal];
            [timer fire];
            
            
        } failure:^(NSInteger responseCode) {
            self.getCodeButton.enabled = YES;
//            NSLog(@"responseCode:%ld",(long)responseCode);
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
                case 1:
                    alterView.message = @"用户名不存在";
                    break;
                    
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
                    
                default:
                    break;
            }

            [alterView show];
            
        }];
        
        
    }
}

- (IBAction)resetButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (resetUserString.length != 11)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (resetPasswordString == nil || [resetPasswordString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (resetPasswordString.length < 6 || resetPasswordString.length > 16)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"密码长度6-16位字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (resetPasswordAgainString == nil || [resetPasswordAgainString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"请再次输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (![resetPasswordString isEqualToString:resetPasswordAgainString])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (resetVerfiyString.length != 6)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"请输入6位验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else
    {
        NSDictionary* userInformation = @{@"userName":resetUserString,@"password":[[resetPasswordString md5] lowercaseString],@"code":resetVerfiyString,@"mobile":resetUserString};
        if (resetModel == nil)
        {
            resetModel = [ResetModel new];
        }
        [[LoginNaviViewController shareLoginNaviViewController] waitingConnect];
        
        [resetModel resetWithUserInformation:userInformation success:^{
            
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
            
            
        } failure:^(NSInteger responseCode) {
            
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            NSLog(@"responseCode:%ld",(long)responseCode);
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"重设密码失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
                case 1:
                    alterView.message = @"用户名不存在";
                    break;
                    
                case 4:
                    alterView.message = @"验证码已过期";
                    break;
                    
                case 3:
                    alterView.message = @"系统错误";
                    break;
                    
                case 9:
                    alterView.message = @"密码不正确";
                    break;
                    
                case 11:
                    alterView.message = @"验证码不存在";
                    break;
                    
                default:
                    break;
            }
            [alterView show];
            
        }];
    }

}

- (void)registerSecondCheck:(id)sender
{
    second --;
    NSString* string = [NSString stringWithFormat:@"%lds后重新获取",(long)second];
    [self.getCodeButton setTitle:string forState:UIControlStateNormal];
    if (second == 0)
    {
        NSTimer* timer = (NSTimer*)sender;
        [timer invalidate];
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        second = MaxSecond;
        self.getCodeButton.enabled = YES;
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    AppDelegate* appDelegate = [[UIApplication sharedApplication]]
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.isLogin == YES)
    {
        [LogoutModel logoutSuccess:^{
            
            [[HomepageViewController shareHomepageViewController]showLogin];
            
        }];
    }
}


#pragma mark - super method

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    resetPasswordAgainString = nil;
    resetPasswordString = nil;
    resetUserString = nil;
    resetVerfiyString = nil;
    
    self.userTextField.text = nil;
    self.passwordAgainTextField.text = nil;
    self.passwordTextField.text = nil;
    self.verifyCodeTextField.text = nil;
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
