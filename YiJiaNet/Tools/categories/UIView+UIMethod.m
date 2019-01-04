//
//  UIView+UIMethod.m
//  TwhCategoryMethod
//
//  Created by 汤文洪 on 2017/11/8.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "UIView+UIMethod.h"
#import "TWHImgTitleBtn.h"

#pragma mark - UIView
@implementation UIView (UIMethod)

-(void)quickSetViewRoundCornWithCorneradius:(CGFloat )radius andDerection:(UIRectCorner )direction
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:direction cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

+(UIView *)getAViewWithFrame:(CGRect )frame andBgColor:(UIColor *)color{
    UIView *vw = [[UIView alloc]initWithFrame:frame];
    if (color) {
        [vw setBackgroundColor:color];
    }
    return vw;
}

-(void)setLayWithCor:(CGFloat )cornerdious andLayerWidth:(CGFloat )width andLayerColor:(UIColor *)layerColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerdious;
    if (layerColor) {
     self.layer.borderColor = layerColor.CGColor;
    self.layer.borderWidth = width;
    }
}

+(UIView *)addToolSenderWithTarget:(id)target Action:(SEL)sel{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    return topView;
}

+(UIView *)singleButtonFootVW:(UIColor *)btnBgColor
                   titleColor:(UIColor *)tleColor
                       height:(CGFloat)height
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)btnTitle{
    
    UIView *footVW = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, CGRectGetMidY(footVW.frame)-20, CGRectGetWidth(footVW.frame)-30, 40)];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0;
    [btn setTag:2003];
    
    if (btnBgColor) {
        [btn setBackgroundColor:btnBgColor];
    }
    
    if (tleColor) {
        [btn setTitleColor:tleColor forState:UIControlStateNormal];
    }
    
    if (btnTitle) {
        [btn setTitle:btnTitle forState:UIControlStateNormal];
    }
    
    if (action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    [footVW addSubview:btn];
    
    return footVW;
}

@end


@implementation UIView (TWHFrame)

/* x的setter和getter方法 */
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

/* y的setter和getter方法 */
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

/* width的setter和getter方法 */
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

/* height的setter和getter方法 */
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


/* size的setter和getter方法 */
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}

/* origin的setter和getter方法 */
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)alignHorizontal
{
    self.x = (self.superview.width - self.width) * 0.5;
}

