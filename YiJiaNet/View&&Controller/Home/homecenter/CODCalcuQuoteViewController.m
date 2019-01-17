//
//  CODCalcuQuoteViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODCalcuQuoteViewController.h"
#import "CODModifyQuantityView.h"
#import "TWHRichTextTool.h"
#import "BRAddressPickerView.h"

@interface CODCalcuQuoteViewController ()

@property(nonatomic, strong) UIScrollView *backScrollView;
@property(nonatomic, strong) UIView *containView;

/** 提交页面 */
@property(nonatomic, strong) UIView *backBorderViewOne;

@property(nonatomic, strong) UITextField *houseNameTF;
@property(nonatomic, strong) UITextField *sizeTF;
@property(nonatomic, strong) UITextField *phoneTF;

@property(nonatomic, strong) CODModifyQuantityView *ModifyViewOne;
@property(nonatomic, strong) CODModifyQuantityView *ModifyViewTwo;
@property(nonatomic, strong) CODModifyQuantityView *ModifyViewThree;
@property(nonatomic, strong) CODModifyQuantityView *ModifyViewFour;

@property(nonatomic, strong) UILabel *mCitylabel;
@property (nonatomic, copy) NSString *fullAdressName;
@property (nonatomic, strong) CLGeocoder *geocoder;

// 参数
@property (nonatomic, copy) NSString *hourseValue;
@property (nonatomic, copy) NSString *provinceValue;//省
@property (nonatomic, copy) NSString *cityValue;//市
@property (nonatomic, copy) NSString *areaValue;//区
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *sizeValue;
@property (nonatomic, assign) NSInteger shiValue;
@property (nonatomic, assign) NSInteger tingValue;
@property (nonatomic, assign) NSInteger weiValue;
@property (nonatomic, assign) NSInteger yangtValue;
@property (nonatomic, copy) NSString *phoneValue;


/** 结果页面 */
@property(nonatomic, strong) UIView *backBorderViewTwo;

@property(nonatomic, strong) UILabel *totalPriceLable;
@property(nonatomic, strong) UILabel *intoLable;
@property(nonatomic, strong) UILabel *rengongPriceLable;;
@property(nonatomic, strong) UILabel *cailiaoPriceLable;


@property(nonatomic, strong) NSDictionary *resultDic;

@end

@implementation CODCalcuQuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"装修报价预算";
    self.view.backgroundColor = CODColorTheme;
    
    self.resultDic = [NSDictionary dictionary];
    
    self.containView = [[UIView alloc] init];
    [self.view addSubview:self.containView];
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIImageView *headeImageView = [[UIImageView alloc] init];
    headeImageView.image = kGetImage(@"icon_banner2");
    [self.containView addSubview:headeImageView];
    [headeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@150);
    }];
    
    
    [self.containView addSubview:self.backBorderViewOne];
    [self configureOne];
    
    [self.containView addSubview:self.backBorderViewTwo];
    [self configureTwo];
    
    self.backBorderViewOne.hidden = NO;
    self.backBorderViewTwo.hidden = YES;
    
    RAC(self, hourseValue) = self.houseNameTF.rac_textSignal;
    RAC(self, sizeValue) = self.sizeTF.rac_textSignal;
    RAC(self, phoneValue) = self.phoneTF.rac_textSignal;
}

