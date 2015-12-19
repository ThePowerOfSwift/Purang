//
//  CityTableViewController.m
//  PurangFinance
//
//  Created by liumingkui on 15/4/21.
//  Copyright (c) 2015年 ___PURANG___. All rights reserved.
//

#import "CityTableViewController.h"
#import "LocationModel.h"
//#import "DiscountViewController.h"
//#import "PersnoalCenterViewController.h"
#import "PRCityTableViewCell.h"

@interface CityTableViewController ()<LocationModelDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation CityTableViewController
{
    LocationModel* locationModel;
    NSString* _cityName;
    NSMutableArray* resultArray;
    BOOL isSearch;
    NSDictionary* originDictionary;
    BOOL isShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayHotCity = [NSMutableArray arrayWithObjects:@{
        @"code": @"440100",
        @"name": @"广州",
        @"fullname": @"广州市",
        @"quanpin": @"guangzhoushi",
        @"pinyin": @"GZS"
        },@{
            @"code": @"110000",
            @"name": @"北京",
            @"fullname": @"北京市",
            @"quanpin": @"beijingshi",
            @"pinyin": @"BJS"
            },@{
                @"code": @"120000",
                @"name": @"天津",
                @"fullname": @"天津市",
                @"quanpin": @"tianjinshi",
                @"pinyin": @"TJS"
                }, nil];
    self.keys = [NSMutableArray array];
    self.arrayCitys = [NSMutableArray array];
    
    
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (locationModel == nil)
    {
        locationModel = [LocationModel new];
    }
    locationModel.delegate = self;
    locationModel.isShow = YES;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSString *str = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    originDictionary = (NSDictionary*)json;
    
    self.cities = [[NSMutableDictionary alloc]initWithDictionary:originDictionary];
    [self getCityData];

    self.searchBar.delegate = self;

    
    //搜索
    resultArray = [NSMutableArray new];
    isSearch = NO;

//
}


#pragma mark - LocationModelDelegate

- (void)getCityName:(NSString *)cityName
{
    _cityName = cityName;
    if (self.tableView)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - 获取城市数据

-(void)getCityData
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict"
//                                                   ofType:@"plist"];
//    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.keys insertObject:@"" atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch == NO)
    {
        return [_keys count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch == NO)
    {
        if (section == 0)
        {
            return 1;
        }
        NSString *key = [_keys objectAtIndex:section];
        NSArray *citySection = [_cities objectForKey:key];
        return [citySection count];
    }
    else
    {
        return resultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PRCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PRCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    if (isSearch == NO)
    {
        if ([indexPath section] == 0)
        {
            if (_cityName != nil)
            {
                cell.textLabel.text = _cityName;
                for (NSArray* typeArray in [originDictionary allValues])
                {
                    for (NSDictionary* dict in typeArray)//A
                    {
                        if ([[dict valueForKey:@"fullname"] rangeOfString:_cityName].location == 0)
                        {
                            cell.cityInfomation = dict;
                            break;
                        }
                    }
                }

            }
            else
            {
                cell.textLabel.text = @"GPS定位";
            }
        }
        else
        {
            //        NSLog(@"index section:%ld,index row:%ld",indexPath.section,indexPath.row);
            NSString *key = [_keys objectAtIndex:indexPath.section];
            //        NSLog(@"key:%@",key);
            cell.textLabel.text = [[[_cities valueForKey:key] objectAtIndex:indexPath.row] valueForKey:@"fullname"];
            cell.cityInfomation = [[_cities valueForKey:key] objectAtIndex:indexPath.row];
        }
    }
    else
    {
        cell.textLabel.text = [[resultArray objectAtIndex:[indexPath row]]valueForKey:@"fullname"];
        cell.cityInfomation = [resultArray objectAtIndex:[indexPath row]];
    }
    
    
    return cell;
}


#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.5;
    }
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热"].location != NSNotFound)
    {
        titleLabel.text = @"热门城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",[self.cities allKeys]);
    [self.view endEditing:YES];
    __weak PRCityTableViewCell* cell = (PRCityTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@",cell.cityInfomation);
//    NSString* str = cell.textLabel.text;
//    NSLog(@"str:%@",str);
    [_delegate getCityWithCityName:cell.textLabel.text];
    [_delegate getCityCode:[cell.cityInfomation valueForKey:@"code"]];
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [resultArray removeAllObjects];
    if ([searchText isEqualToString:@""])
    {
        isSearch = NO;
    }
    else
    {
        isSearch = YES;
        for (NSArray* typeArray in [originDictionary allValues])
        {
            for (NSDictionary* dict in typeArray)//A
            {
                if ([[[dict valueForKey:@"pinyin"] lowercaseString] rangeOfString:[searchText lowercaseString]].location == 0)
                {
                    [resultArray addObject:dict];
                    continue;
                }
                
                if ([[[dict valueForKey:@"quanpin"] lowercaseString] rangeOfString:[searchText lowercaseString]].location == 0)
                {
                    [resultArray addObject:dict];
                    continue;
                }
                
                if ([[dict valueForKey:@"fullname"] rangeOfString:[searchText lowercaseString]].location == 0)
                {
                    [resultArray addObject:dict];
                    continue;
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (locationModel == nil)
    {
        locationModel = [LocationModel new];
    }
    locationModel.isShow = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    locationModel.isShow = NO;
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
