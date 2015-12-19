//
//  LocationModel.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/22.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "LocationModel.h"
#import <CoreLocation/CoreLocation.h>


@interface LocationModel ()<CLLocationManagerDelegate>

@end

@implementation LocationModel
{
    CLLocationManager* locationManager;
    NSString* cityName;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        locationManager.distanceFilter = 5.0;
        [self getLocation];
    }
    return self;
}


- (void)getLocation
{
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"newLocation : %@",newLocation);
//
//    NSLog(@"floor : %@",newLocation.floor);
    
    if (newLocation != nil)
    {
//        NSString* location = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude];
        [manager stopUpdatingLocation];
    }
    
    //根据经纬度反向地理编译出地址信息
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
//        NSLog(@"placemarks:%@",placemarks);
//        NSLog(@"error:%@",error);
        for (CLPlacemark *placeMark in placemarks)
        {
            
            NSDictionary *addressDic=placeMark.addressDictionary;
//            NSLog(@"%@",addressDic);
//            NSString *state=[addressDic objectForKey:@"State"];
//            NSString *city=[addressDic objectForKey:@"City"];
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];//区
//            NSString *street=[addressDic objectForKey:@"Street"];
            
            cityName = [addressDic objectForKey:@"City"];
            if ([cityName hasPrefix:@"上海"] || [cityName hasPrefix:@"北京"] || [cityName hasPrefix:@"天津"] ||[cityName hasPrefix:@"重庆"])
            {
                NSRange range;
                range.location = 0;
                range.length = 3;
//                NSString
                cityName = [NSString stringWithFormat:@"%@%@", [[addressDic objectForKey:@"City"] substringWithRange:range],[addressDic objectForKey:@"SubLocality"]];
            }
            if (_isShow)
            {
                [_delegate getCityName:cityName];
            }
//            [self stopLocation];
//            [_chooseCityBtn setTitle:city forState:UIControlStateNormal];
//            [_activityIndicator stopAnimating];
        }
        
    }];
    /*
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     
     {
         
         if (array.count > 0)
             
         {
             
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             
             
             //将获得的所有信息显示到label上
             
             NSLog(@"placemark.name%@",placemark.name);
             
             //获取城市
             
             NSString *city = placemark.locality;
             
             if (!city) {
                 
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 
                 city = placemark.administrativeArea;
                 
             }
             NSLog(@"city: %@",city);
             //             self.cityName = city;
             
         }
         
         else if (error == nil && [array count] == 0)
             
         {
             
             NSLog(@"No results were returned.");
             
         }
         
         else if (error != nil)
             
         {
             
             NSLog(@"An error occurred = %@", error);
             
         }
         
     }];
*/
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [manager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

@end
