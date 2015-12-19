//
//  ComfirmModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/5/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "ComfirmModel.h"
#import "PRHTTPSessionManager.h"
#import "UIImage+Resolution.h"
#import "LoginModel.h"

@implementation ComfirmModel

- (void)comfirm:(NSDictionary*)companyInformation license:(NSDictionary*)license success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
    PRHTTPSessionManager* comfirmManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_COMFIRM);
    NSLog(@"url:%@",url);
    NSLog(@"companyInformation:%@",companyInformation);
    [comfirmManager POST:url parameters:companyInformation constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* data;
        NSString* mimeType;
        NSString* name;
        if (license[UIImagePickerControllerEditedImage])
        {
            UIImage* image = license[UIImagePickerControllerEditedImage];
            CGSize newSize = image.size;
            //                NSLog(@"w:%f h:%f",newSize.width,newSize.height);
            UIImage* newImage;
            
            if (newSize.width > 1000 || image.size.height > 1000)
            {
                newImage = [image imageScaledToSize:CGSizeMake(newSize.width*0.5, newSize.width*0.5)];
            }
            else
            {
                newImage = image;
            }
            if (UIImagePNGRepresentation(newImage))
            {
                //返回为png图像。
                data = UIImagePNGRepresentation(newImage);
                name = @"licenseImage.png";
                mimeType = @"image/png";
            }else
            {
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(image, 1.0);
                mimeType = @"image/jpg";
                name = @"licenseImage.jpg";
            }
            [formData appendPartWithFileData:data name:@"licenseFiles" fileName:name mimeType:mimeType];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] isEqualToString:@"true"])
        {
            success();
        }
        else
        {
            failure([responseObject[@"responseCode"] integerValue]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self comfirm:companyInformation license:license success:success failure:failure];
                    
                } failure:^(NSInteger responseCode) {
                    
                    failure(0);
                    
                }];
            }
            else
            {
                failure(0);
            }
        }
        else if ([error.localizedDescription containsString:@"401"])
        {
            [LoginModel autoLoginSuccess:^{
                
                [self comfirm:companyInformation license:license success:success failure:failure];
                
            } failure:^(NSInteger responseCode) {
                
                failure(0);
                
            }];
        }
        else
        {
            failure(0);
        }
        
    }];
}

@end

