//
//  CODOrderPopView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/3.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODOrderPopView.h"
#import "UIButton+COD.h"
#import "BRAddressPickerView.h"

#define self_ViewH 340
#define self_ViewW SCREENWIDTH-40

@interface CODOrderPopView ()

@property(nonatomic,strong) UIControl *coverView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIView *containView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIButton *cityBtn;
@property(nonatomic,strong) UITextField *hourseTF;
@property(nonatomic,strong) UITextField *phoneTF;
@property(nonatomic,strong) UIButton *cpmmitBtn;
@property(nonatomic,strong) UIButton *colseBtn;

@property (nonatomic, copy) NSString *fullAdressName;
@property(nonatomic,copy) NSString *proviceValue;
@property(nonatomic,copy) NSString *cityValue;
@property(nonatomic,copy) NSString *areaValue;

@end

@implementation CODOrderPopView

-(UIControl *)coverView {
    if (!_coverView) {
        _coverView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
//        [_coverView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _coverView.userInteractionEnabled = YES;
    }
    return _coverView;
}

-(UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, -self_ViewH, SCREENWIDTH, self_ViewH+50)];
        _whiteView.backgroundColor = [UIColor clearColor];
        _whiteView.userInteractionEnabled = YES;
    }
    return _whiteView;
}

-(UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self_ViewW, self_ViewH)];
        _containView.backgroundColor = [UIColor whiteColor];
        _containView.userInteractionEnabled = YES;
        _containView.layer.cornerRadius = 10;
        _containView.layer.masksToBounds = YES;
    }
    return _containView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self congigureView];
    }return self;
}

