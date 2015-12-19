//
//  DiscountModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/14.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "DiscountModel.h"
#import "ELCImagePickerHeader.h"
#import "UIImage+Resolution.h"
#import "LoginModel.h"

@implementation DiscountModel

- (void)submit:(NSDictionary*)information frontImage:(NSArray*)frontImage backImage:(NSArray*)backImage success:(void (^)())success failure:(void (^)(NSInteger responseCode))failure
{
//    NSLog(@"submit");
    NSLog(@"information:%@",information);
    NSLog(@"frontImage:%@",frontImage);
    NSLog(@"backImage:%@",backImage);
    PRHTTPSessionManager* discountManager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSString* url = URL_HEAD(URL_DISCOUNTSUBMIT);
    NSLog(@"url:%@",url);
    [discountManager POST:url parameters:information constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSDictionary* dict in frontImage)
        {
            NSData* data;
            NSString* mimeType;
            NSString* name;
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
            {
                UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];
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
                    
                    name = [NSString stringWithFormat:@"frontImage%ld.png",(unsigned long)[frontImage indexOfObject:dict]];
                    mimeType = @"image/png";
                }
                else
                {
                    //返回为JPEG图像。
                    data = UIImageJPEGRepresentation(newImage, 0.7);
                    mimeType = @"image/jpg";
                    name = [NSString stringWithFormat:@"frontImage%ld.jpg",(unsigned long)[frontImage indexOfObject:dict]];
                }
                [formData appendPartWithFileData:data name:@"frontFiles" fileName:name mimeType:mimeType];
//                [formData appendPartWithFormData:data name:@"frontFiles"];
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        for (NSDictionary* dict in backImage)
        {
            NSData* data;
            NSString* mimeType;
            NSString* name;
//            NSString* name = [NSString stringWithFormat:@"backImage%ld",[backImage indexOfObject:dict]];
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
            {
                UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];
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
                    name = [NSString stringWithFormat:@"backImage%ld.png",(unsigned long)[backImage indexOfObject:dict]];
                    mimeType = @"image/png";
                }
                else
                {
                    //返回为JPEG图像。
                    data = UIImageJPEGRepresentation(newImage, 1.0);
                    mimeType = @"image/jpg";
                    name = [NSString stringWithFormat:@"backImage%ld.jpg",(unsigned long)[backImage indexOfObject:dict]];
                }
                [formData appendPartWithFileData:data name:@"backFiles" fileName:name mimeType:mimeType];
//                [formData appendPartWithFormData:data name:@"backFiles"];
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
//        NSLog(@"formData:%@",formData);
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
        
        NSLog(@"error:%@",error);
        if ([UIDevice getiOSVersion] < 8.0)
        {
            NSRange range = [error.localizedDescription rangeOfString:@"401"];
            if (range.location > 0 && range.location < error.localizedDescription.length)
            {
                [LoginModel autoLoginSuccess:^{
                    
                    [self submit:information frontImage:frontImage backImage:backImage success:success failure:failure];
                    
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
                
                [self submit:information frontImage:frontImage backImage:backImage success:success failure:failure];
                
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
