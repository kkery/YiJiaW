//
//  MBProgressHUD+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (COD)

+ (void)cod_showSuccessWithTitle:(NSString *)title detail:(NSString *)detail toView:(UIView *)view;

+ (void)cod_showSuccessWithTitle:(NSString *)title detail:(NSString *)detail delay:(NSTimeInterval)delay toView:(UIView *)view;

@end