-(void)congigureView {
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.whiteView];
    [self.whiteView addSubview:self.containView];

    self.topView = [UIView getAViewWithFrame:CGRectMake(0, 0, self_ViewW, 100) andBgColor:CODHexColor(0x58BDEB)];
    [self.containView addSubview:self.topView];

    UIButton *imgView1 = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:kFont(13) andBgColor:nil andBgImg:nil andImg:kGetImage(@"decorate_appointment1") andClickEvent:nil andAddVC:nil andTitle:@"线上预约"];
    UIButton *imgView2 = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:kFont(13) andBgColor:nil andBgImg:nil andImg:kGetImage(@"decorate_appointment2") andClickEvent:nil andAddVC:nil andTitle:@"电话沟通"];
    UIButton *imgView3 = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:kFont(13) andBgColor:nil andBgImg:nil andImg:kGetImage(@"decorate_appointment3") andClickEvent:nil andAddVC:nil andTitle:@"上门量房"];
    imgView1.frame = CGRectMake(30, 20, 55, 70);
    imgView2.frame = CGRectMake(CGRectGetMaxX(imgView1.frame)+(self_ViewW-60-55*3)/2, 20, 60, 70);
    imgView3.frame = CGRectMake(CGRectGetMaxX(imgView2.frame)+(self_ViewW-60-55*3)/2, 20, 60, 70);
    [imgView1 cod_alignImageUpAndTitleDown];
    [imgView2 cod_alignImageUpAndTitleDown];
    [imgView3 cod_alignImageUpAndTitleDown];
    [self.topView addSubview:imgView1];
    [self.topView addSubview:imgView2];
    [self.topView addSubview:imgView3];
    
    UIImageView *arrowimgView1 = [UIImageView getImageViewWithFrame:CGRectMake(CGRectGetMaxX(imgView1.frame)+(self_ViewW-60-55*3)/4, 44, 5, 10)andImage:kGetImage(@"case_arrow") andBgColor:nil];
    [self.topView addSubview:arrowimgView1];
    UIImageView *arrowimgView2 = [UIImageView getImageViewWithFrame:CGRectMake(CGRectGetMaxX(imgView2.frame)+(self_ViewW-60-55*3)/4, 44, 5, 10)andImage:kGetImage(@"case_arrow") andBgColor:nil];
    [self.topView addSubview:arrowimgView2];
    
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityButton SetBtnTitle:@"选择城市 >" andTitleColor:CODColor333333 andFont:[UIFont systemFontOfSize:14] andBgColor:nil andBgImg:nil andImg:kGetImage(@"decorate_positioning") andClickEvent:@selector(citySelectAction:) andAddVC:nil];
    cityButton.frame = CGRectMake(20, CGRectGetMaxY(self.topView.frame)+15, self_ViewW-30, 20);
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.cityBtn = cityButton;
    [self.containView addSubview:self.cityBtn];

    UITextField *houseTextField = [[UITextField alloc]init];
    [houseTextField SetTfTitle:nil andTitleColor:CODColor333333 andFont:kFont(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入小区名称"];
    [houseTextField setLayWithCor:2 andLayerWidth:0.5 andLayerColor:CODColorBackground];
    [houseTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"decorate_community"] andSize:[UIImage imageNamed:@"login_paddword"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
    houseTextField.frame = CGRectMake(20, CGRectGetMaxY(self.cityBtn.frame)+20, self_ViewW-40, 40);
    self.hourseTF = houseTextField;
    [self.containView addSubview:self.hourseTF];

    UITextField *phoneTextField = [[UITextField alloc]init];
    [phoneTextField SetTfTitle:nil andTitleColor:CODColor333333 andFont:kFont(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入电话号码"];
    [phoneTextField setLayWithCor:2 andLayerWidth:0.5 andLayerColor:CODColorBackground];
    [phoneTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"decorate_phone"] andSize:[UIImage imageNamed:@"login_paddword"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
    phoneTextField.frame = CGRectMake(20, CGRectGetMaxY(self.hourseTF.frame)+20, self_ViewW-40,40);
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF = phoneTextField;
    [self.containView addSubview:self.phoneTF];
    
    UIButton *commitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitbutton setTitle:@"免费预约" forState:UIControlStateNormal];
    [commitbutton setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonNormal] forState:UIControlStateNormal];
    [commitbutton setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonHighlighted] forState:UIControlStateHighlighted];
    [commitbutton setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonDisabled] forState:UIControlStateDisabled];
    [commitbutton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    commitbutton.layer.cornerRadius = 2;
    commitbutton.layer.masksToBounds = YES;
    commitbutton.frame = CGRectMake(20, CGRectGetMaxY(self.phoneTF.frame)+20, self_ViewW-40,40);
    self.cpmmitBtn = commitbutton;
    [self.containView addSubview:self.cpmmitBtn];
    
    UIButton *colsebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [colsebtn setImage:kGetImage(@"decorate_error") forState:0];
    [colsebtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    colsebtn.frame = CGRectMake((SCREENWIDTH/2)-15, CGRectGetMaxY(self.containView.frame)+20,30,30);
    self.colseBtn = colsebtn;
    [self.whiteView addSubview:self.colseBtn];
}

#pragma mark - Action

-(void)commitAction {
    if (kStringIsEmpty(self.cityValue)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请选择城市"];
        return;
    }
    if (kStringIsEmpty(self.hourseTF.text)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请填写小区名字"];
        return;
    }
    if (kStringIsEmpty(self.phoneTF.text)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请填写手机号码"];
        return;
    }
    
    if (self.commitBlock) {
        [self close];
        self.commitBlock(self.fullAdressName, self.proviceValue, self.cityValue, self.areaValue, self.hourseTF.text, self.phoneTF.text);
    }
}

-(void)citySelectAction:(UIButton *)button {
    NSArray *defaultSelArr = nil;
    NSArray *dataSource = nil;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:NO themeColor:CODColorTheme resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        self.fullAdressName = [NSString stringWithFormat:@"%@%@%@",province.name, city.name, area.name];
        self.proviceValue = province.name;
        self.cityValue = city.name;
        self.areaValue = area.name;
        CODLogObject(self.fullAdressName);
        [self.cityBtn setTitle:self.fullAdressName forState:0];
    } cancelBlock:^{
    }];
}
#pragma mark - 显示视图
-(void)show {
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        self.whiteView.y = 200*proportionH;
        
    }completion:^(BOOL finished){
        
    }];
    
    [keyWindow addSubview:self];
    self.whiteView.layer.position =  CGPointMake(self.centerX, self.centerY);
    self.whiteView.transform = CGAffineTransformMakeScale(0.60, 0.60);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        self.whiteView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 隐藏视图
-(void)close {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
//        self.whiteView.y = -self_ViewH;
    }completion:^(BOOL finished){
        self.coverView = nil;
        self.whiteView = nil;
        [self removeFromSuperview];
    }];
}

@end