- (void)configureOne {
    
    UILabel *largeTitleLable = [UILabel GetLabWithFont:[UIFont fontWithName:@"Helvetica-Bold"size:18] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"我家的户型"];
    [self.backBorderViewOne addSubview:largeTitleLable];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CODColorTheme;
    lineView.layer.cornerRadius = 3;
    lineView.layer.masksToBounds = YES;
    [largeTitleLable addSubview:lineView];
    // 小区名
    UITextField *nameTextField = [UITextField getTextfiledWithTitle:nil andTitleColor:CODColor333333 andFont:kFont(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"您所在的小区名称"];
    [nameTextField modifyPlaceholdFont:kFont(14) andColor:CODColor999999];
    nameTextField.backgroundColor = CODHexColor(0xF2F2F2);
    nameTextField.layer.cornerRadius = 5;
    nameTextField.layer.masksToBounds = YES;
    nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.houseNameTF = nameTextField;
    [self.backBorderViewOne addSubview:nameTextField];

    //城市
    UIView *cityView = [[UIView alloc] init];
    cityView.backgroundColor = CODHexColor(0xF2F2F2);
    cityView.layer.cornerRadius = 5;
    cityView.layer.masksToBounds = YES;
    cityView.userInteractionEnabled = YES;
    [cityView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self citySelectAction];
    }];
    [self.backBorderViewOne addSubview:cityView];
    
    UILabel *cityLabel = [UILabel GetLabWithFont:XFONT_SIZE(14) andTitleColor:CODColor666666 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:@"您所在的城市"];
    [cityView addSubview:cityLabel];
    self.mCitylabel = cityLabel;
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.image = kGetImage(@"decorate_screening");
    [cityView addSubview:arrowImgView];
    // 面积
    UIView *sizeView = [[UIView alloc] init];
    sizeView.backgroundColor = CODHexColor(0xF2F2F2);
    sizeView.layer.cornerRadius = 5;
    sizeView.layer.masksToBounds = YES;
    [self.backBorderViewOne addSubview:sizeView];
    
    UITextField *sizeLabel = [UITextField getTextfiledWithTitle:nil andTitleColor:CODColor333333 andFont:kFont(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"我家的面积"];
    [sizeLabel modifyPlaceholdFont:kFont(14) andColor:CODColor999999];
    sizeLabel.keyboardType = UIKeyboardTypeDecimalPad;
    self.sizeTF = sizeLabel;
    [sizeView addSubview:sizeLabel];
//
//    UILabel *sizeLabel = [UILabel GetLabWithFont:XFONT_SIZE(14) andTitleColor:CODColor999999 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:@"我家的面积"];
//    [sizeView addSubview:sizeLabel];
    
    UILabel *unitLable = [UILabel GetLabWithFont:XFONT_SIZE(14) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentRight andBgColor:nil andlabTitle:@"㎡"];
    [sizeView addSubview:unitLable];
    // 室
    UIView *jiajianView1 = [[UIView alloc] init];
    jiajianView1.backgroundColor = CODHexColor(0xF2F2F2);
    jiajianView1.layer.cornerRadius = 5;
    jiajianView1.layer.masksToBounds = YES;
    [self.backBorderViewOne addSubview:jiajianView1];
    CODModifyQuantityView *modifyView1 = [[CODModifyQuantityView alloc] initWithFrame:CGRectZero Unit:@"室"];
    modifyView1.quantityChangeBlock = ^(NSUInteger quantity) {
        self.shiValue = quantity;
    };
    self.ModifyViewOne = modifyView1;
    [jiajianView1 addSubview:modifyView1];
    // 厅
    UIView *jiajianView2 = [[UIView alloc] init];
    jiajianView2.backgroundColor = CODHexColor(0xF2F2F2);
    jiajianView2.layer.cornerRadius = 5;
    jiajianView2.layer.masksToBounds = YES;
    [self.backBorderViewOne addSubview:jiajianView2];
    CODModifyQuantityView *modifyView2 = [[CODModifyQuantityView alloc] initWithFrame:CGRectZero Unit:@"厅"];
    modifyView2.quantityChangeBlock = ^(NSUInteger quantity) {
        self.tingValue = quantity;
    };
    self.ModifyViewTwo = modifyView2;
    [jiajianView2 addSubview:modifyView2];
    // 厨
    UIView *jiajianView3 = [[UIView alloc] init];
    jiajianView3.backgroundColor = CODHexColor(0xF2F2F2);
    jiajianView3.layer.cornerRadius = 5;
    jiajianView3.layer.masksToBounds = YES;
    [self.backBorderViewOne addSubview:jiajianView3];
    CODModifyQuantityView *modifyView3 = [[CODModifyQuantityView alloc] initWithFrame:CGRectZero Unit:@"卫"];
    modifyView3.quantityChangeBlock = ^(NSUInteger quantity) {
        self.weiValue = quantity;
    };
    self.ModifyViewThree = modifyView3;
    [jiajianView3 addSubview:modifyView3];
    // 卫
    UIView *jiajianView4 = [[UIView alloc] init];
    jiajianView4.backgroundColor = CODHexColor(0xF2F2F2);
    jiajianView4.layer.cornerRadius = 5;
    jiajianView4.layer.masksToBounds = YES;
    [self.backBorderViewOne addSubview:jiajianView4];
    CODModifyQuantityView *modifyView4 = [[CODModifyQuantityView alloc] initWithFrame:CGRectZero Unit:@"阳台"];
    modifyView4.quantityChangeBlock = ^(NSUInteger quantity) {
        self.yangtValue = quantity;
    };
    self.ModifyViewFour = modifyView4;
    [jiajianView4 addSubview:modifyView4];
    
    // 电话号码框
    UITextField *phoneTextField = [UITextField getTextfiledWithTitle:nil andTitleColor:CODColor333333 andFont:kFont(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入手机号码、报价结果将发送至手机"];
    [phoneTextField modifyPlaceholdFont:kFont(14) andColor:CODColor999999];
    phoneTextField.backgroundColor = CODHexColor(0xF2F2F2);
    phoneTextField.layer.cornerRadius = 5;
    phoneTextField.layer.masksToBounds = YES;
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF = phoneTextField;
    [self.backBorderViewOne addSubview:phoneTextField];
    // 提交按钮
    UIButton *commitButton = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:XFONT_SIZE(16) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(commitBtnAction) andAddVC:self andTitle:@"免费获取报价明细"];
    [commitButton SetLayWithCor:5 andLayerWidth:0 andLayerColor:nil];
    [self.backBorderViewOne addSubview:commitButton];
    // 底部文字
    UILabel *tipLabel = [UILabel GetLabWithFont:XFONT_SIZE(12) andTitleColor:CODHexColor(0xFB5B1C) andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"*您的信息将被严格保密"];
    [self.backBorderViewOne addSubview:tipLabel];
    
    [largeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBorderViewOne.mas_top).offset(20);
        make.centerX.equalTo(self.backBorderViewOne);
        make.height.equalTo(@20);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(largeTitleLable);
        make.centerX.equalTo(self.backBorderViewOne);
        make.height.equalTo(@5);
        make.top.equalTo(largeTitleLable.mas_bottom).offset(-5);
    }];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(largeTitleLable.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(@44);
    }];
    CGFloat itmeWidth = (SCREENWIDTH-12-12-50)/2;
    [cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
        make.left.offset(20);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-30);
        make.centerY.equalTo(cityView);
        make.height.equalTo(@44);
    }];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(cityView);
        make.size.mas_equalTo(CGSizeMake(10, 8));
    }];
    [sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
        make.left.equalTo(cityView.mas_right).offset(10);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(cityView);
        make.height.equalTo(@44);
    }];
    [unitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(cityView);
    }];
    [jiajianView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cityView.mas_bottom).offset(10);
        make.left.offset(20);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [jiajianView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cityView.mas_bottom).offset(10);
        make.left.equalTo(jiajianView1.mas_right).offset(10);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [jiajianView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiajianView1.mas_bottom).offset(10);
        make.left.offset(20);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [jiajianView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiajianView1.mas_bottom).offset(10);
        make.left.equalTo(jiajianView3.mas_right).offset(10);
        make.width.equalTo(@(itmeWidth));
        make.height.equalTo(@44);
    }];
    [modifyView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(jiajianView1).mas_offset(UIEdgeInsetsMake(11, 15, 11, 15));
    }];
    [modifyView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(jiajianView2).mas_offset(UIEdgeInsetsMake(11, 15, 11, 15));
    }];
    [modifyView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(jiajianView3).mas_offset(UIEdgeInsetsMake(11, 15, 11, 15));
    }];
    [modifyView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(jiajianView4).mas_offset(UIEdgeInsetsMake(11, 15, 11, 15));
    }];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiajianView4.mas_bottom).offset(10);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(@44);
    }];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(30);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(@44);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backBorderViewOne.mas_bottom).offset(-10);
        make.left.right.offset(0);
    }];
}


