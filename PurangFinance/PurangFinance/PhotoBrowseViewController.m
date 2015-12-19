//
//  PhotoBrowseViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/17.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "PhotoBrowseViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCImagePickerHeader.h"
#import "DiscountPhotoViewController.h"

@interface PhotoBrowseViewController ()<UIScrollViewDelegate>
{
    NSMutableArray* _imageArray;
    NSInteger _currentIndex;
    
}

@end

@implementation PhotoBrowseViewController
{
    BOOL naviBarHidden;
    UIScrollView* photoScrollView;
    
    NSMutableArray* imageViewArray;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat lastScale;
    
    NSMutableArray* guestureArray;
    
    NSInteger changedNo;
    
    CGAffineTransform _currentTransform;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    naviBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIView* view = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    width = [UIDevice width];
    height = [UIDevice height];
    
    photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    photoScrollView.contentSize = CGSizeMake(width * 3.0, 0);
    photoScrollView.pagingEnabled = YES;
    photoScrollView.delegate = self;
    photoScrollView.contentOffset = CGPointMake(width, 0);
    photoScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:photoScrollView];
    
    imageViewArray = [[NSMutableArray alloc]init];
    guestureArray = [[NSMutableArray alloc]init];
    [self setAllImage];
}

- (void)setimageArray:(NSMutableArray *)imageArray andCurrentIndex:(NSUInteger)currentIndex
{
    for (UIView* view in [photoScrollView subviews])
    {
        [view removeFromSuperview];
    }
    
    [_imageArray removeAllObjects];
    if (_imageArray == nil)
    {
        _imageArray = [[NSMutableArray alloc]init];
    }
    else
    {
        [_imageArray removeAllObjects];
    }
    [_imageArray addObjectsFromArray:imageArray];
    _currentIndex = currentIndex;
    if (imageViewArray)
    {
        [imageViewArray removeAllObjects];
    }
    [self setAllImage];
}


#pragma mark - 放置图片

