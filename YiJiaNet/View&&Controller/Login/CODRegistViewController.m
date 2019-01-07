//
//  CODRegistViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODRegistViewController.h"
#import "CODBaseWebViewController.h"
#import "NSString+COD.h"

@interface CODRegistViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField* telNumTextField;
@property(nonatomic,strong) UITextField* verificationTextField;
@property(nonatomic,strong) UITextField* passwordTextField;
@property(nonatomic,strong) UITextField* againPassTextField;

/** 获取验证码 */
@property(nonatomic,strong) UIButton *GetYZMBtn;

@end

@implementation CODRegistViewController

-(UITextField *)telNumTextField
{
    if (!_telNumTextField) {
        _telNumTextField = [[UITextField alloc]init];
        [_telNumTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入手机号码"];
        _telNumTextField.tintColor = CODColorTheme;
        _telNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _telNumTextField.delegate = self;
        _telNumTextField.backgroundColor = [UIColor clearColor];
        [_telNumTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_username"] andSize:[UIImage imageNamed:@"login_username"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*proportionW, 42*proportionH + .8, 260*proportionW, .8)];
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
        [_verificationTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_code"] andSize:[UIImage imageNamed:@"login_code"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*proportionW, 42*proportionH + .8, 260*proportionW, .8)];
        lineView.backgroundColor = kSepLineColor;
        [_verificationTextField addSubview:lineView];
    }return _verificationTextField;
}

-(UITextField *)passwordTextField {
    
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        [_passwordTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入密码"];
        _passwordTextField.delegate = self;
        _passwordTextField.tintColor = CODColorTheme;
        _passwordTextField.secureTextEntry=YES;
        _passwordTextField.backgroundColor = [UIColor clearColor];
        [_passwordTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_paddword"] andSize:[UIImage imageNamed:@"login_paddword"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*proportionW, 42*proportionH + .8, 260*proportionW, .8)];
        lineView.backgroundColor = kSepLineColor;
        [_passwordTextField addSubview:lineView];
    }return _passwordTextField;
}

-(UITextField *)againPassTextField {
    
    if (!_againPassTextField) {
        _againPassTextField = [[UITextField alloc]init];
        [_againPassTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请再次输入密码"];
        _againPassTextField.delegate = self;
        _againPassTextField.tintColor = CODColorTheme;
        _againPassTextField.secureTextEntry=YES;
        _againPassTextField.backgroundColor = [UIColor clearColor];
        [_againPassTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_paddword"] andSize:[UIImage imageNamed:@"login_paddword"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(10*proportionW, 42*proportionH + .8, 260*proportionW, .8)];
        lineView.backgroundColor = kSepLineColor;
        [_againPassTextField addSubview:lineView];
    }return _againPassTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.telNumTextField];
    [self.telNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(280*proportionW);
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
    
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(280*proportionW);
        make.height.offset(40*proportionH);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verificationTextField.mas_bottom).offset(12*proportionH);
    }];
    
    [self.view addSubview:self.againPassTextField];
    [self.againPassTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(280*proportionW);
        make.height.offset(40*proportionH);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(12*proportionH);
    }];
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn SetBtnTitle:@"注册" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(registerBtnAction) andAddVC:self];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 5;
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(45);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.againPassTextField.mas_bottom).offset(35*proportionW);
    }];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn SetBtnTitle:@"去登录" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?11:13) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(cod_returnAction) andAddVC:self];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerBtn).offset(140*proportionW);
        make.top.equalTo(registerBtn.mas_bottom).offset(15*proportionW);
    }];
    
    UILabel* noLabel = [[UILabel alloc] init];
    [noLabel SetlabTitle:@"已有账号？" andFont:kFont(IS_IPHONE_5?11:13) andTitleColor:[UIColor grayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:noLabel];
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn.mas_left);
        make.centerY.equalTo(loginBtn);
    }];
    
    UIButton* protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolBtn SetBtnTitle:@"《益家网用户协议》" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?11:13) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(protocolBtnAction) andAddVC:self];
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-20*proportionW);
    }];
    
    UILabel* shuoLabel = [[UILabel alloc] init];
    [shuoLabel SetlabTitle:@"点击注册代表您同意" andFont:kFont(IS_IPHONE_5?11:13) andTitleColor:[UIColor grayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil];
    [self.view addSubview:shuoLabel];
    [shuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(protocolBtn);
    }];
}

- (UIButton *)GetYZMBtn
{
    if (!_GetYZMBtn) {
        _GetYZMBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_GetYZMBtn SetBtnTitle:@"获取动态验证码" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?13:15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(GetYZMBtnClicked:) andAddVC:self];
        
    } return _GetYZMBtn;
}

-(void)protocolBtnAction {
    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

//注册
-(void)registerBtnAction {
    if (self.telNumTextField.text.length == 0) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入手机号"];
        return;
    }
    if (![self.telNumTextField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入正确格式的手机号"];
        return;
    }
    if (self.verificationTextField.text.length == 0) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入验证码"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入密码"];
        return;
    }
    if (![self.againPassTextField.text isEqualToString:self.passwordTextField.text]) {
         [SVProgressHUD cod_showWithErrorInfo:@"确认密码不一致,请核对后提交"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.telNumTextField.text;
    params[@"code"] = self.verificationTextField.text;
    params[@"password"] = self.passwordTextField.text;
    params[@"password_confirm"] = self.againPassTextField.text;
    
    [SVProgressHUD cod_showWithStatu:@"注册中..."];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=reg" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
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
        [SVProgressHUD cod_showWithErrorInfo:@"请输入手机号"];
        return;
    }
    if (![self.telNumTextField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入正确格式的手机号"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.telNumTextField.text;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=get_code" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [sender startWithTime:60 title:@"重新获取验证码" countDownTitle:@"秒" mainColor:[UIColor clearColor] countColor:[UIColor clearColor]];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
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
    if (textField == self.passwordTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    if (textField == self.againPassTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
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
