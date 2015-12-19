//
//  CalulatorViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorModel.h"
#import "PRActionSheetPickerView.h"
#import "CalulatorResultViewController.h"
#import "NSCalendar+PRCalender.h"

@interface CalculatorViewController ()<UITableViewDelegate,UITableViewDataSource,PRActionSheetPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *inputTableView;

@end

@implementation CalculatorViewController
{
    CalculatorModel* calculatorModel;
    UILabel* discoutLabel;
    UILabel* becomeLabel;
    UILabel* percentLabel;
    
    NSInteger percentNum;
    
    
    UITextField* amountTextField;
    UITextField* yieldTextField;
    UITextField* adjustTextField;
    
    NSString* amountString;
    NSString* yieldString;
    NSString* adjustString;
    
    NSDate* discountDate;
    NSDate* becomeDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    calculatorModel = [CalculatorModel new];
    
    _inputTableView.delegate = self;
    _inputTableView.dataSource = self;

    percentNum = 1000;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.navigationItem.backBarButtonItem.title = nil;
    // Do any additional setup after loading the view.
}


#pragma mark - button click

- (IBAction)yieldButtonClick:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"%",@"‰", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)calculatorClick:(id)sender
{
    [self.view endEditing:YES];
//    NSLog(@"amount:%@\nyield:%@\nadjust%@\n",amountString,yieldString,adjustString);
    if (amountString == nil || [amountString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"计算失败" message:@"请输入票面金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    else if (yieldString == nil || [yieldString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"计算失败" message:@"请输入利率" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    else if (adjustString == nil || [adjustString isEqualToString:@""])
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"计算失败" message:@"请输入调整天数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    else if(discountDate == nil)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"计算失败" message:@"请选择贴现日" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    else if(becomeDate == nil)
    {
        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"计算失败" message:@"请选择到期日" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
        return;
    }
    
    NSDecimalNumber* interestAccrualDays = [self interestAccrualDays];
    NSDecimalNumber* interest = [self interestPayableWithAmount:[[NSDecimalNumber decimalNumberWithString:amountString] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]] andInterestAccrualDays:interestAccrualDays andYield:[[NSDecimalNumber decimalNumberWithString:yieldString]decimalNumberByDividingBy:[[NSDecimalNumber alloc]initWithInteger:percentNum]]];
    NSDecimalNumber* paidInAmount = [self paidInAmount:[[NSDecimalNumber decimalNumberWithString:amountString]decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10000"]] andInterest:interest];
    NSLog(@"interestAccrualDays%@interest%@paidInAmount%@",interestAccrualDays,interest,paidInAmount);
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];//保留两位小数，四舍五入
    
//    commissionDetailNumber = [commissionDetailNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    
    interestAccrualDays = [interestAccrualDays decimalNumberByRoundingAccordingToBehavior:roundUp];
    interest = [interest decimalNumberByRoundingAccordingToBehavior:roundUp];
    paidInAmount = [paidInAmount decimalNumberByRoundingAccordingToBehavior:roundUp];
    NSDictionary* dictionary = @{@"interestAccrualDays":interestAccrualDays,@"interest":interest,@"paidInAmount":paidInAmount};
    UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CalulatorResultViewController* calulatorResultViewController = [mainSB instantiateViewControllerWithIdentifier:@"CalulatorResult"];
    calulatorResultViewController.resultDicitonary = dictionary;
    [self.navigationController pushViewController:calulatorResultViewController animated:YES];
}

- (void)rightClick:(id)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.view endEditing:YES];
    
    discoutLabel.text = @"请选择贴现日";
    becomeLabel.text = @"请选择到期日";
    amountTextField.text = @"";
    yieldTextField.text = @"";
    adjustTextField.text = @"";
    
    amountString = @"";
    yieldString = @"";
    adjustString = @"";
    
    discountDate = nil;
    becomeDate = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId;
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:
            cellId = @"cellId1";
            break;
        case 1:
            cellId = @"cellId2";
            break;
        case 2:
            cellId = @"cellId3";
            break;
        case 3:
            cellId = @"cellId4";
            break;
        case 4:
            cellId = @"cellId5";
            break;
            
        default:
            break;
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([indexPath row] == 0)
    {
        amountTextField = (UITextField*)[cell viewWithTag:2];
        amountTextField.delegate = self;
        amountTextField.placeholder = @"请输入票面金额";
        amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        amountTextField.returnKeyType = UIReturnKeyDone;
    }
    else if ([indexPath row] == 1)
    {
        yieldTextField = (UITextField*)[cell viewWithTag:2];
        yieldTextField.delegate = self;
        yieldTextField.placeholder = @"请输入利率";
        yieldTextField.keyboardType = UIKeyboardTypeDecimalPad;
        yieldTextField.returnKeyType = UIReturnKeyDone;
        
        percentLabel = (UILabel*)[cell viewWithTag:3];
    }
    else if ([indexPath row] == 4)
    {
        adjustTextField = (UITextField*)[cell viewWithTag:2];
        adjustTextField.delegate = self;
        adjustTextField.placeholder = @"请输入调整天数";
        adjustTextField.keyboardType = UIKeyboardTypeDecimalPad;
        adjustTextField.returnKeyType = UIReturnKeyDone;
    }
    else if ([indexPath row] == 2)
    {
        discoutLabel = (UILabel*)[cell viewWithTag:2];
        discoutLabel.text = @"请选择贴现日";
    }
    else if ([indexPath row] == 3)
    {
        becomeLabel = (UILabel*)[cell viewWithTag:2];
        becomeLabel.text = @"请选择到期日";
    }
    
    return cell;
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ([indexPath row] == 1)
    {
        
    }
    else if ([indexPath row] == 2)
    {
        PRActionSheetPickerView* action = [[PRActionSheetPickerView alloc]initWithFrame:self.view.bounds];
        action.delegate = self;
        [action showDatePickerInView:self.view withId:3];
    }
    else if ([indexPath row] == 3)
    {
        PRActionSheetPickerView* action = [[PRActionSheetPickerView alloc]initWithFrame:self.view.bounds];
        action.delegate = self;
        [action showDatePickerInView:self.view withId:4];
    }
}


