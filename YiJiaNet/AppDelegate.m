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
@interface AppDelegate ()<EAIntroDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UMConfigure initWithAppkey:UMAPPKey channel:@"App Store"];

    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:nil redirectURL:nil];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:weChatID appSecret:weChatSecret redirectURL:@"http://mobile.umeng.com/social"];

    // 判断QQ、微信设备上是否安装
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [kUserCenter setObject:@"QQ" forKey:klogin_QQ];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"weixin://"]]) {
        [kUserCenter setObject:@"WeChat" forKey:klogin_WeChat];
    }
    // 设置全局UI
    [[UITextField appearance] setTintColor:CODColorTheme];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:CODColorTheme];//设置UITextView的光标颜色
    // root
    CODMainTabBarController *mainTabBarController = [[CODMainTabBarController alloc] init];
    self.window.rootViewController = mainTabBarController;
    [self.window makeKeyAndVisible];
    // statusBar、NavigationBar
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage cod_imageWithColor:CODColorRed] forBarMetrics:UIBarMetricsDefault];
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
        [button setTitleColor:CODColorButtonNormal forState:UIControlStateNormal];
        [button setTitleColor:CODColorButtonHighlighted forState:UIControlStateHighlighted];
        [button setTitle:@"立即体验" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.borderColor = CODColorButtonNormal.CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 40*0.5;
        button.frame = CGRectMake(([UIApplication sharedApplication].keyWindow.bounds.size.width-220)*0.5, [UIApplication sharedApplication].keyWindow.bounds.size.height-75, 220, 40);
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
