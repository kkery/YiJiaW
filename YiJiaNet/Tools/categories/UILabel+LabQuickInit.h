//
//  UILabel+LabQuickInit.h
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/4/10.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImagePlaceLeft = 0,
    ImagePlaceRight,
} ImagePlace;

@interface UILabel (LabQuickInit)

-(void)SetlabTitle:(NSString *)title andFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor;


-(NSAttributedString *)AddImageToLabWithImg:(UIImage *)img withBaseTitle:(NSString *)title andImgSize:(CGSize )size andImgPlace:(ImagePlace )place andMaxY:(CGFloat )MaxY;


-(void)setLabelMiddleLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor;

-(void)setLabelUnderLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor;


-(void)setandChangeTitle:(NSString *)changeTitle ChangeColor:(UIColor *)changeColor andChangeFont:(UIFont *)font andOriginTitle:(NSString *)Origintitle;

-(NSMutableAttributedString *)setPargraphStyleWithtext:(NSString *)title andparStyle:(NSMutableParagraphStyle *)style;


-(CGFloat)getSpaceLabelHeightwithandparStyle:(NSMutableParagraphStyle *)paraStyle withFont:(UIFont*)font withWidth:(CGFloat)width WithText:(NSString *)title ;

-(void)SetLabLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor;


/** 指定方向圆角 */
-(void)QuickSetLabRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction andView:(UILabel *)view;

@end