#pragma mark - textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
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
    
    if (textField == adjustTextField)
    {
        if ([string isEqualToString:@"."])
        {
            return NO;
        }
    }
    
    if ([UIDevice getiOSVersion] >= 8.0)
    {
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."])
        {
            return NO;
        }
    }
    
    //iOS 8以下
    NSRange dotRange = [textField.text rangeOfString:@"."];
    if (dotRange.location > 0 && dotRange.location < textField.text.length + 1 && [string isEqualToString:@"."])
    {
        return NO;
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
    if (textField == yieldTextField)
    {
        if(dotRange.location < textField.text.length)
        {
            if (textField.text.length - dotRange.location > 4)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == amountTextField)
    {
        amountString = amountTextField.text;
    }
    else if (textField == adjustTextField)
    {
        adjustString = adjustTextField.text;
    }
    else if (textField == yieldTextField)
    {
        yieldString = yieldTextField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - PRActionSheetPickerViewDelegate

- (void)getDateWithDate:(NSDate *)date andId:(NSInteger)idNum
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    //    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSString* str = [dateFormatter stringFromDate:date];
//    NSLog(@"date:%@",date);
    if (idNum == 3)
    {
        //        NSString* str = [NSString stringWithFormat:@"%@",date];
        discoutLabel.text = str;
        discountDate = date;
    }
    else if (idNum == 4)
    {
        //        NSString* str = [NSString stringWithFormat:@"%@",date];
        becomeLabel.text = str;
        becomeDate = date;
    }
}


#pragma mark - 计算两个日期之间的差值

- (NSInteger)calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd
{
    NSCalendar* calen = [NSCalendar currentCalendar];
    NSInteger days = [calen daysWithinEraFromDate:inBegin toDate:inEnd];
    return days;
}


#pragma mark - 计算

- (NSDecimalNumber*)interestAccrualDays//计息天数
{
    NSInteger days = [self calcDaysFromBegin:discountDate end:becomeDate];
    NSDecimalNumber* daysNumber = [[NSDecimalNumber alloc]initWithInteger:days];
    NSDecimalNumber* adjustNumber = [[NSDecimalNumber alloc]initWithString:adjustString];
    return [adjustNumber decimalNumberByAdding:daysNumber];
}

- (NSDecimalNumber*)interestPayableWithAmount:(NSDecimalNumber*)amount andInterestAccrualDays:(NSDecimalNumber*)interestAccrualDays andYield:(NSDecimalNumber*)yield//应付利息
{
    return [[[amount decimalNumberByMultiplyingBy:yield]decimalNumberByMultiplyingBy:interestAccrualDays]decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"30"]];
}

- (NSDecimalNumber*)paidInAmount:(NSDecimalNumber*)amount andInterest:(NSDecimalNumber*)interest//实收金额
{
    return [amount decimalNumberBySubtracting:interest];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        percentNum = 100;
        percentLabel.text = @"%";
    }
    else if (buttonIndex == 1)
    {
        percentNum = 1000;
        percentLabel.text = @"‰";
    }
}


#pragma mark - self method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