- (void)alignVertical
{
    self.y = (self.superview.height - self.height) *0.5;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (BOOL)isShowOnWindow
{
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //相对于父控件转换之后的rect
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    //主窗口的bounds
    CGRect winBounds = keyWindow.bounds;
    //判断两个坐标系是否有交汇的地方，返回bool值
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

- (CGFloat)borderWidth
{
    return self.borderWidth;
}

- (UIColor *)borderColor
{
    return self.borderColor;
    
}

- (CGFloat)cornerRadius
{
    return self.cornerRadius;
}

- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


@end

#pragma mark - UIButton
@implementation UIButton (ButtonUIMethod)

#pragma mark -基本属性快速初始化
-(void)SetBtnTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc andTitle:(NSString *)title{
    
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

+(UIButton *)GetBtnWithTitleColor:(UIColor *)tcolor andFont:(UIFont *)font andBgColor:(UIColor *)bgColor andBgImg:(UIImage *)Bgimg andImg:(UIImage *)img andClickEvent:(SEL)click andAddVC:(id )vc andTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc]init];
    if (title!=nil) {
        [btn setTitle:title forState:0];
    }
    
    if (font!=nil) {
        btn.titleLabel.font = font;
    }
    
    if (tcolor!=nil) {
        [btn setTitleColor:tcolor forState:0];
    }
    
    if (bgColor!=nil) {
        [btn setBackgroundColor:bgColor];
    }else{
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    
    if (Bgimg!=nil) {
        [btn setBackgroundImage:Bgimg forState:0];
    }
    
    if (img!=nil) {
        [btn setImage:img forState:0];
    }
    
    if (click!=nil) {
        [btn addTarget:vc action:click forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
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

#pragma mark - 垂直方向文字Aligment
-(void)SetTitleVAligment:(UIControlContentVerticalAlignment )VAligment andMargin:(CGFloat )margin{
    [self setContentVerticalAlignment:VAligment];
    self.titleEdgeInsets = UIEdgeInsetsMake(0,margin, 0, 0);
}

#pragma mark - 获取验证码
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color{
    
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = timeOut % 120;
            NSString * timeStr = [NSString stringWithFormat:@"%0.2d",seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
}

@end


#pragma mark - UIImageView
@implementation UIImageView (ImgVWUIMethod)

+(UIImageView *)getImageViewWithFrame:(CGRect )frame andImage:(UIImage *)img andBgColor:(UIColor *)color{
    UIImageView *imgVW = [[UIImageView alloc]initWithFrame:frame];
    if (img) {
        [imgVW setImage:img];
    }
    if (color) {
        [imgVW setBackgroundColor:color];
    }
    return imgVW;
}

+(UIImage *)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end

#pragma mark - UILabel
@implementation UILabel (UILabUIMethod)

-(void)SetLabFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor andlabTitle:(NSString *)title{
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

+(UILabel *)GetLabWithFont:(UIFont *)font andTitleColor:(UIColor *)titleColor andTextAligment:(NSTextAlignment )aligment andBgColor:(UIColor *)bgClor andlabTitle:(NSString *)title{
    UILabel *lab = [[UILabel alloc]init];
    if (title!=nil) {
        [lab setText:title];
    }
    
    if (font!=nil) {
        lab.font = font;
    }
    
    if (titleColor!=nil) {
        lab.textColor = titleColor;
    }
    
    if (aligment) {
        lab.textAlignment = aligment;
    }
    
    if (bgClor!=nil) {
        lab.backgroundColor = bgClor;
    }else{
        lab.backgroundColor = [UIColor clearColor];
    }
    return lab;
}

#pragma mark -富文本\\
#pragma mark .设置中划线
-(void)setLabelMiddleLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor{
    //    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
    //         NSStrikethroughStyleAttributeName:lineColor
    //                                 };
    //    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:title attributes:attribtDic];
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attribtStr setAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,title.length)];
    
    // 赋值
    self.attributedText = attribtStr;
}

#pragma mark .设置下划线
-(void)setLabelUnderLineWithLab:(NSString *)title andMiddleLineColor:(UIColor *)lineColor
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                 NSUnderlineStyleAttributeName:lineColor
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:title attributes:attribtDic];
    
    // 赋值
    self.attributedText = attribtStr;
}

#pragma mark .计算段落行高
-(CGFloat)getSpaceLabelHeightWithparStyle:(NSMutableParagraphStyle *)paraStyle withFont:(UIFont*)font withWidth:(CGFloat)width WithText:(NSString *)title{
    //    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //    /** 行高 */
    //    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f};
    CGSize size = [title boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


@end

#pragma mark - UITextField
@implementation UITextField (TextFiledMethod)

#pragma mark -基本属性快速初始化

+(UITextField *)getTextfiledWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andFont:(UIFont *)font andTextAlignment:(NSTextAlignment )aligment andPlaceHold:(NSString *)hold{
    UITextField *tf = [[UITextField alloc]init];
    if (title!=nil) {
        [tf setText:title];
    }
    if (titleColor!=nil) {
        [tf setTextColor:titleColor];
    }
    if (font!=nil) {
        tf.font = font;
    }
    if (aligment) {
        tf.textAlignment = aligment;
    }
    if (hold!=nil) {
        tf.placeholder = hold;
    }
    return tf;
}

-(void)SetTfTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andFont:(UIFont *)font andTextAlignment:(NSTextAlignment )aligment andPlaceHold:(NSString *)hold{
    if (title!=nil) {
        [self setText:title];
    }
    if (titleColor!=nil) {
        [self setTextColor:titleColor];
    }
    if (font!=nil) {
        self.font = font;
    }
    if (aligment) {
        self.textAlignment = aligment;
    }
    if (hold!=nil) {
        self.placeholder = hold;
    }
}

#pragma mark -限制输入框输入字数
-(void)limitTextLength:(NSInteger)length{
    NSString *toBeString = self.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRang = [self markedTextRange];
        if (!selectedRang) {
            if (toBeString.length > length) {
                self.text = [toBeString substringToIndex:length];
            }
        }else{ }
    } else {
        if (toBeString.length > length) {
            self.text = [toBeString substringToIndex:length];
        }
    }
}

#pragma mark -修改placehold的字体和颜色
-(void)modifyPlaceholdFont:(UIFont *)font andColor:(UIColor *)color{
    if (color!=nil) {
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (font!=nil) {
        [self setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
}

-(void)quickSetLeftViewWithImg:(UIImage *)img andSize:(CGSize )size andLeftVWSize:(CGSize )lvSize{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,lvSize.width,lvSize.height)];
    UIImageView *iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(leftView.frame)-(size.width/2), leftView.centerY-(size.height/2),size.width, size.height)];
    iconimg.image = img;
    [leftView addSubview:iconimg];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark -验证金额输入框输入有效性
- (BOOL)isRightInPutOfString:(NSString *) string withInputString:(NSString *) inputString range:(NSRange) range{
    //判断只输出数字和.号
    NSString *passWordRegex = @"[0-9\\.]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:inputString]) {
        return NO;
    }
    
    //第一位为0 之后不能输入0
    if (string.length == 1 && [[string substringToIndex:1] isEqualToString:@"0"]) {
        if ([inputString isEqualToString:@"0"]) {
            return NO;
        }
    }
    
    //逻辑处理
    if ([string containsString:@"."]) {
        if ([inputString isEqualToString:@"."]) {
            return NO;
        }
        NSRange subRange = [string rangeOfString:@"."];
        if (range.location - subRange.location > 2) {
            return NO;
        }
    }
    return YES;
}

@end


#pragma mark - UISearchBar
@implementation UISearchBar (TWHLeftPlaceHold)

-(void)changeLeftPlaceholder:(NSString *)placeholder {
    self.placeholder = placeholder;
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}

@end


#pragma mark - UITableView
@implementation UITableView (TableQuickInit)

+(UITableView *)GetTableWithFrame:(CGRect )rect andVC:(id )vc andBgColor:(UIColor *)bgColor andStyle:(UITableViewStyle )style andHeadVW:(UIView *)hv andFootVW:(UIView *)fv andWhetherNeedSepLine:(BOOL )sepLine andSepLineColor:(UIColor *)sepColor{
    UITableView *tab = [[UITableView alloc]initWithFrame:rect style:style];
    [tab setDataSource:vc];
    [tab setDelegate:vc];
    if (bgColor) {
        [tab setBackgroundColor:bgColor];
    }
    if (hv) {
        [tab setTableHeaderView:hv];
    }
    if (fv) {
        [tab setTableFooterView:fv];
    }
    
    if (sepLine == NO) {
        tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if (sepColor) {
        [tab setSeparatorColor:sepColor];
    }
    
    [tab setShowsVerticalScrollIndicator:NO];
    
    return tab;
}

@end


#pragma mark - UICollectionView
@implementation UICollectionView(CollectInit)

+(UICollectionViewFlowLayout *)getCollectFlowLayoutWithMinLineSpace:(CGFloat )linespace andMinInteritemSpacing:(CGFloat )Interitemspace andItemSize:(CGSize )size andSectionInsert:(UIEdgeInsets )inserts andscrollDirection:(UICollectionViewScrollDirection )direction{
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.minimumLineSpacing = linespace;
        fl.minimumInteritemSpacing = Interitemspace;
        fl.itemSize = size;
        fl.sectionInset = inserts;
        fl.scrollDirection = direction;
    return fl;
}

+(UICollectionView *)getCollectionviewWithFrame:(CGRect )rect andVC:(id)vc andBgColor:(UIColor *)bgColor andFlowLayout:(UICollectionViewFlowLayout *)fl andItemClass:(Class )cls andReuseID:(NSString *)identifier{

    UICollectionView *_itemCollect = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:fl];
    _itemCollect.dataSource = vc;
    _itemCollect.delegate = vc;
    [_itemCollect setBackgroundColor:bgColor];
    [_itemCollect registerClass:cls forCellWithReuseIdentifier:identifier];
    
    return _itemCollect;
}

@end

#pragma mark - UIBarButtonItem
@implementation UIBarButtonItem (BarButtonItemMethod)
+(instancetype )itemWithImage:(UIImage *)image Title:(NSString *)tle TitleColor:(UIColor *)color Font:(UIFont *)font Target:(id)target Action:(SEL)action{
    TWHImgTitleBtn *btn = [TWHImgTitleBtn buttonWithType:UIButtonTypeCustom];
    [btn setSpace:4];
    [btn setBtnStyle:TwhBtnStyleImageLeft];
    [btn SetBtnTitleColor:color andFont:font andBgColor:nil andBgImg:nil andImg:image andClickEvent:action ? action : nil andAddVC:target andTitle:tle];
    CGSize textSize = kGetTextSize(btn.titleLabel.text, MAXFLOAT, 20,16);
    btn.size = CGSizeMake(btn.currentImage.size.width + 3 + textSize.width, 20);
    return [[self alloc] initWithCustomView:btn];
}

+(instancetype)iTemWithImage:(UIImage *)image SelectImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [button setImage:image forState:0];
    }
    if (selImage) {
        [button setImage:selImage forState:UIControlStateSelected];
    }
    button.size = button.currentImage.size;
    if (action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    //处理iOS11导航栏按钮点击区域变小
//    if (@available (iOS 11.0,*)) {
//        [button setContentMode:UIViewContentModeScaleToFill];
//        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 20)];
//    }
    
    return [[self alloc] initWithCustomView:button];
}

+(instancetype)itmWithTitle:(NSString *)title SelectTitle:(NSString *)selectedTitle Font:(UIFont *)font textColor:(UIColor *)textcolor  selectedTextColor:(UIColor *)selctedColor target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (selectedTitle) {
     [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    if (textcolor) {
        [button setTitleColor:textcolor forState:UIControlStateNormal];
    }
    if (selctedColor) {
        [button setTitleColor:selctedColor forState:UIControlStateHighlighted];
    }
    if (action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    [button sizeToFit];
    
    return [[self alloc] initWithCustomView:button];
}

@end






