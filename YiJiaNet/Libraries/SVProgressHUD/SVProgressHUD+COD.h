//
//  SVProgressHUD+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (COD)
+(void)cod_showWithSuccessInfo:(NSString *)info;

+(void)cod_showWithErrorInfo:(NSString *)info;

+(void)cod_showStatu;
+(void)cod_showWithStatu:(NSString *)info;

+(void)cod_dismis;

+(void)cod_dismisWithDelay:(NSTimeInterval)timeInterVal;
@end
