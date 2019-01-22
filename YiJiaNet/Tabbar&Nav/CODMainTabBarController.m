//
//  CODMainTabBarController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODMainTabBarController.h"
#import "CODMainNavController.h"
#import "CODHomeViewController.h"
#import "CODLoanViewController.h"
#import "CODMineViewController.h"

@interface CODMainTabBarController () <UITabBarControllerDelegate>

@end

@implementation CODMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tabar
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:CODColor333333} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:CODColorTheme} forState:UIControlStateSelected];
    // 配置VC
    [self ConfigureViewController];
    self.delegate = self;
}

- (void)ConfigureViewController {
    // 首页
    CODHomeViewController *homeVC = [[CODHomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"home_tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_tabbar_home_fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeVC.tabBarItem.tag = 0;
    CODMainNavController *homeNavController = [[CODMainNavController alloc] initWithRootViewController:homeVC];
    // 贷款
    CODLoanViewController *loanVC = [[CODLoanViewController alloc] init];
    loanVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"金服" image:[[UIImage imageNamed:@"home_tabbar_loan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_tabbar_fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    loanVC.tabBarItem.tag = 1;
    CODMainNavController *loanNavController = [[CODMainNavController alloc] initWithRootViewController:loanVC];
    // 我的
    CODMineViewController *mineVC = [[CODMineViewController alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"home_tabbar_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_tabbar_my_fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    mineVC.tabBarItem.tag = 2;
    CODMainNavController *mineNavController = [[CODMainNavController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[homeNavController, loanNavController, mineNavController];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"金服"]) {
        [SVProgressHUD cod_showWithInfo:@"金服功能暂未开放，敬请期待..."];
        return NO;
    } else {
        return YES;
    }
}

@end
