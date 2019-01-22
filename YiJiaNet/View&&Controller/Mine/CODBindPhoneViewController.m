//
//  CODBindPhoneViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBindPhoneViewController.h"
#import "NSString+COD.h"

@interface CODBindPhoneViewController () <UITextFieldDelegate>

@property(nonatomic,strong) UITextField* telNumTextField;
@property(nonatomic,strong) UITextField* verificationTextField;

/** 获取验证码 */
@property(nonatomic,strong) UIButton *GetYZMBtn;

@end

@implementation CODBindPhoneViewController

-(UITextField *)telNumTextField
{
    if (!_telNumTextField) {
        _telNumTextField = [[UITextField alloc]init];
        [_telNumTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入新手机号码"];
        _telNumTextField.tintColor = CODColorTheme;
        _telNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _telNumTextField.delegate = self;
        _telNumTextField.backgroundColor = [UIColor clearColor];
        
        UILabel *leftLab = [UILabel GetLabWithFont:kFont(16) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"手机号"];
        leftLab.size = CGSizeMake(60, 20);
        _telNumTextField.leftView = leftLab;
        _telNumTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42*proportionH + .8, SCREENWIDTH-40*proportionW, .8)];
        lineView.backgroundColor = kSepLineColor;
        [_telNumTextField addSubview:lineView];
    }return _telNumTextField;
}

-(UITextField *)verificationTextField {
    if (!_verificationTextField) {
        _verificationTextField = [[UITextField alloc]init];
        [_verificationTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入验证码"];
        _verificationTextField.delegate = self;
        _verificationTextField.tintColor = CODColorTheme;
        _verificationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verificationTextField.backgroundColor = [UIColor clearColor];
        
        UILabel *leftLab = [UILabel GetLabWithFont:kFont(16) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"验证码"];
        leftLab.size = CGSizeMake(60, 20);
        _verificationTextField.leftView = leftLab;
        _verificationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42*proportionH + .8, SCREENWIDTH-40*proportionW, .8)];
        lineView.backgroundColor = kSepLineColor;
        [_verificationTextField addSubview:lineView];
    }return _verificationTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定新手机号";
    [self wr_setNavBarShadowImageHidden:NO];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.telNumTextField];
    [self.telNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*proportionW);
        make.right.offset(-20*proportionW);
        make.height.offset(40*proportionH);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20*proportionH);
    }];
    
    [self.view addSubview:self.GetYZMBtn];
    [self.GetYZMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100*proportionH);
        make.height.offset(40*proportionH);
        make.right.equalTo(self.view).offset(-25*proportionW);
        make.top.equalTo(self.telNumTextField.mas_bottom).offset(12*proportionH);
    }];
    
    [self.view addSubview:self.verificationTextField];
    [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(170*proportionW);
        make.height.offset(40*proportionH);
        make.left.equalTo(self.view).offset(20*proportionW);
        make.top.equalTo(self.telNumTextField.mas_bottom).offset(12*proportionH);
    }];
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn SetBtnTitle:@"绑定新手机号" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(confirmBtnAction) andAddVC:self];
    [registerBtn setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonNormal] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonHighlighted] forState:UIControlStateHighlighted];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 22;
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.telNumTextField.mas_width);
        make.height.offset(44);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verificationTextField.mas_bottom).offset(35*proportionW);
    }];
}

- (UIButton *)GetYZMBtn
{
    if (!_GetYZMBtn) {
        _GetYZMBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_GetYZMBtn SetBtnTitle:@"获取动态验证码" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?13:15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(GetYZMBtnClicked:) andAddVC:self];
        
    } return _GetYZMBtn;
}

//绑定新手机
-(void)confirmBtnAction {
    if (self.telNumTextField.text.length == 0) {
        [SVProgressHUD cod_showWithInfo:@"请输入手机号"];
        return;
    }
    if (![self.telNumTextField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithInfo:@"请输入正确格式的手机号"];
        return;
    }
    if (self.verificationTextField.text.length == 0) {
        [SVProgressHUD cod_showWithInfo:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"new_mobile"] = self.telNumTextField.text;
    params[@"code"] = self.verificationTextField.text;
    
    [SVProgressHUD cod_showStatu];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=edit_mobile" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            [SVProgressHUD cod_showWithSuccessInfo:@"新手机号绑定成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];                     
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

//获取验证码
-(void)GetYZMBtnClicked:(UIButton*)sender {
    
    if (self.telNumTextField.text.length == 0) {
        [SVProgressHUD cod_showWithInfo:@"请输入手机号"];
        return;
    }
    if (![self.telNumTextField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithInfo:@"请输入正确格式的手机号"];
        return;
    }
    [SVProgressHUD cod_showStatu];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.telNumTextField.text;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=get_code" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            [sender startWithTime:60 title:@"重新获取验证码" countDownTitle:@"秒" mainColor:[UIColor clearColor] countColor:[UIColor clearColor]];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

- (void)gotoBlindNewPhone {
    CODBindPhoneViewController *bindVC = [[CODBindPhoneViewController alloc] init];
    [self.navigationController pushViewController:bindVC animated:YES];
}
#pragma mark - 输入框的代理实现 UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

//限定尼称文字字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.telNumTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    if (textField == self.verificationTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
