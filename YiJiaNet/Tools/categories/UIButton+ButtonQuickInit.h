//
//  UIButton+ButtonQuickInit.h
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/4/10.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImgLeft = 0,
    ImgRight,
    ImgTop,
    ImgBottom,
} ButtonContentType;

@interface UIButton (ButtonQuickInit)

/** 设置正常属性 */
-(void)SetBtnTitle:(NSString *)title andTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc;

/** 设置选中属性 */
-(void)SetBtnSelectBgImg:(UIImage *)Selbgimg andSelTitleColor:(UIColor *)SelTlColor andSelImg:(UIImage *)SelImg andSelTitle:(NSString *)SelTle;

/** 设置水平显示属性 */
-(void)SetTitleHAligment:(UIControlContentHorizontalAlignment )Haligment andMargin:(UIEdgeInsets )insert;

/** 设置垂直显示属性 */
-(void)SetTitleVAligment:(UIControlContentVerticalAlignment )VAligment andMargin:(CGFloat )margin;

/** 设置边框圆角 */
-(void)SetLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor;

/** 指定方向圆角 */
-(void)QuickSetBtnRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction andView:(UIButton *)view;

@end
