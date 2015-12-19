//
//  ComfirmViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/13.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ComfirmViewController.h"
#import "PRFileManager.h"
#import "ComfirmModel.h"
#import "NSString+MD5.h"
#import <Reachability.h>
#import "PersnoalCenterViewController.h"

@interface ComfirmViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *comfirmTableView;

@end

@implementation ComfirmViewController
{
    UITextField* nameTextField;
    UITextField* telNumTextField;
    UIImageView* licenseImageView;
    UIImagePickerController* cameraImagePicker;
    ComfirmModel* comfirmModel;
}

static NSString* phoneNumber;
static NSString* contactName;
static NSDictionary* license;

typedef NS_ENUM(NSInteger, AlterViewType)
{
    WifiType = 1 ,
    ComfirmSuccessType ,
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.comfirmTableView.dataSource = self;
    self.comfirmTableView.delegate = self;
    
    self.navigationItem.title = @"实名认证";
    // Do any additional setup after loading the view.
}


#pragma mark - IBAction

- (IBAction)comfirmButtonClick:(id)sender
{
    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"认证失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (phoneNumber == nil || [phoneNumber isEqualToString:@""])
    {
        alterView.message = @"请输入手机号";
        [alterView show];
    }
    else if (contactName == nil || [contactName isEqualToString:@""])
    {
        alterView.message = @"请输入联系人";
        [alterView show];
    }
    else if (phoneNumber.length > 11)
    {
        alterView.message = @"请输入正确的手机号码";
        [alterView show];
    }
    else if (contactName.length > 30)
    {
        alterView.message = @"联系人姓名过长(不超过30个汉字)";
        [alterView show];
    }
    else if (license == nil)
    {
        alterView.message = @"请选择营业执照";
        [alterView show];
    }
    else
    {
        Reachability* reach = [Reachability reachabilityWithHostname:URL_REACHABILITY];
        
        // Set the blocks
        reach.reachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (reach.isReachableViaWiFi)
                {
                    [self comfirm];
                }
                else
                {
                    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"当前未使用WIFI，是否继续？" message:@"" delegate:self cancelButtonTitle:@"否" otherButtonTitles: @"是",nil];
                    alterView.tag = WifiType;
                    [alterView show];
                }
                [reach stopNotifier];
            });
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            [self comfirm];
            [reach stopNotifier];
        };
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [reach startNotifier];

    }
}


- (void)comfirm
{
    if (comfirmModel == nil)
    {
        comfirmModel = [ComfirmModel new];
    }
    PRFileManager* fileManager = [PRFileManager sharePRFileManager];
    NSDictionary* dictionary = [fileManager readUserInformationFile];
    NSString* mac = [[[NSString stringWithFormat:@"%@%@%@%@",dictionary[@"userId"],contactName,phoneNumber,dictionary[@"encryptRandom"]] md5] lowercaseString];
    
    [[MainNaviViewController shareMainNaviViewController]waitingConnect];
    
    [comfirmModel comfirm:@{@"phoneNumber":phoneNumber,@"contactName":contactName,@"mac":mac} license:license success:^{
        
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
        
//        NSLog(@"VC SUCCESS");
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"提交成功，请等待审核" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        alterView.tag = ComfirmSuccessType;
        
    } failure:^(NSInteger responseCode) {
        
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
        
//        NSLog(@"responseCode:%ld",(long)responseCode);
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"认证失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        switch (responseCode)
        {
            case 13:
                alterView.message = @"数据不完整";
                break;
            case 14:
                alterView.message = @"认证表单数据提交失败";
                break;
            case 15:
                alterView.message = @"图片上传失败";
                break;
            case 16:
                alterView.message = @"图片上传失败，单张图片超过10M";
                break;
            case 17:
                alterView.message = @"图片上传失败，不支持图片类型";
                break;
            default:
                break;
        }
        [alterView show];
        
    }];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WifiType)
    {
        if (buttonIndex == 0)
        {
            
        }
        else
        {
            [self comfirm];
        }
    }
    else if (alertView.tag == ComfirmSuccessType)
    {
        [[PersnoalCenterViewController sharePersnoalCenterViewController] getPersonalInformation];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId;
    if ([indexPath row] == 0 || [indexPath row] == 1)
    {
        cellId = @"cellId1";
    }
    else if ([indexPath row] == 2)
    {
        cellId = @"cellId2";
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([indexPath row] == 0)
    {
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
        titleLabel.text = @"联系人";
        
        nameTextField = (UITextField*)[cell viewWithTag:2];
        nameTextField.placeholder = @"请输入联系人姓名";
        nameTextField.delegate = self;
    }
    else if ([indexPath row] == 1)
    {
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
        titleLabel.text = @"手机号";
        PRFileManager* fileManager = [PRFileManager sharePRFileManager];
        NSDictionary* userInformation = [fileManager readUserInformationFile];
        
        telNumTextField = (UITextField*)[cell viewWithTag:2];
        telNumTextField.text = userInformation[@"userName"];
        telNumTextField.delegate = self;
        phoneNumber = userInformation[@"userName"];
        telNumTextField.placeholder = @"请输入手机号";
    }
    else if ([indexPath row] == 2)
    {
        UILabel* titleLabel = (UILabel*)[cell viewWithTag:1];
        titleLabel.text = @"营业执照";
        
        licenseImageView = (UIImageView*)[cell viewWithTag:2];
//        NSLog(@"licenseImageView:%@",licenseImageView);
//        licenseImageView.image = [UIImage imageNamed:@"Login_User@2x.png"];
    }
    return cell;
}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 2)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
        [actionSheet showInView:self.view];
    }
    else if ([indexPath row] == 0)
    {
        [nameTextField becomeFirstResponder];
    }
    else if ([indexPath row] == 1)
    {
        [telNumTextField becomeFirstResponder];
    }
    
}


#pragma mark - textFieldDelegate

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
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == telNumTextField)
    {
        phoneNumber = textField.text;
    }
    else if (textField == nameTextField)
    {
        contactName = textField.text;
    }
}


#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController* imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        if (cameraImagePicker == nil)
        {
            cameraImagePicker = [UIImagePickerController new];
            cameraImagePicker.allowsEditing = YES;
            cameraImagePicker.delegate = self;
            cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:cameraImagePicker animated:YES completion:nil];
    }
}


#pragma mark - imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSLog(@"info:%@",info);
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    licenseImageView.image = image;
    if (picker == cameraImagePicker)
    {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    license = info;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"editingInfo:%@",editingInfo);
    licenseImageView.image = image;
    license = editingInfo;
    if (picker == cameraImagePicker)
    {
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self,selectorToCall, NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
//    
//    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
//    
//    //直接调用3.x的处理函数
//    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo
{
    if (paramError == nil)
    {
        NSLog(@"Image was saved successfully.");
    }
    else
    {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
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
