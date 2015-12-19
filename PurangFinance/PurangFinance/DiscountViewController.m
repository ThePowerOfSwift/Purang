//
//  DiscountViewController.m
//  普兰金融
//
//  Created by liumingkui on 15/4/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountModel.h"
#import "DiscountPhotoViewController.h"
#import "PRActionSheetPickerView.h"
#import "CityTableViewController.h"
#import "PRFileManager.h"
#import "NSString+MD5.h"
#import <Reachability.h>

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate,PRActionSheetPickerViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,CityTableViewControllerDelegate,DiscountPhotoViewControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *discuontTableView;

@end

@implementation DiscountViewController
{
    NSInteger dateNum;
    DiscountModel* discountModel;
    DiscountPhotoViewController* frontDiscountPhotoViewController;
    DiscountPhotoViewController* backDiscountPhotoViewController;
//    CityTableViewController* cityTableViewController;
    
    UILabel* becomeDateLabel;
    UILabel* discountDateLabel;
    UILabel* billTypeLabel;
    UILabel* cityLabel;
    UITextField* amountTextField;
    UITextField* priceTextField;
    UITextField* bankTextFiled;
    UIActionSheet* billTypeActionSheet;
    UIActionSheet* actionSheet2;
    UIButton* frontButton;
    UIButton* backButton;
}

typedef NS_ENUM(NSInteger, AlterViewType)
{
    WifiType = 1,
    DiscountSuccessType ,
};


//static DiscountViewController* g_discountViewController;

