//
//  UIViewController+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (COD)
-(void)showAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andCancel:(void(^)(id cancel))canCel Determine:(void(^)(id determine))determine;

-(void)alertVcTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle leftTitleColor:(UIColor*)leftColor leftClick:(void(^)(id leftClick))leftClick rightTitle:(NSString *)rightTitle righttextColor:(UIColor *)rightTextColor andRightClick:(void(^)(id rightClick))rightClick;


-(void)sheetAlertVcNoTitleAndMessage:(UIColor *)bottomColor bottomBlock:(void(^)(id))bottomBlock BottomTitle:(NSString *)bottomTitle TopTitle:(NSString *)TopTitle TopTitleColor:(UIColor *)topTitleColor topBlock:(void(^)(id))topBlock secondTitle:(NSString *)secondTitle secondColor:(UIColor *)secondColor secondBlock:(void(^)(id))secondBlock;
@end
