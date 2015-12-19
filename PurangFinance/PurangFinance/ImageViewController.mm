//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "UIImage+FixOrientation.h"
#import <TesseractOCR/TesseractOCR.h>
#import <opencv2/opencv.hpp>
#include "opencv2/core/core_c.h"
#import "UIDevice+UIDeviceCategory.h"
#import "NoticeViewController.h"
#import "HomeViewController.h"

#import "baseapi.h"
#import "environ.h"
#import "pix.h"
#import "ocrclass.h"
#import "allheaders.h"
#import "genericvector.h"
#import "strngs.h"

namespace tesseract
{
    class TessBaseAPI;
};

@interface ImageViewController ()
{
    tesseract::TessBaseAPI *_tesseract;
}
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (copy, nonatomic) NSString* recognizedText;
//@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        
       
        
        //===========================================================================
//        //图片旋转矫正
//        UIImage* img =  [image fixOrientation];
//        IplImage* srcImage = [self CreateIplImageFromUIImage:img];
//        int width = srcImage->width;
//        int height = srcImage->height;
//        printf("图片大小%d,%d\n",width,height);
//        // 分割矩形区域
//            int x = width/8;
//            int y = height/3;
//            int w = width-width/4;
//            int h = height/3;
//       printf("图片大小%d,%d\n",w,h);
//        cvSetImageROI(srcImage, cvRect(x,y ,w ,h));
//        IplImage* dstImage = cvCreateImage(cvSize(w, h), srcImage->depth, srcImage->nChannels);
//        cvCopy(srcImage, dstImage,0);
//        cvResetImageROI(srcImage);
////        self.image = [self UIImageFromIplImage:dstImage];
//        
//        cvSmooth(dstImage, dstImage,CV_MEDIAN,7,7,0,0);
//        cv::Mat matGrey2 = [self cvMatFromUIImage:[self UIImageFromIplImage:dstImage]];
//        cv::cvtColor(matGrey2, matGrey2, CV_BGR2GRAY);
////        cv::equalizeHist(matGrey2, matGrey2);
////         self.image = [self UIImageFromCVMat:matGrey2];
//        IplImage grey = matGrey2;
//        unsigned char* dataImage = (unsigned char*)grey.imageData;
//        int threshold = Otsu(dataImage, grey.width, grey.height);
//        
//        NSLog(@"%d",threshold);
//        
//        //生成二值化
//        cv::threshold(matGrey2, matGrey2, threshold-20, 255, cv::THRESH_BINARY);
//         self.image = [self UIImageFromCVMat:matGrey2];
//        IplImage* srcImag = [self CreateIplImageFromUIImage:[self UIImageFromCVMat:matGrey2]];
//        
//        IplImage* srcImag2 = cvCreateImage(cvSize(w, h), srcImag->depth, srcImag->nChannels);
////         cvZero(srcImag2);
//        cvThin(srcImag, srcImag2,8);
////        CvSize size = cvGetSize(srcImag2);
////        int i,j;
////        for(i=0; i<size.height;  i++)
////        {
////            for(j=0; j<size.width; j++)
////            {
////                if(CV_IMAGE_ELEM(srcImag2,uchar,i,j)==1)
////                {
////                    CV_IMAGE_ELEM(srcImag2,uchar,i,j) = 0;
////                }
////                else  
////                {  
////                    CV_IMAGE_ELEM(srcImag2,uchar,i,j) = 255;
////                }  
////            }  
////        }
//         self.dstimage = [self UIImageFromIplImage:srcImag2];
//        //膨胀操作 字体变小 输入，输出，默认null，迭代）
//        cvDilate(srcImag, srcImag,NULL,3);
//        //腐蚀操作 字体变大（输入，输出，默认null，迭代）
//        cvErode(srcImag, srcImag,NULL,2);
////       self.image = [self UIImageFromIplImage:srcImag];
//        cvReleaseImage(&srcImag);
//        cvReleaseImage(&srcImage);
//        cvReleaseImage(&dstImage);
//        matGrey2.release();
        //===========================================================================

        //图片旋转矫正
        UIImage* img =  [image fixOrientation];
        IplImage* srcImage = [self CreateIplImageFromUIImage:img];
        int width = srcImage->width;
        int height = srcImage->height;
        printf("图片大小%d,%d\n",width,height);
        // 分割矩形区域
        int x = width/8;
        int y = height/3;
        int w = width-width/4;
        int h = height/3;
        printf("图片大小%d,%d\n",w,h);
        cvSetImageROI(srcImage, cvRect(x,y ,w ,h));
        IplImage* dstImage = cvCreateImage(cvSize(w, h), srcImage->depth, srcImage->nChannels);
        cvCopy(srcImage, dstImage,0);
        cvResetImageROI(srcImage);
        self.image = [self UIImageFromIplImage:dstImage];
        
        
        //otsu算法算出阈值
        cv::Mat matGrey2 = [self cvMatFromUIImage:[self UIImageFromIplImage:dstImage]];
        cv::cvtColor(matGrey2, matGrey2, CV_BGR2GRAY);
        IplImage grey = matGrey2;
        unsigned char* dataImage = (unsigned char*)grey.imageData;
        int threshold = Otsu(dataImage, grey.width, grey.height);
        NSLog(@"%d",threshold);
        
        //生成二值化
        cv::threshold(matGrey2, matGrey2, threshold-20, 255, cv::THRESH_OTSU);
        self.image = [self UIImageFromCVMat:matGrey2];
        IplImage* srcImag = [self CreateIplImageFromUIImage:[self UIImageFromCVMat:matGrey2]];
        //中值滤波去噪
        cvSmooth(srcImag, srcImag,CV_MEDIAN,7,7,0,0);
        
        //         self.image = [self UIImageFromIplImage:srcImag];
        // self.src2.image = [self UIImageFromIplImage:srcImag];
        //膨胀操作 字体变小 输入，输出，默认null，迭代）
        cvDilate(srcImag, srcImag,NULL,3);
        
        //腐蚀操作 字体变大（输入，输出，默认null，迭代）
        cvErode(srcImag, srcImag,NULL,2);
        self.image = [self UIImageFromIplImage:srcImag];
        cvReleaseImage(&srcImag);
        cvReleaseImage(&srcImage);
        cvReleaseImage(&dstImage);
        matGrey2.release();
        
      
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.operationQueue = [[NSOperationQueue alloc] init];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"%f,%f",[UIDevice width],[UIDevice height]);
    if (self.imageView != NULL) {
        NSLog(@"111");
    }
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIDevice width]/8, [UIDevice height]/3, [UIDevice width]- [UIDevice width]/4 , [UIDevice height]/3)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.infoLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = info;
    [self.view addSubview:self.infoLabel];
    
    
    Pix *pix = nullptr;
    pix = [self pixForImage:self.image];
    _tesseract = new tesseract::TessBaseAPI();
    //获取字体库路径
    NSMutableString* absoluteDataPath = [[NSMutableString alloc] init];
    absoluteDataPath = [NSMutableString stringWithFormat:@"%@", [NSString stringWithString:[NSBundle mainBundle].bundlePath]];
    setenv("TESSDATA_PREFIX", [absoluteDataPath stringByAppendingString:@"/"].UTF8String, 1);
    
    _tesseract->Init(absoluteDataPath.UTF8String, "eng", tesseract::OEM_TESSERACT_ONLY);
    _tesseract->SetImage(pix);
    pixDestroy(&pix);
    _tesseract->SetVariable("tessedit_char_whitelist", "0123456789");
    NSString* text = [NSString stringWithUTF8String:_tesseract->GetUTF8Text()];
    NSLog(@"%@",text);
    
    _recognizedText = [text stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [text length])];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    _tesseract->Clear();
    delete _tesseract;

    [[NoticeViewController shareNoticeViewController] BankDraftTextField:_recognizedText];
    [[HomeViewController shareHomeViewController] popToNoticeViewController];
    
