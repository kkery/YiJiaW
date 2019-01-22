//
//  AppDelegate.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "AppDelegate.h"
#import "CODMainTabBarController.h"
#import <EAIntroView/EAIntroView.h>
#import <UMShare/UMShare.h>// 友盟
#import <UMCommon/UMCommon.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate ()<EAIntroDelegate, AMapLocationManagerDelegate>

//@property (nonatomic, strong) CLLocationManager *locationManager;// 定位

@property(nonatomic,strong) AMapLocationManager* locationManager;// 定位


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 启动服务
    [self performSelector:@selector(startService:) withObject:launchOptions afterDelay:0];

    // 设置全局UI
    [[UITextField appearance] setTintColor:CODColorTheme];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:CODColorTheme];//设置UITextView的光标颜色

    // root
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CODMainTabBarController *mainTabBarController = [[CODMainTabBarController alloc] init];
    self.window.rootViewController = mainTabBarController;
    [self.window makeKeyAndVisible];
    
    // 判断QQ、微信设备上是否安装了
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [kUserCenter setObject:@"QQ" forKey:klogin_QQ];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"weixin://"]]) {
        [kUserCenter setObject:@"WeChat" forKey:klogin_WeChat];
    }
    
    // guide
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CODGuideKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CODGuideKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showGuide];
    }
    return YES;
}

#pragma mark - Service
- (void)startService:(NSDictionary *)launchOptions {
    //    NSLog(@"start service begin");
    // 地理位置服务
    [self.locationManager startUpdatingLocation];

    // 友盟推送
    [UMConfigure initWithAppkey:UMAPPKey channel:@"App Store"];
    [[UMSocialManager defaultManager] openLog:YES];

    // qq相关
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:nil redirectURL:nil];
    // 微信相关
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:weChatID appSecret:weChatSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    // 定位城市
    // [self locateCity];
    //  NSLog(@"start service end");
}

#pragma mark - AMapLocationKit
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        [AMapServices sharedServices].apiKey = AMapApiKey;
        _locationManager = [[AMapLocationManager alloc] init];
        //高德地图注册
        _locationManager.delegate = self;
        //设置定位最小更新距离方法如下，单位米
//        _locationManager.distanceFilter ＝ 200;
        [_locationManager setLocatingWithReGeocode:YES];
    }return _locationManager;
}

-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location error = %@", error);
    //定位失败 发送通知
    [kNotiCenter postNotificationName:CODLocationNotificationName object:nil];

}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"高德定位location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode) {
        [kUserCenter setObject:kFORMAT(@"%f",location.coordinate.latitude)  forKey:CODLatitudeKey];
        [kUserCenter setObject:kFORMAT(@"%f",location.coordinate.longitude) forKey:CODLongitudeKey];
        if ([kUserCenter objectForKey:CODCityNameKey] == nil) {
            // 保存定位城市or选择的城市
            [kUserCenter setObject:kFORMAT(@"%@",reGeocode.city) forKey:CODCityNameKey];
        }
        // 保存定位地址（省市区）
        [kUserCenter setObject:kFORMAT(@"%@,%@,%@",reGeocode.province, reGeocode.city, reGeocode.district) forKey:CODLocationAdressKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //定位成功 发送通知
        [kNotiCenter postNotificationName:CODLocationNotificationName object:nil];
        NSLog(@"location address:%@", reGeocode.formattedAddress);
        [self.locationManager stopUpdatingLocation];
    }
}
// 支持所有iOS系统版本回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - Guide
- (void)showGuide {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"app_guide1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"app_guide2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"app_guide3"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds andPages:@[page1,page2,page3]];
    
    UIButton *skipButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:CODColorTheme];
        [button setTitle:@"立即使用" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 44*0.5;
        button.frame = CGRectMake(([UIApplication sharedApplication].keyWindow.bounds.size.width-125)*0.5, [UIApplication sharedApplication].keyWindow.bounds.size.height-75, 125, 44);
        button;
    });
    intro.skipButton = skipButton;
    intro.showSkipButtonOnlyOnLastPage = YES;
    intro.swipeToExit = NO;
    intro.pageControlY = 0;
    intro.tapToNext = YES;
    intro.bgViewContentMode = UIViewContentModeScaleToFill;
    [intro showInView:[UIApplication sharedApplication].keyWindow animateDuration:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