- (void)configureTwo {
    
    UILabel *largeTitleLable = [UILabel GetLabWithFont:[UIFont fontWithName:@"Helvetica-Bold"size:18] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"预估报价"];
    [self.backBorderViewTwo addSubview:largeTitleLable];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CODColorTheme;
    lineView.layer.cornerRadius = 3;
    lineView.layer.masksToBounds = YES;
    [largeTitleLable addSubview:lineView];
    
    //总价
    UILabel *sumLable = [UILabel GetLabWithFont:kFont(40) andTitleColor:CODColorTheme andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@""];
//    [sumLable setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(14) Color:CODColor333333 TotalString:@"0万元" SubStringArray:@[@"万元"] AndOptions:1 andchangeLineSpaceWithLineSpace:1]];
    self.totalPriceLable = sumLable;
    [self.backBorderViewTwo addSubview:sumLable];

    UILabel *banbaoLabel = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"你家装修总估价（半包）"];
    [self.backBorderViewTwo addSubview:banbaoLabel];

    //户型
    UILabel *houseTypeLabel = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor999999 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@""];
    self.intoLable = houseTypeLabel;
    [self.backBorderViewTwo addSubview:houseTypeLabel];
    //line
    UIView *shuLineView = [[UIView alloc] init];
    shuLineView.backgroundColor = CODHexColor(0xeeeeee);
    [self.backBorderViewTwo addSubview:shuLineView];
    //人工费
    UILabel *rengongLabel = [UILabel GetLabWithFont:kFont(20) andTitleColor:CODColorTheme andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@""];
    rengongLabel.numberOfLines = 0;