//    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
//    
//    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
//    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
//    operation.tesseract.image = self.image;
//    
//    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
//        // Fetch the recognized text
//        NSString *recognizedText = tesseract.recognizedText;
//        
//        NSLog(@"%@", recognizedText);
//        
//        // Remove the animated progress activity indicator
//        
//        
//        // Spawn an alert with the recognized text
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
//                                                        message:recognizedText
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    };
//
//    [self.operationQueue addOperation:operation];
    
//    G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
//    tesseract.engineMode = G8OCREngineModeTesseractOnly;
//    tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
//    tesseract.image = self.image;
//    tesseract.maximumRecognitionTime = 30;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
//                                                    message:tesseract.recognizedText
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    _recognizedText = tesseract.recognizedText;
//    NSLog(@"%@",tesseract.recognizedText);
//
//    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}




- (Pix *)pixForImage:(UIImage *)image
{
    int width = image.size.width;
    int height = image.size.height;
    
    CGImage *cgImage = image.CGImage;
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    
    int bpp = MAX(1, (int)bitsPerPixel);
    Pix *pix = pixCreate(width, height, bpp == 24 ? 32 : bpp);
    l_uint32 *data = pixGetData(pix);
    int wpl = pixGetWpl(pix);
    switch (bpp) {
        case 1:
            for (int y = 0; y < height; ++y, data += wpl, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x) {
                    if (pixels[x / 8] & (0x80 >> (x % 8))) {
                        CLEAR_DATA_BIT(data, x);
                    }
                    else {
                        SET_DATA_BIT(data, x);
                    }
                }
            }
            break;
            
        case 8:
            // Greyscale just copies the bytes in the right order.
            for (int y = 0; y < height; ++y, data += wpl, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x) {
                    SET_DATA_BYTE(data, x, pixels[x]);
                }
            }
            break;
            
        case 24:
            // Put the colors in the correct places in the line buffer.
            for (int y = 0; y < height; ++y, pixels += bytesPerRow) {
                for (int x = 0; x < width; ++x, ++data) {
                    SET_DATA_BYTE(data, COLOR_RED, pixels[3 * x]);
                    SET_DATA_BYTE(data, COLOR_GREEN, pixels[3 * x + 1]);
                    SET_DATA_BYTE(data, COLOR_BLUE, pixels[3 * x + 2]);
                }
            }
            break;
            
        case 32:
            // Maintain byte order consistency across different endianness.
            for (int y = 0; y < height; ++y, pixels += bytesPerRow, data += wpl) {
                for (int x = 0; x < width; ++x) {
                    data[x] = (pixels[x * 4] << 24) | (pixels[x * 4 + 1] << 16) |
                    (pixels[x * 4 + 2] << 8) | pixels[x * 4 + 3];
                }
            }
            break;
            
        default:
            NSLog(@"Cannot convert image to Pix with bpp = %d", bpp);
    }
    pixSetYRes(pix, (l_int32)72);
    
    CFRelease(imageData);
    
    return pix;
}


