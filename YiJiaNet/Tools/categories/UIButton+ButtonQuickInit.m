//
//  UIButton+ButtonQuickInit.m
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/4/10.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "UIButton+ButtonQuickInit.h"

@implementation UIButton (ButtonQuickInit)

#pragma mark -基本属性快速初始化
-(void)SetBtnTitle:(NSString *)title andTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc{
        
        if (title!=nil) {
            [self setTitle:title forState:0];
        }
        
        if (font!=nil) {
            self.titleLabel.font = font;
        }
        
        if (tcolor!=nil) {
            [self setTitleColor:tcolor forState:0];
        }
        
        if (bgColor!=nil) {
            [self setBackgroundColor:bgColor];
        }else{
            [self setBackgroundColor:[UIColor clearColor]];
        }
        
        if (Bgimg!=nil) {
            [self setBackgroundImage:Bgimg forState:0];
        }
        
        if (img!=nil) {
            [self setImage:img forState:0];
        }
        
        if (click!=nil) {
            [self addTarget:vc action:click forControlEvents:UIControlEventTouchUpInside];
        }
    
    
}

-(void)SetBtnSelectBgImg:(UIImage *)Selbgimg andSelTitleColor:(UIColor *)SelTlColor andSelImg:(UIImage *)SelImg andSelTitle:(NSString *)SelTle{
    if (Selbgimg!=nil) {
        [self setBackgroundImage:Selbgimg forState:UIControlStateSelected];
    }
    
    if (SelTlColor!=nil) {
        [self setTitleColor:SelTlColor forState:UIControlStateSelected];
    }
    
    if (SelImg!=nil) {
        [self setImage:SelImg forState:UIControlStateSelected];
    }
    
    if (SelTle!=nil) {
        [self setTitle:SelTle forState:UIControlStateSelected];
    }
}

#pragma mark -水平方向文字Aligment
-(void)SetTitleHAligment:(UIControlContentHorizontalAlignment )Haligment andMargin:(UIEdgeInsets )insert{
    
    [self setContentHorizontalAlignment:Haligment];
    self.titleEdgeInsets = insert;
}

#pragma mark -垂直方向文字Aligment
-(void)SetTitleVAligment:(UIControlContentVerticalAlignment )VAligment andMargin:(CGFloat )margin{
    [self setContentVerticalAlignment:VAligment];
    self.titleEdgeInsets = UIEdgeInsetsMake(0,margin, 0, 0);
}

-(void)SetLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerdious;
    self.layer.borderWidth = width;
    if (layerColor) {
        self.layer.borderColor = layerColor.CGColor;    
    }
    
}

/**
-(void)SetButtonContentType:(ButtonContentType )type andMargin:(CGFloat )margin{
    CGFloat imgWidth = self.imageView.bounds.size.width;
    CGFloat labWidth = self.titleLabel.bounds.size.width;
   
    CGFloat imgHeight = self.imageView.bounds.size.height;
    CGFloat labHeight = self.titleLabel.bounds.size.height;
    
    if (type==ImgLeft) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,margin/2)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-margin/2, 0,0)];
    }else if (type==ImgRight){
        
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,imgWidth+labWidth+margin/2, 0,0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0,imgWidth+(margin/2)+labWidth)];
        [self.titleLabel sizeToFit];
    }else if (type==ImgTop){
        
[self setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,-(imgHeight/2)-margin/2)];
[self setTitleEdgeInsets:UIEdgeInsetsMake((labHeight/2)+(margin/2),0, 0,0)];
        
    }else if (type==ImgBottom){
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,(imgHeight/2)+margin/2, 0,0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0,-(labHeight/2)-(margin/2))];
    }
}
*/

-(void)QuickSetBtnRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction andView:(UIButton *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:direction cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
