//
//  MBProgressHUD+COD.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "MBProgressHUD+COD.h"

@implementation MBProgressHUD (COD)

+ (void)cod_showSuccessWithTitle:(NSString *)title detail:(NSString *)detail toView:(UIView *)view {
    [MBProgressHUD cod_showSuccessWithTitle:title detail:detail delay:3 toView:view];
}

+ (void)cod_showSuccessWithTitle:(NSString *)title detail:(NSString *)detail delay:(NSTimeInterval)delay toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelFont = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    hud.labelColor = [UIColor whiteColor];
    hud.detailsLabelFont = kFont(12);
    hud.detailsLabelColor = CODHexColor(0xeeeeee);
    hud.opacity = 0.5;
    hud.customView = [[UIImageView alloc] initWithImage:kGetImage(@"feedback_successful")];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    [hud hide:YES afterDelay:delay];
}

@end
