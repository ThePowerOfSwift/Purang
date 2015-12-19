//
//  FileManager.m
//  格桑梅朵
//
//  Created by liumingkui on 14-10-22.
//  Copyright (c) 2014年 purang756. All rights reserved.
//

#import "PRFileManager.h"

static PRFileManager* fileManager;

static NSString* userInformationFilepath;

@implementation PRFileManager

+ (PRFileManager *)sharePRFileManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        fileManager = [[PRFileManager alloc]init];
        NSArray* fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString* documentDirectory = [fileArray objectAtIndex:0];
        [fileManager createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        userInformationFilepath = [documentDirectory stringByAppendingPathComponent:@"userInformation"];
        
    });
    return fileManager;
}

- (BOOL)checkUserInformationFileExist
{
    return [fileManager fileExistsAtPath:userInformationFilepath];
}

- (void)creatFileUserInformationFile
{
    if (![self checkUserInformationFileExist])
    {
        [fileManager createFileAtPath:userInformationFilepath contents:nil attributes:nil];
    }
}

- (NSMutableDictionary*)readUserInformationFile
{
    return (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithFile:userInformationFilepath];
}

- (void)writeUserInformationTofileWithUserInformation:(NSMutableDictionary*)userInformation
{
    if (![self checkUserInformationFileExist])
    {
        [self creatFileUserInformationFile];
        [NSKeyedArchiver archiveRootObject:userInformation toFile:userInformationFilepath];
    }
    else
    {
        NSMutableDictionary* dictionary = [self readUserInformationFile];
        NSArray* array = [userInformation allKeys];
        for (NSString* key in array)
        {
            [dictionary setObject:[userInformation valueForKey:key] forKey:key];
        }
        [NSKeyedArchiver archiveRootObject:dictionary toFile:userInformationFilepath];
    }
}

- (void)removeUserInformationFile
{
    if ([self checkUserInformationFileExist])
    {
        [fileManager removeItemAtPath:userInformationFilepath error:nil];
    }
}

@end
