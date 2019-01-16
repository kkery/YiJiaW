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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.font = kFont(16);
    hud.detailsLabel.font = kFont(12);
    hud.bezelView.backgroundColor = CODHexaColor(0x000000, 0.5);
    hud.contentColor = [UIColor whiteColor];
    hud.customView = [[UIImageView alloc] initWithImage:kGetImage(@"feedback_successful")];
    hud.label.text = title;
    hud.detailsLabel.text = detail;
    [hud hideAnimated:YES afterDelay:3];
}
@end
