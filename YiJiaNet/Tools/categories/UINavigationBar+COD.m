//
//  UINavigationBar+COD.m
//  CutOrder
//
//  Created by yhw on 15/4/23.
//  Copyright (c) 2015年 YuQian. All rights reserved.
//

#import "UINavigationBar+COD.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@property (nonatomic, strong) UIView *cod_backgroundView;
@property (nonatomic, strong) UIImage *cod_backgroundImage;
@property (nonatomic, strong) UIImage *cod_shadowImage;

@end

@implementation UINavigationBar (COD)

- (UIView *)cod_backgroundView {
    return objc_getAssociatedObject(self, @selector(cod_backgroundView));
}

- (void)setCod_backgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, @selector(cod_backgroundView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)cod_backgroundImage {
    return objc_getAssociatedObject(self, @selector(cod_backgroundImage));
}

- (void)setCod_backgroundImage:(UIView *)backgroundImage {
    objc_setAssociatedObject(self, @selector(cod_backgroundImage), backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)cod_shadowImage {
    return objc_getAssociatedObject(self, @selector(cod_shadowImage));
}

- (void)setCod_shadowImage:(UIView *)shadowImage {
    objc_setAssociatedObject(self, @selector(cod_shadowImage), shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)cod_backgroundColor {
    return objc_getAssociatedObject(self, @selector(cod_backgroundColor));
}

- (void)setCod_backgroundColor:(UIColor *)cod_backgroundColor {
    objc_setAssociatedObject(self, @selector(cod_backgroundColor), cod_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.cod_backgroundView) {
        self.cod_backgroundImage = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        self.cod_shadowImage = self.shadowImage;
        
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[[UIImage alloc] init]];
        
        self.cod_backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -CODStatusBarHeight, [UIScreen mainScreen].bounds.size.width, CODStatusBarHeight+CODNavigationBarHeight)];
        self.cod_backgroundView.userInteractionEnabled = NO;
        self.cod_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.cod_backgroundView];
        [self sendSubviewToBack:self.cod_backgroundView];
    }
    self.cod_backgroundView.backgroundColor = cod_backgroundColor;
}

- (void)cod_reset {
    [self setBackgroundImage:self.cod_backgroundImage ?: [self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:self.cod_shadowImage ?: self.shadowImage];
    
    [self.cod_backgroundView removeFromSuperview];
    self.cod_backgroundView = nil;
    
    self.cod_backgroundImage = nil;
    self.cod_shadowImage = nil;
}

- (void)cod_setContentAlpha:(CGFloat)alpha {
    if (!self.cod_backgroundView) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.cod_backgroundColor = self.barTintColor;
        }
    }
    [self cod_setContentAlpha:alpha forSubviewsOfView:self];
}

- (void)cod_setContentAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if (subview == self.cod_backgroundView) {
            continue;
        }
        subview.alpha = alpha;
        [self cod_setContentAlpha:alpha forSubviewsOfView:subview];
    }
}

@end