//    [rengongLabel setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(16) Color:CODHexColor(0xFB5B1C) TotalString:@"人工费\n0 万元" SubStringArray:@[@"0"] AndOptions:1 andchangeLineSpaceWithLineSpace:1]];
    self.rengongPriceLable = rengongLabel;
    [self.backBorderViewTwo addSubview:rengongLabel];
    //材料费
    UILabel *cailiaoLabel = [UILabel GetLabWithFont:kFont(20) andTitleColor:CODColorTheme andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@""];
    cailiaoLabel.numberOfLines = 0;
//    [cailiaoLabel setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(14) Color:CODColor333333 TotalString:@"材料费\n2.2万元" SubStringArray:@[@"万元", @"材料费"] AndOptions:1 andchangeLineSpaceWithLineSpace:5]];
    self.cailiaoPriceLable = cailiaoLabel;
    [self.backBorderViewTwo addSubview:cailiaoLabel];

    UILabel *tipsLabel = [UILabel GetLabWithFont:kFont(12) andTitleColor:CODColor999999 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"30分钟内装修管家将会致电您\n为您提供更详细的装修预算评估，请留意来电"];
    tipsLabel.numberOfLines = 0;
    [tipsLabel setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(12) Color:CODHexColor(0xFB5B1C) TotalString:@"30分钟内装修管家将会致电您\n为您提供更详细的装修预算评估，请留意来电" SubStringArray:@[@"30分钟"] AndOptions:1 andchangeLineSpaceWithLineSpace:1]];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.backBorderViewTwo addSubview:tipsLabel];
    // 重新报价按钮
    UIButton *commitButton = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:XFONT_SIZE(16) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(againAction) andAddVC:self andTitle:@"重新报价"];
    [commitButton SetLayWithCor:5 andLayerWidth:0 andLayerColor:nil];
    [self.backBorderViewTwo addSubview:commitButton];
    
    [largeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBorderViewTwo.mas_top).offset(20);
        make.centerX.equalTo(self.backBorderViewTwo);
        make.height.equalTo(@20);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(largeTitleLable);
        make.centerX.equalTo(self.backBorderViewTwo);
        make.height.equalTo(@5);
        make.top.equalTo(largeTitleLable.mas_bottom).offset(-5);
    }];
    [sumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(largeTitleLable.mas_bottom).offset(20);
        make.centerX.equalTo(self.backBorderViewTwo);
        make.height.equalTo(@40);
    }];
    [banbaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backBorderViewTwo);
        make.top.equalTo(sumLable.mas_bottom).offset(15);
        make.height.equalTo(@20);
    }];
    [houseTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backBorderViewTwo);
        make.top.equalTo(banbaoLabel.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    CGFloat itmeHalfWidth = (SCREENWIDTH-12-12-1)/2;
    [rengongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBorderViewTwo.mas_left);
        make.top.equalTo(houseTypeLabel.mas_bottom).offset(30);
        make.width.equalTo(@(itmeHalfWidth));
        make.height.equalTo(@50);

    }];
    [shuLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backBorderViewTwo);
        make.top.equalTo(rengongLabel);
        make.width.equalTo(@1);
        make.height.equalTo(@50);
    }];
    [cailiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backBorderViewTwo.mas_right);
        make.top.equalTo(houseTypeLabel.mas_bottom).offset(30);
        make.width.equalTo(@(itmeHalfWidth));
        make.height.equalTo(@50);
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backBorderViewTwo);
        make.top.equalTo(rengongLabel.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backBorderViewTwo.mas_bottom).offset(-30);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.equalTo(@44);
    }];
}