static NSString* billType;
static NSString* amountString;
static NSString* bankType;
static NSString* becomeDateString;
static NSString* discountDateString;
static NSString* cityCodeNum;
static NSString* priceString;
static NSArray* frontImage;
static NSArray* backImage;
static NSDate* discountDate;
static NSDate* becomeDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    discountModel = [DiscountModel new];
//    g_discountViewController = self;
    _discuontTableView.delegate = self;
    _discuontTableView.dataSource = self;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark - PRActionSheetPickerViewDelegate

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormatter stringFromDate:date];
//    NSString* dateString2 = [[[NSDateFormatter new] setDateFormat:@"yyyy-MM-dd"] stringFromDate:date];

    if (idNum == 1)
    {
        becomeDateLabel.text = dateString;
        becomeDateLabel.textColor = [UIColor blackColor];
        becomeDateString = dateString;
        becomeDate = date;
//        NSLog(@"becomeDate:%@",becomeDate);
    }
    else if (idNum == 2)
    {
        discountDateLabel.text = dateString;
        discountDateLabel.textColor = [UIColor blackColor];
        discountDateString = dateString;
        discountDate = date;
//        NSLog(@"discountDate:%@",discountDate);
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2)
    {
        return 80;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ([indexPath section] == 0 && [indexPath row] == 0)
    {
        if (billTypeActionSheet == nil)
        {
            billTypeActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择票类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"银票（纸票）",@"银票（电票）",@"商票（纸票）",@"商票（电票）", nil];
            billTypeActionSheet.tag = 1;
        }
//        NSLog(@"billTypeActionSheet:%p",billTypeActionSheet);
        [billTypeActionSheet showInView:self.view];
    }
    else if ([indexPath section] == 0 && [indexPath row] == 3)
    {
        dateNum = 1;
        PRActionSheetPickerView* action = [[PRActionSheetPickerView alloc]initWithFrame:self.view.bounds];
        action.delegate = self;
        [action showDatePickerInView:self.view withId:dateNum];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 0)
    {
        dateNum = 2;
        PRActionSheetPickerView* action = [[PRActionSheetPickerView alloc]initWithFrame:self.view.bounds];
        action.delegate = self;
        [action showDatePickerInView:self.view withId:dateNum];
    }
    else if ([indexPath section] == 1 && [indexPath row] == 1)
    {
        if ([billType isEqualToString:@"银票-电票"] || [billType isEqualToString:@"商票-电票"])
        {
            return;
        }
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CityTableViewController* cityTableViewController = [mainSB instantiateViewControllerWithIdentifier:@"city"];
        cityTableViewController.type = DiscountType;
        cityTableViewController.delegate = self;
        [self.navigationController pushViewController:cityTableViewController animated:YES];
    }
    else if ([indexPath section] == 2 && [indexPath row] == 0)
    {
        if (frontDiscountPhotoViewController == nil)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            frontDiscountPhotoViewController = [mainSB instantiateViewControllerWithIdentifier:@"discountPhoto"];
            frontDiscountPhotoViewController.delegate = self;
        }
        [self.navigationController pushViewController:frontDiscountPhotoViewController animated:YES];
    }
    else if ([indexPath section] == 2 && [indexPath row] == 1)
    {
        
        if (backDiscountPhotoViewController == nil)
        {
            UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            backDiscountPhotoViewController = [mainSB instantiateViewControllerWithIdentifier:@"discountPhoto"];
            backDiscountPhotoViewController.delegate = self;
        }
        [self.navigationController pushViewController:backDiscountPhotoViewController animated:YES];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 0 && (row == 0  || row == 3))
    {
        cellId = @"cellId1";
    }
    else if (section == 1 && (row == 0 || row == 1))
    {
        cellId = @"cellId1";
    }
    else if (section == 0 && (row == 1 || row == 2))
    {
        cellId = @"cellId2";
    }
    else if (section == 1 && row == 2)
    {
        cellId = @"cellId2";
    }
    else if (section == 2)
    {
        cellId = @"cellId3";
    }
    

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (section == 0 && row == 0)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"票   类";
        billTypeLabel = (UILabel*)[cell viewWithTag:2];
        billTypeLabel.text = @"银票、商票、纸票、电票";
        if (billType && ![billType isEqualToString:@""])
        {
            billTypeLabel.text = billType;
        }
    }
    if (section == 0 && row == 1)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"金   额";
        amountTextField = (UITextField*)[cell viewWithTag:2];
        amountTextField.placeholder = @"请输入票面金额";
        amountTextField.delegate = self;
        amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        amountTextField.returnKeyType = UIReturnKeyDone;
        UILabel* rightLabel = (UILabel*)[cell viewWithTag:3];
        rightLabel.text = @"万";
    }
    else if (section == 0 && row == 2)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"承兑行";
        bankTextFiled = (UITextField*)[cell viewWithTag:2];
        bankTextFiled.placeholder = @"请输入承兑行（50字以内）";
        bankTextFiled.delegate = self;
        UILabel* rightLabel = (UILabel*)[cell viewWithTag:3];
        rightLabel.hidden = YES;
    }
    else if (section == 0 && row == 3)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"到期日";
        becomeDateLabel = (UILabel*)[cell viewWithTag:2];
        becomeDateLabel.text = @"请选择到期日";
    }
    else if (section == 1 && row == 0)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"贴现日";
        discountDateLabel = (UILabel*)[cell viewWithTag:2];
        discountDateLabel.text = @"请选择贴现日";
    }
    else if (section == 1 && row == 1)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"贴现地";
        cityLabel = (UILabel*)[cell viewWithTag:2];
        cityLabel.text = @"请选择贴现地";
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:3];
        imageView.image = [UIImage imageNamed:@"discount_location.png"];
    }
    else if (section == 1 && row == 2)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"价   格";
        priceTextField = (UITextField*)[cell viewWithTag:2];
        priceTextField.placeholder = @"请输入意愿交易价格";
        priceTextField.delegate = self;
        priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        priceTextField.returnKeyType = UIReturnKeyDone;
        UILabel* rightLabel = (UILabel*)[cell viewWithTag:3];
        rightLabel.text = @"‰";
//        NSLog(@"rightLabel.text:%@",rightLabel.text);
    }
    else if (section == 2 && row == 0)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"汇票正面";
        frontButton = (UIButton*)[cell viewWithTag:2];
    }
    else if (section == 2 && row == 1)
    {
        UILabel* leftLabel = (UILabel*)[cell viewWithTag:1];
        leftLabel.text = @"汇票背面";
        backButton = (UIButton*)[cell viewWithTag:2];
    }
    
    return cell;
}


#pragma mark - actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            billTypeLabel.text = @"银票（纸票）";
            billType = @"银票-纸票";
            billTypeLabel.textColor = [UIColor blackColor];
        }
        else if (buttonIndex == 1)
        {
            billTypeLabel.text = @"银票（电票）";
            billType = @"银票-电票";
            billTypeLabel.textColor = [UIColor blackColor];
        }
        else if (buttonIndex == 2)
        {
            billTypeLabel.text = @"商票（纸票）";
            billType = @"商票-纸票";
            billTypeLabel.textColor = [UIColor blackColor];
        }
        else if (buttonIndex == 3)
        {
            billTypeLabel.text = @"商票（电票）";
            billType = @"商票-电票";
            billTypeLabel.textColor = [UIColor blackColor];
        }
    }
    if ([billType isEqualToString:@"银票-电票"] || [billType isEqualToString:@"商票-电票"])
    {
        cityLabel.text = @"无";
        cityCodeNum = @"";
    }
    else
    {
        cityLabel.text = @"请选择贴现地";
        cityLabel.textColor = [UIColor colorFromHexCode:@"d2d2d2"];
        cityLabel.text = nil;
    }
