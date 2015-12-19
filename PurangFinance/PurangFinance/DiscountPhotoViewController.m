//
//  DiscountPhotoViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/16.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "DiscountPhotoViewController.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "PhotoBrowseViewController.h"
#import "CameraViewController.h"
#import "DiscountViewController.h"

@interface DiscountPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,PhotoBrowseViewControllerDelegate,CameraViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation DiscountPhotoViewController
{
    NSMutableArray* imageArray;
    PhotoBrowseViewController* photoBrowseViewController;
    NSInteger firstShow;
}

static DiscountPhotoViewController* g_DiscountPhotoViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    g_DiscountPhotoViewController = self;
    
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    
    imageArray = [NSMutableArray new];
    
    firstShow = 1;
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    if ([UIDevice getiOSVersion] > 8.0)
//    {
//        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照", nil];
//        [actionSheet showInView:self.view];
//    }
    
    // Do any additional setup after loading the view.
}

- (void)leftClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate discountPhotoViewController:self getPhotoImage:imageArray];
}

- (void)rightClick:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (photoBrowseViewController == nil)
    {
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        photoBrowseViewController = [mainSB instantiateViewControllerWithIdentifier:@"PhotoBrowse"];
        photoBrowseViewController.delegate = self;
    }
    [photoBrowseViewController setimageArray:imageArray andCurrentIndex:[indexPath row]];
    [self.navigationController pushViewController:photoBrowseViewController animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    
    NSDictionary* dict = [imageArray objectAtIndex:[indexPath row]];

    if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
    {
        UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];

        imageView.image = image;
    }
    else
    {
        NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
    }
    
    return cell;
}


#pragma mark - CameraViewControllerDelegate

- (void)getPhoto:(NSDictionary *)imageDictionary
{
    [imageArray addObject:imageDictionary];
//    NSLog(@"imageArray:%@",imageArray);
    [self.photoCollectionView reloadData];
}


#pragma mark - PhotoBrowseViewControllerDelegate

- (void)deleteImageWithIndex:(NSInteger)index
{
    [imageArray removeObjectAtIndex:index];
    [_photoCollectionView reloadData];
}


#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [imageArray addObjectsFromArray:info];
    [_photoCollectionView reloadData];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 2)
    {
        return;
    }
    if (buttonIndex == 0)
    {
        //相册
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
        
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        //拍照
        UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CameraViewController* cameraViewController = [mainSB instantiateViewControllerWithIdentifier:@"camera"];
        cameraViewController.delegate = self;
        [self.navigationController pushViewController:cameraViewController animated:YES];
    }
}

+ (DiscountPhotoViewController *)shareDiscountPhotoViewController
{
    return g_DiscountPhotoViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (firstShow == 1 && [UIDevice getiOSVersion] >= 8.0)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照", nil];
        [actionSheet showInView:self.view];
        firstShow = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (firstShow == 1 && [UIDevice getiOSVersion] < 8.0)
    {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"拍照", nil];
        [actionSheet showInView:self.view];
        firstShow = 0;
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