- (UIView *)backBorderViewOne {
    if (!_backBorderViewOne) {
        _backBorderViewOne = [[UIView alloc] initWithFrame:CGRectMake(12, 140, SCREENWIDTH-24, 440)];
        _backBorderViewOne.backgroundColor = [UIColor whiteColor];
        [_backBorderViewOne setLayWithCor:7 andLayerWidth:1 andLayerColor:nil];
    }
    return _backBorderViewOne;
}

- (UIView *)backBorderViewTwo {
    if (!_backBorderViewTwo) {
        _backBorderViewTwo = [[UIView alloc] initWithFrame:CGRectMake(12, 140, SCREENWIDTH-24, 440)];
        _backBorderViewTwo.backgroundColor = [UIColor whiteColor];
        [_backBorderViewTwo setLayWithCor:7 andLayerWidth:1 andLayerColor:nil];
    }
    return _backBorderViewTwo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)citySelectAction {
    [self.houseNameTF resignFirstResponder];
    [self.sizeTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];

    NSArray *defaultSelArr = nil;
    NSArray *dataSource = nil;//为空，则是使用框架自带城市数据
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:NO themeColor:CODColorTheme resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        self.fullAdressName = [NSString stringWithFormat:@"%@%@%@",province.name, city.name, area.name];
        self.provinceValue = province.name;
        self.cityValue = city.name;
        self.areaValue = area.name;
        CODLogObject(self.fullAdressName);
        NSString *selectValue = [NSString stringWithFormat:@"%@%@",city.name, area.name];
        self.mCitylabel.textColor =CODColor333333;
        self.mCitylabel.text = selectValue;
    } cancelBlock:^{
    }];
}