//    else if (actionSheet.tag == 2)
//    {
//        NSLog(@"2");
//    }
}


#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    if (textField == bankTextFiled)
    {
        if (textField.text.length < 50)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    if (range.location == 0 && [string isEqualToString:@"."])
    {
        return NO;
    }
    
    if ([UIDevice getiOSVersion] >= 8.0)
    {
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."])
        {
            return NO;
        }
    }
    
    NSRange dotRange = [textField.text rangeOfString:@"."];
    if (dotRange.location > 0 && dotRange.location < textField.text.length + 1 && [string isEqualToString:@"."])
    {
        return NO;
    }
    
    if (dotRange.location <= 0 || dotRange.location > textField.text.length )
    {
        if ([string isEqualToString:@"."])
        {
            return YES;
        }
        else if (textField.text.length > 9)
        {
            return NO;
        }
    }
    
    
    if (textField == amountTextField)
    {
        if(dotRange.location < textField.text.length)
        {
            if (textField.text.length - dotRange.location > 6)
            {
                return NO;
            }
        }
    }
    if (textField == priceTextField)
    {
        if(dotRange.location < textField.text.length)
        {
            if (textField.text.length - dotRange.location > 2)
            {
                return NO;
            }
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == amountTextField)
    {
//        NSLog(@"%f",textField.text.floatValue);
        if (textField.text.floatValue > 0)
        {
            amountString = [NSString stringWithFormat:@"%@",textField.text];
//            textField.text = amountString;
        }
    }
    else if (textField == priceTextField)
    {
        if (textField.text.floatValue > 0)
        {
            priceString = [NSString stringWithFormat:@"%@",textField.text];
            
        }
//        priceString = priceTextField.text;
    }
    else if (textField == bankTextFiled)
    {
        bankType = bankTextFiled.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - CityTableViewControllerDelegate

- (void)getCityWithCityName:(NSString *)cityName
{
    cityLabel.text = cityName;
    cityLabel.textColor = [UIColor blackColor];
}

- (void)getCityCode:(NSString *)cityCode
{
    cityCodeNum = cityCode;
}


#pragma mark - DiscountPhotoViewControllerDelegate

- (void)discountPhotoViewController:(DiscountPhotoViewController *)discountPhotoViewController getPhotoImage:(NSArray *)imageArray
{
    if (discountPhotoViewController == frontDiscountPhotoViewController)
    {
        frontImage = imageArray;
        [frontButton setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count] forState:UIControlStateNormal];
        if (imageArray.count == 0)
        {
            frontButton.hidden = YES;
        }
        else
        {
            frontButton.hidden = NO;
        }
    }
    else if (discountPhotoViewController == backDiscountPhotoViewController)
    {
        backImage = imageArray;
        [backButton setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)imageArray.count] forState:UIControlStateNormal];
        if (imageArray.count == 0)
        {
            backButton.hidden = YES;
        }
        else
        {
            backButton.hidden = NO;
        }
    }
}


#pragma mark - IBAction

- (IBAction)submitButtonClick:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (billType == nil)
    {
        alterView.message = @"请选择票类";
        [alterView show];
        return;
    }
    if (amountString == nil || [amountString isEqualToString:@""])
    {
        alterView.message = @"请输入票面金额";
        [alterView show];
        return;
    }
//    NSLog(@"banktyoe:%@",bankType);
    if (bankType == nil)
    {
        alterView.message = @"请输入承兑行";
        [alterView show];
        return;
    }
    if (bankType.length > 49)
    {
        alterView.message = @"承兑行名称不能超过50字";
        [alterView show];
        return;
    }
    if (becomeDateString == nil)
    {
        alterView.message = @"请选择到期日";
        [alterView show];
        return;
    }
    if (discountDateString == nil)
    {
        alterView.message = @"请选择贴现日";
        [alterView show];
        return;
    }
    if (cityCodeNum == nil)
    {
        alterView.message = @"请选择贴现地";
        [alterView show];
        return;
    }
    if (priceString == nil || [priceString isEqualToString:@""])
    {
        alterView.message = @"请输入意愿交易价格";
        [alterView show];
        return;
    }
