//
//  CODMainNavController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODMainNavController.h"
#import "UIImage+COD.h"

@interface CODMainNavController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, getter = isDuringPushAnimation) BOOL duringPushAnimation;
@property (weak, nonatomic) id<UINavigationControllerDelegate> realDelegate;

@end

@implementation CODMainNavController

#pragma mark - NSObject
- (void)dealloc
{
    self.delegate = nil;
    self.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:CODColor333333];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:CODColor333333];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 统一设置隐藏导航栏底部分割线隐藏
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    // 导航颜色
//    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [UINavigationBar appearance].tintColor = CODColor333333;
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:CODColor333333};
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage cod_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,XFONT_SIZE(17),NSFontAttributeName, nil]];
//    self.navigationBar.hidden = NO;
    // 隐藏导航栏分隔线
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    if (!self.delegate) {
        self.delegate = self;
    }
    self.interactivePopGestureRecognizer.delegate = self;

}

#pragma mark - UINavigationController
- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    [super setDelegate:delegate ? self : nil];
    self.realDelegate = delegate != self ? delegate : nil;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0)
    {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:YES];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
    self.duringPushAnimation = NO;
    
    if ([self.realDelegate respondsToSelector:_cmd]) {
        [self.realDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        // default value
        return YES;
    }
}

#pragma mark - Delegate Forwarder
- (BOOL)respondsToSelector:(SEL)s
{
    return [super respondsToSelector:s] || [self.realDelegate respondsToSelector:s];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s
{
    return [super methodSignatureForSelector:s] ?: [(id)self.realDelegate methodSignatureForSelector:s];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id delegate = self.realDelegate;
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

@end