- (void)setAllImage
{
    photoScrollView.contentSize = CGSizeMake(width * _imageArray.count, 0);
    photoScrollView.contentOffset = CGPointMake(width * _currentIndex, 0);
    
    for (NSInteger i = 0; i < _imageArray.count; i++)
    {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
        [imageView addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [guestureArray addObject:pan];
        
        _currentTransform = imageView.transform;
        
        [photoScrollView addSubview:imageView];
        [imageViewArray addObject:imageView];
        NSDictionary* dict = [_imageArray objectAtIndex:i];
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            imageView.image = image;
            
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
    }
}

- (void)resetImage
{
    photoScrollView.contentSize = CGSizeMake(width * _imageArray.count, 0);
    photoScrollView.contentOffset = CGPointMake(width * _currentIndex, 0);
    
    for (NSInteger i = 0; i < _imageArray.count; i++)
    {
        UIImageView* imageView = [imageViewArray objectAtIndex:i];
        imageView.tag = i;
        UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
        [imageView addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [guestureArray addObject:pan];
        
        _currentTransform = imageView.transform;
        
        [photoScrollView addSubview:imageView];
        [imageViewArray addObject:imageView];
        NSDictionary* dict = [_imageArray objectAtIndex:i];
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            imageView.image = image;
            
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
        }
    }

}

#pragma mark - 删除

- (void)rightClick:(id)sender
{
    [_imageArray removeObjectAtIndex:_currentIndex];
    if (_imageArray.count <= 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [_delegate deleteImageWithIndex:_currentIndex];
    photoScrollView.contentSize = CGSizeMake(width * _imageArray.count, 0);
    if (_currentIndex > _imageArray.count - 1)
    {
        _currentIndex = _imageArray.count - 1;
        [photoScrollView setContentOffset:CGPointMake(width*_currentIndex, 0) animated:YES];
    }
    
    UIImageView* lastImageView = (UIImageView*)imageViewArray.lastObject;
    [lastImageView removeFromSuperview];
    [imageViewArray removeLastObject];
    [self resetImage];
}


- (void)pinchGesture:(UIPinchGestureRecognizer*)pinch
{
    if([pinch state] == UIGestureRecognizerStateBegan)
    {
        if (lastScale == 2)
        {
            return;
        }
    }
    if([pinch state] == UIGestureRecognizerStateEnded)
    {
        changedNo = pinch.view.tag;
        if (lastScale > 2)
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform newTransform = CGAffineTransformScale(_currentTransform, 2, 2);
                [[pinch view]setTransform:newTransform];
                lastScale = 2;
            }];
            photoScrollView.scrollEnabled = NO;
        }
        else if (lastScale < 1)
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGAffineTransform newTransform = CGAffineTransformScale(_currentTransform, 1, 1);
                [[pinch view]setTransform:newTransform];
                pinch.view.center = CGPointMake([UIDevice width]/2.0 + [UIDevice width] * pinch.view.tag, [UIDevice height]/2.0);
                lastScale = 1;
                photoScrollView.scrollEnabled = YES;
            }];
        }
        if (lastScale > 1)
        {
            [pinch.view addGestureRecognizer:[guestureArray objectAtIndex:pinch.view.tag]];
        }
        else
        {
            [pinch.view removeGestureRecognizer:[guestureArray objectAtIndex:pinch.view.tag]];
        }
        [UIView animateWithDuration:0.2 animations:^{
            
            pinch.view.center = CGPointMake([UIDevice width] * pinch.view.tag + [UIDevice width]/2.0, [UIDevice height]/2.0);
            
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    if ([pinch scale] < 0.8)
    {
        return;
    }
    CGAffineTransform newTransform = CGAffineTransformScale(_currentTransform, [pinch scale], [pinch scale]);
    [[pinch view]setTransform:newTransform];
    lastScale = [pinch scale];
    
    
}

- (void)panGesture:(UIPanGestureRecognizer*)pan
{
//    CGFloat width = [UIDevice width];
//    CGFloat height = [UIDevice height];
    
    CGFloat newWidth = pan.view.frame.size.width;
    CGFloat newHeight = pan.view.frame.size.height;
    
    CGPoint translation = [pan translationInView:pan.view];
    
    if ([pan state] == UIGestureRecognizerStateEnded)
    {
        if (pan.view.frame.origin.x < width - newWidth + pan.view.tag * [UIDevice width] && translation.x < 0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [pan.view setFrame:CGRectMake(width - newWidth + pan.view.tag * [UIDevice width], pan.view.frame.origin.y, pan.view.frame.size.width, pan.view.frame.size.height)];
            } completion:^(BOOL finished) {
                
                if (changedNo != [imageViewArray count]-1)
                {
                    photoScrollView.scrollEnabled = YES;
                }
            }];
            return;
        }
        if (pan.view.frame.origin.x > 0 + pan.view.tag * [UIDevice width] && translation.x > 0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [pan.view setFrame:CGRectMake(0 + pan.view.tag * [UIDevice width], pan.view.frame.origin.y, pan.view.frame.size.width, pan.view.frame.size.height)];
            } completion:^(BOOL finished) {
                
                if (changedNo != 0)
                {
                    photoScrollView.scrollEnabled = YES;
                }
            }];
            
            return;
        }
        if (pan.view.frame.origin.y < height - newHeight && translation.y < 0)
        {
            [UIView animateWithDuration:0 animations:^{
                [pan.view setFrame:CGRectMake(pan.view.frame.origin.x, height - newHeight, pan.view.frame.size.width, pan.view.frame.size.height)];
            }];
            return;
        }
        if (pan.view.frame.origin.y > 0)
        {
            [UIView animateWithDuration:0 animations:^{
                [pan.view setFrame:CGRectMake(pan.view.frame.origin.x, 0, pan.view.frame.size.width, pan.view.frame.size.height)];
            }];
            return;
        }
        
    }
    if ((pan.view.transform.a == _currentTransform.a))
    {
        return;
    }
    
    if (pan.view.frame.origin.x < width - newWidth + pan.view.tag * [UIDevice width] && translation.x < 0)
    {
        if (changedNo != [imageViewArray count]-1)
        {
            photoScrollView.scrollEnabled = YES;
        }
        return;
    }
    if (pan.view.frame.origin.x > 0 + pan.view.tag * [UIDevice width] && translation.x > 0)
    {
        if (changedNo != 0)
        {
            photoScrollView.scrollEnabled = YES;
        }
        return;
    }
    if (pan.view.frame.origin.y < height - newHeight && translation.y < 0)
    {
        return;
    }
    if (pan.view.frame.origin.y > 0)
    {
        return;
    }
    
    photoScrollView.scrollEnabled = NO;
    pan.view.center = CGPointMake(pan.view.center.x + translation.x,pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIView* view = [imageViewArray objectAtIndex:changedNo];
    [UIView animateKeyframesWithDuration:0.1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        view.center = CGPointMake(width/2.0 + changedNo * width, height/2.0);
        view.transform = _currentTransform;
    } completion:^(BOOL finished) {
        [view removeGestureRecognizer:[guestureArray objectAtIndex:changedNo]];
    }];
}

