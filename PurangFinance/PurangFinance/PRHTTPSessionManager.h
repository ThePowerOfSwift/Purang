//
//  PRHTTPSessionManager.h
//  PurangFinance
//
//  Created by liumingkui on 15/5/6.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PRHTTPSessionManager : AFHTTPSessionManager<NSURLConnectionDataDelegate>

+ (PRHTTPSessionManager*)sharePRHTTPSessionManager;

@end
