//
//  UIView+UIMethod.h
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/11/8.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIMethod)

-(void)quickSetViewRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction;

+(UIView *)getAViewWithFrame:(CGRect )frame andBgColor:(UIColor *)color;

/** 控件的圆角和边框 */
-(void)setLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor;

/** 调起键盘，并在顶端加个按钮 */
+(UIView *)addToolSenderWithTarget:(id)target Action:(SEL)sel;

/**
 获取单个按钮尾视图（多用于UITableView的尾视图上的按钮）
 
 @param btnBgColor 按钮背景色
 @param tleColor 按钮字体颜色
 @param height 尾视图高度
 @param target 按钮事件监听
 @param action 按钮点击事件
 @param btnTitle 按钮文本
 @return 尾视图
 */
+(UIView *)singleButtonFootVW:(UIColor *)btnBgColor
                   titleColor:(UIColor *)tleColor
                       height:(CGFloat)height
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)btnTitle;

@end

@interface UIView (TWHFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

- (UIViewController *)parentController;

@end

@interface UIButton (ButtonUIMethod)

/** 设置常规属性 */
-(void) SetBtnTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc andTitle:(NSString *)title;

/** 快速获取一个初始化并配置好属性的button */
+(UIButton *)GetBtnWithTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc andTitle:(NSString *)title;

/** 设置选中属性 */
-(void)SetBtnSelectBgImg:(UIImage *)Selbgimg andSelTitleColor:(UIColor *)SelTlColor andSelImg:(UIImage *)SelImg andSelTitle:(NSString *)SelTle;

/** 设置水平显示属性 */
-(void)SetTitleHAligment:(UIControlContentHorizontalAlignment )Haligment andMargin:(UIEdgeInsets )insert;

/** 设置垂直显示属性 */
-(void)SetTitleVAligment:(UIControlContentVerticalAlignment )VAligment andMargin:(CGFloat )margin;

/*
 *    倒计时按钮
 *    @param timeLine  倒计时总时间
 *    @param title     还没倒计时的title
 *    @param subTitle  倒计时的子名字 如：时、分
 *    @param mColor    还没倒计时的颜色
 *    @param color     倒计时的颜色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

@end

@interface UIImageView (ImgVWUIMethod)

+(UIImageView *)getImageViewWithFrame:(CGRect )frame andImage:(UIImage *)img andBgColor:(UIColor *)color;

+(UIImage *)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

@end

@interface UILabel (UILabUIMethod)

-(void)SetLabFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor andlabTitle:(NSString *)title;

/** 快速获取一个初始化并配置好属性的lab */
+(UILabel *)GetLabWithFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor andlabTitle:(NSString *)title;

/** 设置中划线 */
-(void)setLabelMiddleLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor;

/** 设置下划线 */
-(void)setLabelUnderLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor;

-(CGFloat)getSpaceLabelHeightWithparStyle:(NSMutableParagraphStyle *)paraStyle withFont:(UIFont*)font withWidth:(CGFloat)width WithText:(NSString *)title;

@end


@interface UITextField (TextFiledMethod)
/** 快速生成tf */
+(UITextField *)getTextfiledWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andFont:(UIFont *)font andTextAlignment:(NSTextAlignment )aligment andPlaceHold:(NSString *)hold;

/** 设置tf基本属性 */
-(void)SetTfTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andFont:(UIFont *)font andTextAlignment:(NSTextAlignment )aligment andPlaceHold:(NSString *)hold;

/** 限制输入框输入字数 */
-(void)limitTextLength:(NSInteger)length;

/** 修改placehold的字体和颜色 */
-(void)modifyPlaceholdFont:(UIFont *)font andColor:(UIColor *)color;

/** 设置左视图 */
-(void)quickSetLeftViewWithImg:(UIImage *)img andSize:(CGSize )size andLeftVWSize:(CGSize )lvSize;

/** 验证金额输入框输入有效性 */
- (BOOL)isRightInPutOfString:(NSString *) string withInputString:(NSString *) inputString range:(NSRange) range;

@end


@interface UISearchBar (TWHLeftPlaceHold)

-(void)changeLeftPlaceholder:(NSString *)placeholder;

@end


@interface UITableView (TableQuickInit)

+(UITableView *)GetTableWithFrame:(CGRect )rect andVC:(id )vc andBgColor:(UIColor *)bgColor andStyle:(UITableViewStyle )style andHeadVW:(UIView *)hv andFootVW:(UIView *)fv andWhetherNeedSepLine:(BOOL )sepLine andSepLineColor:(UIColor *)sepColor;



@end


@interface UICollectionView(CollectInit)

/** 快速获取flowlayout */
+(UICollectionViewFlowLayout *)getCollectFlowLayoutWithMinLineSpace:(CGFloat )linespace
                         andMinInteritemSpacing:(CGFloat )Interitemspace
                         andItemSize:(CGSize )size
                         andSectionInsert:(UIEdgeInsets )inserts
                         andscrollDirection:(UICollectionViewScrollDirection )direction;

/** 快速获取collectionview */
+(UICollectionView *)getCollectionviewWithFrame:(CGRect )rect
                     andVC:(id)vc
                     andBgColor:(UIColor *)bgColor
                     andFlowLayout:(UICollectionViewFlowLayout *)fl
                     andItemClass:(Class )cls
                     andReuseID:(NSString *)identifier;

@end


@interface UIBarButtonItem (BarButtonItemMethod)
+(instancetype )itemWithImage:(UIImage *)image Title:(NSString *)tle TitleColor:(UIColor *)color Font:(UIFont *)font Target:(id)target Action:(SEL)action;

+(instancetype)iTemWithImage:(UIImage *)image SelectImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+(instancetype)itmWithTitle:(NSString *)title SelectTitle:(NSString *)selectedTitle Font:(UIFont *)font textColor:(UIColor *)textcolor  selectedTextColor:(UIColor *)selctedColor target:(id)target action:(SEL)action;

@end

