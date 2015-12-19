//
//  PhotoViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/20.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.image = _photo;
    // Do any additional setup after loading the view.
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    self.photoImageView.image = _photo;
}

- (IBAction)resetTakeClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)autoDealClick:(id)sender
{
    
}

- (IBAction)userPhotoClick:(id)sender
{
    
//    UIImageWriteToSavedPhotosAlbum(_photo, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeImageToSavedPhotosAlbum:[_photo CGImage] orientation:(ALAssetOrientation)[_photo imageOrientation] completionBlock:nil];
    [assetsLibrary writeImageToSavedPhotosAlbum:[_photo CGImage] orientation:(ALAssetOrientation)[_photo imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
//        NSLog(@"assetURL:%@",assetURL);
//        NSLog(@"%@",_photo);
//        NSLog(@"%@",[_photo CGImage]);
        NSDictionary* dictionary = @{UIImagePickerControllerMediaType:ALAssetTypePhoto,UIImagePickerControllerOriginalImage:_photo,UIImagePickerControllerReferenceURL:assetURL};
        [_delegate usePhoto:dictionary];
    }];
    
//    assetsLibrary wr
    
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