- (void)viewTapped:(UIGestureRecognizer *)gesture
{
    //释放内存释放tesseract对象
    _tesseract->Clear();
    delete _tesseract;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popToViewController:[NoticeViewController shareNoticeViewController] animated:NO];
    [[NoticeViewController shareNoticeViewController] BankDraftTextField:_recognizedText];
    
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}


#pragma mark - custom method

// OSTU算法求出阈值
int  Otsu(unsigned char* pGrayImg , int iWidth , int iHeight)
{
    if((pGrayImg==0)||(iWidth<=0)||(iHeight<=0))return -1;
    int ihist[256];
    int thresholdValue=0; // „–÷µ
    int n, n1, n2 ;
    double m1, m2, sum, csum, fmax, sb;
    int i,j,k;
    memset(ihist, 0, sizeof(ihist));
    n=iHeight*iWidth;
    sum = csum = 0.0;
    fmax = -1.0;
    n1 = 0;
    for(i=0; i < iHeight; i++)
    {
        for(j=0; j < iWidth; j++)
        {
            ihist[*pGrayImg]++;
            pGrayImg++;
        }
    }
    pGrayImg -= n;
    for (k=0; k <= 255; k++)
    {
        sum += (double) k * (double) ihist[k];
    }
    for (k=0; k <=255; k++)
    {
        n1 += ihist[k];
        if(n1==0)continue;
        n2 = n - n1;
        if(n2==0)break;
        csum += (double)k *ihist[k];
        m1 = csum/n1;
        m2 = (sum-csum)/n2;
        sb = (double) n1 *(double) n2 *(m1 - m2) * (m1 - m2);
        if (sb > fmax)
        {
            fmax = sb;
            thresholdValue = k;
        }
    }
    return(thresholdValue);
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.imageView.frame = self.view.contentBounds;
    
    [self.infoLabel sizeToFit];
    self.infoLabel.width = self.view.contentBounds.size.width;
    self.infoLabel.top = 0;
    self.infoLabel.left = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