/*
#pragma mark - 放置图片

- (void)setLessImage
{
    if (_imageArray.count == 1)
    {
        photoScrollView.contentOffset = CGPointMake(0, 0);
        photoScrollView.contentSize = CGSizeMake(width, 0);
        NSDictionary* perviousdict = [_imageArray objectAtIndex:0];
        if ([perviousdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([perviousdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [perviousdict objectForKey:UIImagePickerControllerOriginalImage];
                perviousImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", perviousdict);
            }
        }
    }
    else if (_imageArray.count == 2)
    {
        photoScrollView.contentOffset = CGPointMake(width*_currentIndex, 0);
        photoScrollView.contentSize = CGSizeMake(width*2, 0);
        NSDictionary* perviousdict = [_imageArray objectAtIndex:0];
        if ([perviousdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([perviousdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [perviousdict objectForKey:UIImagePickerControllerOriginalImage];
                perviousImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", perviousdict);
            }
        }
        
        NSDictionary* currentdict = [_imageArray objectAtIndex:1];
        if ([currentdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([currentdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [currentdict objectForKey:UIImagePickerControllerOriginalImage];
                currentImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", currentdict);
            }
        }
    }
    else if (_imageArray.count == 3)
    {
        photoScrollView.contentOffset = CGPointMake(width*_currentIndex, 0);
        photoScrollView.contentSize = CGSizeMake(width*3, 0);
        NSDictionary* perviousdict = [_imageArray objectAtIndex:0];
        if ([perviousdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([perviousdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [perviousdict objectForKey:UIImagePickerControllerOriginalImage];
                perviousImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", perviousdict);
            }
        }
        
        NSDictionary* currentdict = [_imageArray objectAtIndex:1];
        if ([currentdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([currentdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [currentdict objectForKey:UIImagePickerControllerOriginalImage];
                currentImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", currentdict);
            }
        }
        
        NSDictionary* nextdict = [_imageArray objectAtIndex:2];
        if ([nextdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([nextdict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image = [nextdict objectForKey:UIImagePickerControllerOriginalImage];
                nextImageView.image = image;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", nextdict);
            }
        }
    }
}

- (void)setAllImage
{
    if (_currentIndex == 0)
    {
        [self setFirstImage];
    }
    else if (_currentIndex == (_imageArray.count - 1))
    {
        [self setLastImage];
    }
    else
    {
        [self setCurrentImage];
    }
}

- (void)setFirstImage//选择的是第一张图片
{
    NSDictionary* perviousdict = [_imageArray objectAtIndex:_currentIndex];
    if ([perviousdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([perviousdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image = [perviousdict objectForKey:UIImagePickerControllerOriginalImage];
            perviousImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", perviousdict);
        }
    }
    
    
    NSDictionary* currentdict = [_imageArray objectAtIndex:(_currentIndex+1)];
    if ([currentdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([currentdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image = [currentdict objectForKey:UIImagePickerControllerOriginalImage];
            currentImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", currentdict);
        }
    }
    photoScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)setLastImage//选择最后一张图片
{
    NSDictionary* nextdict = [_imageArray objectAtIndex:_currentIndex];
    if ([nextdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([nextdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image=[nextdict objectForKey:UIImagePickerControllerOriginalImage];
            nextImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", nextdict);
        }
    }
    
    NSDictionary* currentdict = [_imageArray objectAtIndex:(_currentIndex - 1)];
    if ([currentdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([currentdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image=[currentdict objectForKey:UIImagePickerControllerOriginalImage];
            currentImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", currentdict);
        }
    }
    photoScrollView.contentOffset = CGPointMake(width*2.0, 0);
    
}

- (void)setCurrentImage
{
    NSDictionary* currentDict = [_imageArray objectAtIndex:_currentIndex];
    if ([currentDict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([currentDict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image = [currentDict objectForKey:UIImagePickerControllerOriginalImage];
            currentImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", currentDict);
        }
    }
    
    NSDictionary* perviousdict = [_imageArray objectAtIndex:(_currentIndex - 1)];
    if ([perviousdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([perviousdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image = [perviousdict objectForKey:UIImagePickerControllerOriginalImage];
            perviousImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", perviousdict);
        }
    }
    
    NSDictionary* nextdict = [_imageArray objectAtIndex:(_currentIndex + 1)];
    if ([nextdict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
        if ([nextdict objectForKey:UIImagePickerControllerOriginalImage])
        {
            UIImage* image = [nextdict objectForKey:UIImagePickerControllerOriginalImage];
            nextImageView.image = image;
        }
        else
        {
            NSLog(@"UIImagePickerControllerReferenceURL = %@", nextdict);
        }
    }
}


#pragma mark - 无限滚动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_imageArray.count > 3)
    {
        CGFloat x = scrollView.contentOffset.x;
        if (x == 0)
        {
            if (_currentIndex >= 1)
            {
                _currentIndex-- ;
            }
            if (_currentIndex > 0 && _currentIndex == _imageArray.count - 2)
            {
                [self setCurrentImage];
            }
            else if (_currentIndex > 0)
            {
                [self setCurrentImage];
                scrollView.contentOffset = CGPointMake(width, 0);
            }
            else
            {
                [self setFirstImage];
            }
        }
        else if (x == width*2.0)
        {
            if (_currentIndex <= _imageArray.count - 2)
            {
                _currentIndex ++ ;
            }
            if (_currentIndex < _imageArray.count - 1 && _currentIndex == 1)
            {
                [self setCurrentImage];
            }
            else if(_currentIndex < _imageArray.count - 1)
            {
                [self setCurrentImage];
                scrollView.contentOffset = CGPointMake(width, 0);
            }
            else
            {
                [self setLastImage];
            }
        }

    }
}

*/



#pragma mark - 显示/隐藏 状态栏、导航栏

- (IBAction)hiddenTap:(id)sender
{
    if (naviBarHidden == NO)
    {
//        photoScrollView.frame = CGRectMake(0, 0, width, height);
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        naviBarHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
//        height = [UIDevice height];
//
//        [UIView animateWithDuration:0.1 animations:^{
//            photoScrollView.frame = CGRectMake(0, 0, width, height);
//        }];
    }
    else
    {
//        photoScrollView.frame = CGRectMake(0, -64, width, height);
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        naviBarHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
//        [UIView animateWithDuration:0.1 animations:^{
//            photoScrollView.frame = CGRectMake(0, -64, width, height);
//        }];

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
//    return NO;
    if (naviBarHidden == YES)
    {
        return YES;
    }
    else
    {
        return NO;
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
