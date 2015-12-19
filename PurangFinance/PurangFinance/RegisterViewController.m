//
//  RegisterViewController.m
//  普兰金融
//
//  Created by liumingkui on 15/4/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegistModel.h"
#import "NSString+MD5.h"
#import "LoginViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

#define MaxSecond 60

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UITextField *verfiyTextField;
@property (weak, nonatomic) IBOutlet PRButton *getCodeButton;
@property (weak, nonatomic) IBOutlet PRButton *registButton;

@end

@implementation RegisterViewController
{
    NSInteger second;
    RegistModel* registModel;
}

static NSString* userString;
static NSString* passwordString;
static NSString* passwordAgainString;
static NSString* verfiyString;

- (void)viewDidLoad {
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
    
    self.verfiyTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_Verify.png"]];
    self.verfiyTextField.delegate = self;
    self.verfiyTextField.leftView = imageView4;
    
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
    else if (textField == self.verfiyTextField)
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
        userString = textField.text;
    }
    else if (textField == self.passwordTextField)
    {
        passwordString = textField.text;
    }
    else if (textField == self.passwordAgainTextField)
    {
        passwordAgainString = textField.text;
    }
    else if (textField == self.verfiyTextField)
    {
        verfiyString = textField.text;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - action

- (IBAction)verifyCodeButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (userString.length != 11)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else
    {
        self.getCodeButton.enabled = NO;
        if (registModel == nil)
        {
            registModel = [RegistModel new];
        }
        [registModel getVerifyCode:userString success:^{
            
            self.getCodeButton.enabled = NO;
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(registerSecondCheck:) userInfo:nil repeats:YES];
            NSString* string = [NSString stringWithFormat:@"%lds后重新获取",(long)second];
            [self.getCodeButton setTitle:string forState:UIControlStateNormal];
            [timer fire];
//            self.getCodeButton.enabled = YES;
            
        } failure:^(NSInteger responseCode) {
            
            self.getCodeButton.enabled = YES;
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
                case 2:
                    alterView.message = @"用户名已存在";
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
                    alterView.message = @"系统错误";
                    break;
            }
            [alterView show];
            
        }];
    }
}

- (IBAction)registerButtonClick:(id)sender
{
    [self.view endEditing:YES];

    if (userString.length != 11)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (passwordString == nil || [passwordString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (passwordString.length < 6 ||passwordString.length > 16)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"密码长度6-16位字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (passwordAgainString == nil || [passwordAgainString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请再次输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (![passwordString isEqualToString:passwordAgainString])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"两次输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else if (verfiyString.length != 6)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"请输入6位验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
    else
    {
        NSDictionary* userInformation = @{@"userName":userString,@"password":[[passwordString md5] lowercaseString],@"code":verfiyString,@"mobile":userString};
        if (registModel == nil)
        {
            registModel = [RegistModel new];
        }
        
        [[LoginNaviViewController shareLoginNaviViewController] waitingConnect];
        [registModel registWithUserInformation:userInformation success:^{
            
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            [[LoginViewController shareLoginViewController] dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:NO];
            
        } failure:^(NSInteger responseCode) {
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:@"无法连接到服务器" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
                case 2:
                    alterView.message = @"用户名已存在";
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
                    alterView.message = @"系统错误";
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    userString = nil;
    passwordString = nil;
    passwordAgainString = nil;
    verfiyString = nil;
    
    self.userTextField.text = nil;
    self.passwordTextField.text = nil;
    self.passwordAgainTextField.text = nil;
    self.verfiyTextField.text = nil;
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
