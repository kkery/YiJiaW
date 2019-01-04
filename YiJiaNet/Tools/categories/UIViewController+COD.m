//
//  UIViewController+COD.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "UIViewController+COD.h"

@implementation UIViewController (COD)

-(void)showAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andCancel:(void(^)(id cancel))canCel Determine:(void(^)(id determine))determine {
    UIAlertController *alert=[UIAlertController  alertControllerWithTitle:tle message:mesage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *CanCel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        canCel(action);
    }];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        determine(action);
    }];
    
    [CanCel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    [action setValue:CODColorTheme forKey:@"titleTextColor"];
    
    [alert addAction:CanCel];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)alertVcTitle:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle leftTitleColor:(UIColor *)leftColor leftClick:(void (^)(id))leftClick rightTitle:(NSString *)rightTitle righttextColor:(UIColor *)rightTextColor andRightClick:(void (^)(id))rightClick{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftaction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        leftClick(action);
    }];
    
    [leftaction setValue:leftColor forKey:@"titleTextColor"];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        rightClick(action);
        
    }];
    [rightAction setValue:rightTextColor forKey:@"titleTextColor"];
    
    
    [alertVc addAction:leftaction];
    [alertVc addAction:rightAction];
    
    
    [self presentViewController:alertVc animated:YES completion:^{
        
    }];
}

-(void)sheetAlertVcNoTitleAndMessage:(UIColor *)bottomColor bottomBlock:(void(^)(id))bottomBlock BottomTitle:(NSString *)bottomTitle TopTitle:(NSString *)TopTitle TopTitleColor:(UIColor *)topTitleColor topBlock:(void(^)(id))topBlock secondTitle:(NSString *)secondTitle secondColor:(UIColor *)secondColor secondBlock:(void(^)(id))secondBlock{
    
    UIAlertController *sheetAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:bottomTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        bottomBlock(action);
    }];
    [CancelAction setValue:bottomColor forKey:@"titleTextColor"];
    [sheetAlert addAction:CancelAction];
    
    UIAlertAction *topAction = [UIAlertAction actionWithTitle:TopTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        topBlock(action);
    }];
    [topAction setValue:topTitleColor forKey:@"titleTextColor"];
    [sheetAlert addAction:topAction];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        secondBlock(action);
    }];
    [secondAction setValue:secondColor forKey:@"titleTextColor"];
    [sheetAlert addAction:secondAction];
    
    [self presentViewController:sheetAlert animated:YES completion:^{
        
    }];
}

@end
