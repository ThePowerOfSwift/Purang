//
//  PRFileManager
//  格桑梅朵
//
//  Created by liumingkui on 14-10-22.
//  Copyright (c) 2014年 purang756. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRFileManager : NSFileManager

- (BOOL)checkUserInformationFileExist;
- (void)creatFileUserInformationFile;
- (NSMutableDictionary*)readUserInformationFile;
- (void)writeUserInformationTofileWithUserInformation:(NSMutableDictionary*)userInformation;
- (void)removeUserInformationFile;
+ (PRFileManager*)sharePRFileManager;

@end
