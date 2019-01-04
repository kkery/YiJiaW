//
//  JXMapNavigationView.m
//  LocationBlock
//
//  Created by Seasaw on 16/1/11.
//  Copyright © 2016年 Seasaw. All rights reserved.
//

#import "JXMapNavigationView.h"
#import "CLLocation+YCLocation.h"
@interface JXMapNavigationView()

@end

@implementation JXMapNavigationView
{
    double _currentLatitude;
    double _currentLongitute;
    double _targetLatitude;
    double _targetLongitute;
    NSString *_name;
    CLLocationManager *_manager;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+(NSArray *)checkHasOwnApp{
    
    
    //检测是否安装了该app时，要往LSApplicationQueriesSchemes中添加白描文件
    //    百度地图：baidumap
    //    高德地图：iosamap
    //    谷歌地图：comgooglemaps
    //    腾讯地图：qqmap
    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://navi",@"baidumap://map/",@"qqmap://"];
    
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果原生地图", nil];
    
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        //检测是否安装了该app
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0) {
                [appListArr addObject:@"google地图"];
            }else if (i == 1){
                [appListArr addObject:@"高德地图"];
            }else if (i == 2){
                [appListArr addObject:@"百度地图"];
            }else if (i == 3){
                [appListArr addObject:@"腾讯地图"];
            }
        }
    }
    
    return appListArr;
}
- (void)showMapNavigationViewFormcurrentLatitude:(double)currentLatitude currentLongitute:(double)currentLongitute TotargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)name{
    
    //高德位置转化火星位置
//    CLLocation *from = [[CLLocation alloc]initWithLatitude:currentLatitude longitude:currentLongitute];
//    CLLocation *fromLoction = [from locationMarsFromEarth];
//    _currentLatitude = fromLoction.coordinate.latitude;
//    _currentLongitute = fromLoction.coordinate.longitude;
    
//    CLLocation *target = [[CLLocation alloc]initWithLatitude:targetLatitude longitude:targetLongitute];
//    CLLocation *targetLoction = [target locationMarsFromEarth];
//    _targetLatitude = targetLoction.coordinate.latitude;
//    _targetLongitute = targetLoction.coordinate.longitude;
    
    _currentLatitude = currentLatitude;
    _currentLongitute = currentLongitute;
    _targetLatitude = targetLatitude;
    _targetLongitute = targetLongitute;
    
    
    _name = name;
    NSArray *appListArr = [JXMapNavigationView checkHasOwnApp];
    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",name];
    
    UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:sheetTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i =0; i<appListArr.count; i++) {
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:appListArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self createBtn:i andArr:appListArr];
        }];
        [alertCon addAction:action1];
    }
    
    UIAlertAction* action6 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertCon addAction:action6];
    [_selfClass presentViewController:alertCon animated:YES completion:nil];

    
}
- (void)remove{
    //移除阴影部分提示页
}
-(void)createBtn:(NSInteger)buttonIndex andArr:(NSArray*) appListArr {
    
    
    NSString *name = _name;
    float ios_version=[[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *btnTitle = appListArr[buttonIndex];
    if (buttonIndex == 0) {
        if (ios_version < 6.0) {//ios6 调用goole网页地图
            NSString *urlString = [[NSString alloc]
                                   initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",
                                   _currentLatitude,_currentLongitute,_targetLatitude,_targetLongitute];
            
            NSURL *aURL = [NSURL URLWithString:urlString];
            //打开网页google地图
            [[UIApplication sharedApplication] openURL:aURL];
        }else{//起点
  
            CLLocationCoordinate2D from = CLLocationCoordinate2DMake(_currentLatitude,_currentLongitute);
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil]];
            currentLocation.name = @"我的位置";
            
            //终点
            CLLocationCoordinate2D to = CLLocationCoordinate2DMake(_targetLatitude,_targetLongitute);
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            NSLog(@"网页google地图:%f,%f",to.latitude,to.longitude);
            toLocation.name = name;
            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
            NSDictionary *options = @{
                                      MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                      MKLaunchOptionsMapTypeKey:
                                          [NSNumber numberWithInteger:MKMapTypeStandard],
                                      MKLaunchOptionsShowsTrafficKey:@YES
                                      };
            
            //打开苹果自身地图应用
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }
    }
    if ([btnTitle isEqualToString:@"google地图"]) {
        
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",_currentLatitude,_currentLongitute,_targetLatitude,_targetLongitute];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if ([btnTitle isEqualToString:@"高德地图"]){
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",_currentLatitude,_currentLongitute,@"我的位置",_targetLatitude,_targetLongitute,_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *r = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:r];
        //        NSLog(@"%@",_lastAddress);
        
    }else if ([btnTitle isEqualToString:@"腾讯地图"]){
        
        NSString *urlStr = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",_currentLatitude,_currentLongitute,_targetLatitude,_targetLongitute];
        NSURL *r = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:r];
        
        
    }else if([btnTitle isEqualToString:@"百度地图"])
    {
        //火星位置转化百度位置
        CLLocation *from = [[CLLocation alloc]initWithLatitude:_currentLatitude longitude:_currentLongitute];
        CLLocation *fromLoction = [from locationBaiduFromMars];
        
        CLLocation *target = [[CLLocation alloc]initWithLatitude:_targetLatitude longitude:_targetLongitute];
        CLLocation *targetLoction = [target locationBaiduFromMars];        
        
        NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving";
        NSString *urlString = [[NSString stringWithFormat:
                                baiduParameterFormat,
                                fromLoction.coordinate.latitude,
                                fromLoction.coordinate.longitude,
                                targetLoction.coordinate.latitude,
                                targetLoction.coordinate.longitude,_name]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    
    }
}
- (void)showMapNavigationViewWithtargetLatitude:(double)targetLatitude targetLongitute:(double)targetLongitute toName:(NSString *)name{
    
    //定位自身位置为起点
    [self startLocation];
    
    _targetLatitude = targetLatitude;
    _targetLongitute = targetLongitute;
    _name = name;
}
//获取经纬度
-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager requestAlwaysAuthorization];
        _manager.distanceFilter=100;
        [_manager startUpdatingLocation];
    }
    else
    {
        UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertCon addAction:action3];
        [_selfClass presentViewController:alertCon animated:YES completion:nil];
    }
    
}
#pragma mark CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取新的位置
    CLLocation * newLocation = locations.lastObject;
    [self showMapNavigationViewFormcurrentLatitude:newLocation.coordinate.latitude currentLongitute:newLocation.coordinate.longitude TotargetLatitude:_targetLatitude targetLongitute:_targetLongitute toName:_name];
    
    
    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
    
}
-(void)stopLocation
{
    _manager = nil;
}
@end
