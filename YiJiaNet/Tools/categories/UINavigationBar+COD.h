//
//  UINavigationBar+COD.h
//  CutOrder
//
//  Created by yhw on 15/4/23.
//  Copyright (c) 2015年 YuQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (COD)

@property (nonatomic, strong) UIColor *cod_backgroundColor;// 导航背景颜色

- (void)cod_setContentAlpha:(CGFloat)alpha;// 内容透明度
- (void)cod_reset;// 重置

@end