//    if (frontImage == nil || frontImage.count == 0)
//    {
//        alterView.message = @"请选择票面正面";
//        [alterView show];
//        return;
//    }
//    if (backImage == nil || backImage.count == 0)
//    {
//        alterView.message = @"请选择票面背面";
//        [alterView show];
//        return;
//    }
//    if (frontImage.count != backImage.count)
//    {
//        alterView.message = @"票面正面数量与票面背面数量不等";
//        [alterView show];
//        return;
//    }
    if ([becomeDate compare:discountDate] == NSOrderedAscending || [becomeDate isEqualToDate:discountDate])
    {
        alterView.message = @"贴现日应早于到期日";
        [alterView show];
        return;
    }
    Reachability* reach = [Reachability reachabilityWithHostname:URL_REACHABILITY];
    
    // Set the blocks
    [[MainNaviViewController shareMainNaviViewController]waitingConnect];
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reach.isReachableViaWiFi)
            {
                [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
                [self discount];
            }
            else
            {
                [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
                UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"当前未使用WIFI，是否继续？" message:@"" delegate:self cancelButtonTitle:@"否" otherButtonTitles: @"是",nil];
                alterView.tag = WifiType;
                [alterView show];
                
            }
            [reach stopNotifier];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
        [self discount];
        [reach stopNotifier];
    };
    
    [reach startNotifier];
    
}


#pragma mark - alterViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WifiType) {
        if (buttonIndex == 0)
        {
            
        }
        else
        {
            [self discount];
        }
    }
    else if (alertView.tag == DiscountSuccessType)
    {
        [self clearFormData];
    }
}

- (void)discount
{
    PRFileManager* fileManager = [PRFileManager sharePRFileManager];
    NSDictionary* dictionary = [fileManager readUserInformationFile];
    NSString* mac = [[[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",dictionary[@"userId"],billType,amountString,bankType,becomeDateString,discountDateString,cityCodeNum,priceString,dictionary[@"encryptRandom"]] md5] lowercaseString];
    NSDictionary* information = @{@"discountType":billType,@"sum":amountString,@"acceptingBank":bankType,@"expireDate":becomeDateString,@"discountDate":discountDateString,@"discountPlace":cityCodeNum,@"price":priceString,@"mac":mac};
    
    //    NSLog(@"information:%@",information);
    
    //    NSLog(@"front:%@",frontImage);
    
    //    NSLog(@"back:%@",backImage);
    [[MainNaviViewController shareMainNaviViewController]waitingConnect];
    
    [discountModel submit:information frontImage:frontImage backImage:backImage success:^{
        
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
        
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"申报成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alterView.tag = DiscountSuccessType;
        [alterView show];
        
    } failure:^(NSInteger responseCode) {
        
        [[MainNaviViewController shareMainNaviViewController]removeWaitingView];
        
        NSLog(@"responseCode:%ld",(long)responseCode);
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"申报失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        switch (responseCode)
        {
            case 13:
                alterView.message = @"数据不完整";
                break;
            case 14:
                alterView.message = @"贴现表单数据提交失败";
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


#pragma mark - self method

- (void)rightClick:(id)sender
{
    [self clearFormData];
}

- (void)clearFormData
{
    becomeDateLabel.text = @"请选择到期日";
    becomeDateLabel.textColor = [UIColor colorFromHexCode:@"d2d2d2"];
    
    discountDateLabel.text = @"请选择贴现日";
    discountDateLabel.textColor = [UIColor colorFromHexCode:@"d2d2d2"];
    
    billTypeLabel.text = @"银票、商票、纸票、电票";
    billTypeLabel.textColor = [UIColor colorFromHexCode:@"d2d2d2"];
    
    cityLabel.text = @"请选择贴现地";
    cityLabel.textColor = [UIColor colorFromHexCode:@"d2d2d2"];
    
    amountTextField.text = nil;
    
    priceTextField.text = nil;
    
    bankTextFiled.text = nil;
    
    billType = nil;
    
    amountString = nil;
    
    bankType = nil;
    
    becomeDateString = nil;
    
    discountDateString = nil;
    
    cityCodeNum = nil;
    
    priceString = nil;
    
    frontImage = nil;
    
    backImage = nil;
    
    frontDiscountPhotoViewController = nil;
    
    backDiscountPhotoViewController = nil;
    
    frontButton.hidden = YES;
    
    backButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self clearFormData];
    [super viewDidAppear:animated];
    
}

//+ (DiscountViewController *)shareDiscountViewController
//{
//    return g_discountViewController;
//}

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
