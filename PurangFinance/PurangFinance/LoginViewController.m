//
//  LoginViewController.m
//  普兰金融
//
//  Created by liumingkui on 15/4/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"
#import "NSString+MD5.h"

//#define TITLE @"登录"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

static LoginViewController* g_loginViewController;
static NSString* userString;
static NSString* passwordString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    g_loginViewController = self;
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_User.png"]];
    self.userTextField.leftView = imageView;
    self.userTextField.delegate = self;
    
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_Password.png"]];
    self.passwordTextField.delegate = self;
    self.passwordTextField.leftView = imageView2;
    
//    self.title = TITLE;
    // Do any additional setup after loading the view.
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (userString == nil)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alterView.message = @"请输入手机号";
        [alterView show];
    }
    else if (userString.length != 11)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alterView.message = @"请输入正确的手机号";
        [alterView show];
    }
    else if(passwordString == nil || [passwordString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alterView.message = @"请输入密码";
        [alterView show];
    }
    else
    {
        
        NSDictionary* userInformation = @{@"userName":userString,@"password":[[passwordString md5] lowercaseString]};
        LoginModel* loginModel = [LoginModel new];
        
        [[LoginNaviViewController shareLoginNaviViewController] waitingConnect];
        
        [loginModel loginWithuserImformation:userInformation success:^{
            
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSInteger responseCode) {
            
            [[LoginNaviViewController shareLoginNaviViewController] removeWaitingView];
            UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"无法连接到服务器" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            switch (responseCode)
            {
                case 1:
                    alterView.message = @"用户名不存在";
                    break;
                    
                case 9:
                    alterView.message = @"密码错误";
                    break;
                    
                case 3:
                    alterView.message = @"系统错误";
                    break;
                    
                default:
                    break;
            }
            [alterView show];
            
        }];
    }
    
}

- (IBAction)closeCuttonClick:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

+ (LoginViewController *)shareLoginViewController
{
    return g_loginViewController;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    userString = nil;
    passwordString = nil;
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