- (void)commitBtnAction {
    if (kStringIsEmpty(self.houseNameTF.text)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请填写所在小区名称"];
        return;
    }if (kStringIsEmpty(self.fullAdressName)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请选择所在城市"];
        return;
    }if (kStringIsEmpty(self.sizeTF.text)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请填写面积"];
        return;
    }if (kStringIsEmpty(self.phoneTF.text)) {
        [SVProgressHUD cod_showWithErrorInfo:@"请填写手机号码"];
        return;
    }
    //地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:self.fullAdressName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            CODLogObject(error);
        }
        //创建placemark对象
        CLPlacemark *placemark = [placemarks firstObject];
        //经度
        self.longitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        //纬度
        self.latitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        
        NSLog(@"经度：%@，纬度：%@",self.longitude,self.latitude);
    }];
    
    [SVProgressHUD cod_showWithStatu:@"正在估价，请稍后..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD cod_dismis];
        [self uploadData];
    });
}

- (void)uploadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"longitude"] = self.longitude;
    params[@"latitude"] = self.latitude;
    params[@"province"] = self.provinceValue;
    params[@"city"] = self.cityValue;
    params[@"area"] = self.areaValue;
    params[@"house_type"] = [NSString stringWithFormat:@"%@室%@厅%@卫%@阳台",@(self.shiValue),@(self.tingValue),@(self.weiValue),@(self.yangtValue)];
    params[@"house_acreage"] = self.sizeValue;
    params[@"mobile"] = self.phoneValue;
    params[@"house_name"] = self.hourseValue;
    params[@"type"] = @(1);//0或不传 预约, 1报价
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=ordered" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            self.resultDic = object[@"data"][@"offer"];
            
            [self updateWithDic:self.resultDic];
            
            self.backBorderViewOne.hidden = YES;
            self.backBorderViewTwo.hidden = NO;
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

- (void)againAction {
    // 清空输入信息
    self.houseNameTF.text = @"";
    self.sizeTF.text = @"";
    self.phoneTF.text = @"";
    self.fullAdressName = @"";
    self.mCitylabel.text = @"您所在的城市";
    
    [self.ModifyViewOne resetAmount];
    [self.ModifyViewTwo resetAmount];
    [self.ModifyViewThree resetAmount];
    [self.ModifyViewFour resetAmount];
    
    self.backBorderViewOne.hidden = NO;
    self.backBorderViewTwo.hidden = YES;
}

- (void)updateWithDic:(NSDictionary *)dic {
    
    NSString *priceUnit = @"万元";
    NSString *totalSum = kFORMAT(@"%@%@", @([dic[@"all_cost"] floatValue]), priceUnit);
    NSString *totalRengong = kFORMAT(@"人工费\n%@%@", @([dic[@"labour_cost"] floatValue]), priceUnit);
    NSString *totalCailiao = kFORMAT(@"材料费\n%@%@", @([dic[@"material_cost"] floatValue]), priceUnit);

    [self.totalPriceLable setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(14) Color:CODColor333333 TotalString:totalSum SubStringArray:@[priceUnit] AndOptions:1 andchangeLineSpaceWithLineSpace:1]];
    
    [self.rengongPriceLable setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(14) Color:CODColor333333 TotalString:totalRengong SubStringArray:@[priceUnit, @"人工费"] AndOptions:1 andchangeLineSpaceWithLineSpace:5]];
    
    [self.cailiaoPriceLable setAttributedText:[TWHRichTextTool changeFontAndColor:kFont(16) Color:CODColor333333 TotalString:totalCailiao SubStringArray:@[priceUnit, @"材料费"] AndOptions:1 andchangeLineSpaceWithLineSpace:5]];
    
    self.totalPriceLable.textAlignment = NSTextAlignmentCenter;
    self.rengongPriceLable.textAlignment = NSTextAlignmentCenter;
    self.cailiaoPriceLable.textAlignment = NSTextAlignmentCenter;

    self.intoLable.text = dic[@"house_info"];
}

@end
