//
//  UILabel+LabQuickInit.m
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/4/10.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "UILabel+LabQuickInit.h"
#import <UIKit/UIKit.h>

@implementation UILabel (LabQuickInit)

-(void)SetlabTitle:(NSString *)title andFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor{
    if (title!=nil) {
        [self setText:title];
    }
    
    if (font!=nil) {
        self.font = font;
    }
    
    if (titleColor!=nil) {
        self.textColor = titleColor;
    }
    
    if (aligment) {
        self.textAlignment = aligment;
    }
    
    if (bgClor!=nil) {
        self.backgroundColor = bgClor;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    
}

#pragma mark - 富文本
#pragma mark .lab显示图片
-(NSAttributedString *)AddImageToLabWithImg:(UIImage *)img withBaseTitle:(NSString *)title andImgSize:(CGSize )size andImgPlace:(ImagePlace )place andMaxY:(CGFloat )MaxY{
    
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc]init];
    
    // 添加图片
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = img;
    // 设置图片大小
    if (size.width > 0 || size.height > 0) {
        attch.bounds = CGRectMake(0,-MaxY,size.width, size.height);
    }else{
        attch.bounds = CGRectMake(0,-MaxY,img.size.width, img.size.height);
    }
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    if (place == ImagePlaceLeft) {
        [attri appendAttributedString:string];
        if (title) {
            [attri appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        }
    }else{
        if (title) {
            [attri appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        }
        [attri appendAttributedString:string];
    }
    
    [self setAttributedText:attri];
//    NSMutableAttributedString *atstr;
//    [atstr appendAttributedString:<#(nonnull NSAttributedString *)#>]
//    "%@ %@ %@"
    return attri;
}

#pragma mark .设置中划线
-(void)setLabelMiddleLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
         NSStrikethroughStyleAttributeName:lineColor
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:title attributes:attribtDic];
    
    // 赋值
    self.attributedText = attribtStr;
}

#pragma mark .设置下划线
-(void)setLabelUnderLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
         NSUnderlineStyleAttributeName:lineColor
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:title attributes:attribtDic];
    
    // 赋值
    self.attributedText = attribtStr;
}

#pragma mark .设置特殊字体/颜色
-(void)setandChangeTitle:(NSString *)changeTitle ChangeColor:(UIColor *)changeColor andChangeFont:(UIFont *)font andOriginTitle:(NSString *)Origintitle{
    NSRange range;
    range = [Origintitle rangeOfString:changeTitle];
    if (range.location != NSNotFound) {
        NSString *rangeStr = [Origintitle substringFromIndex:range.location];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:Origintitle];
        NSRange noteRnage = NSMakeRange([[noteStr string]rangeOfString:rangeStr].location, [[noteStr string]rangeOfString:rangeStr].length);
        
        if (font!=nil) {
            [noteStr addAttribute:NSFontAttributeName value:font range:noteRnage];
        }
        
        if (changeColor!=nil) {
            [noteStr addAttribute:NSForegroundColorAttributeName value:changeColor range:noteRnage];
        }
        
        [self setAttributedText:noteStr];
    }else{
        NSLog(@"Not Found");
    }
}

#pragma mark .设置段落样式
-(NSMutableAttributedString *)setPargraphStyleWithtext:(NSString *)title andparStyle:(NSMutableParagraphStyle *)style{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:title];
    /**
     @property(readwrite) CGFloat lineSpacing;           //行间距
     @property(readwrite) CGFloat paragraphSpacing;      //段落间距
     @property(readwrite) NSTextAlignment alignment;     //文字对齐格式
     @property(readwrite) CGFloat firstLineHeadIndent;   //首行缩进
     @property(readwrite) CGFloat headIndent;            //行首缩进
     @property(readwrite) CGFloat tailIndent;            //行尾缩进
     @property(readwrite) NSLineBreakMode lineBreakMode; //段落文字溢出隐藏方式
     @property(readwrite) CGFloat minimumLineHeight;     //最小行高
     @property(readwrite) CGFloat maximumLineHeight;     //最大行高
     @property(readwrite) NSWritingDirection baseWritingDirection;//段落书写方向
     @property(readwrite) CGFloat lineHeightMultiple;    //多行行高
     @property(readwrite) CGFloat paragraphSpacingBefore;//段落前间距
     @property(readwrite) float hyphenationFactor;       //英文断字连字符
     */
    
//    
//    NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
//    
//    //style.headIndent = 30; //缩进
//    
//    style.firstLineHeadIndent = firstLineHeadIndent;
//    
//    style.lineSpacing= lineSpace;//行距
//    
//    style.alignment= aligment;
//    
//    style.paragraphSpacing = PargraphSpace;
    
    //需要设置的范围
    
    NSRange range =NSMakeRange(0,title.length);
    [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    return text;
}


#pragma mark .计算段落行高
-(CGFloat)getSpaceLabelHeightwithandparStyle:(NSMutableParagraphStyle *)paraStyle withFont:(UIFont*)font withWidth:(CGFloat)width WithText:(NSString *)title {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    /** 行高 */
//    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f};
    CGSize size = [title boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


-(void)SetLabLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerdious;
    self.layer.borderWidth = width;
    self.layer.borderColor = layerColor.CGColor;
}

-(void)QuickSetLabRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction andView:(UILabel *)view{
//    view.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:direction cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = CODColorTheme.CGColor;
    maskLayer.lineWidth = 1.0f;
//    maskLayer.borderWidth = 1.0f;
//    maskLayer.borderColor = CODColorTheme.CGColor;
    view.layer.mask = maskLayer;
}

@end
