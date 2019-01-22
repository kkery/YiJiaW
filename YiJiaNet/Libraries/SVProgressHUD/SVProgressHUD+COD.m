//
//  SVProgressHUD+COD.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "SVProgressHUD+COD.h"

@implementation SVProgressHUD (COD)
+(void)cod_showWithSuccessInfo:(NSString *)info{
    [SVProgressHUD setStyle];
    [SVProgressHUD cod_dismisWithDelay:1.0];
    [SVProgressHUD showSuccessWithStatus:info];
}

+(void)cod_showWithErrorInfo:(NSString *)info{
    [SVProgressHUD setStyle];
    [SVProgressHUD cod_dismisWithDelay:1.0];
    [SVProgressHUD showErrorWithStatus:info];
}

+(void)cod_showWithInfo:(NSString *)info {
    [SVProgressHUD setStyle];
    [SVProgressHUD cod_dismisWithDelay:1.0];
    [SVProgressHUD showInfoWithStatus:info];
}

//+(void)cod_showWithTips:(NSString *)tips icon:(UIImage *)icon {
//    [SVProgressHUD setBackgroundColor:CODHexaColor(0x000000, 0.5)];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD cod_dismisWithDelay:3.0];
//    [SVProgressHUD showImage:icon status:tips];
//}

+(void)cod_showStatu
{
    [SVProgressHUD setStyle];
    [SVProgressHUD show];
}

+(void)cod_showWithStatu:(NSString *)info{
    [SVProgressHUD setStyle];
    [SVProgressHUD showWithStatus:info];
}

+(void)cod_dismis{
    [SVProgressHUD dismiss];
}

+(void)cod_dismisWithDelay:(NSTimeInterval)timeInterVal{
    [SVProgressHUD dismissWithDelay:timeInterVal];
}

+(void)setStyle{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}
@end
