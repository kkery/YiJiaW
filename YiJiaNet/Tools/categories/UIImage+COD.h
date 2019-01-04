//
//  UIImage+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (COD)

+ (UIImage *)cod_imageWithColor:(UIColor *)color;
+ (UIImage *)cod_imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)cod_fixOrientation;
- (UIImage *)cod_imageWithCornerRadius:(CGFloat)cornerRadius;

@end
