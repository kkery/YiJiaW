//
//  CODFirstBindViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/22.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODFirstBindViewController.h"
#import "NSString+COD.h"

@interface CODFirstBindViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField* telNumTextField;
@property(nonatomic,strong) UITextField* verificationTextField;

/** 获取验证码 */
@property(nonatomic,strong) UIButton *GetYZMBtn;

@end

@implementation CODFirstBindViewController

-(UITextField *)telNumTextField
{
    if (!_telNumTextField) {
        _telNumTextField = [[UITextField alloc]init];
        [_telNumTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入手机号码"];
        _telNumTextField.tintColor = CODColorTheme;
        _telNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _telNumTextField.backgroundColor = [UIColor clearColor];
        [_telNumTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_username"] andSize:[UIImage imageNamed:@"login_username"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        _telNumTextField.delegate = self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"绑定手机号";
    
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
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn SetBtnTitle:@"确定" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(confimBtnAction) andAddVC:self];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 5;
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(45);
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

-(void)confimBtnAction {
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
    
    [SVProgressHUD cod_showStatu];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.telNumTextField.text;
    params[@"code"] = self.verificationTextField.text;
    params[@"password"] = @"";
    params[@"repassword"] = @"";
    
    if (self.response.platformType == UMSocialPlatformType_QQ) {
        params[@"authtype"] = @"2";//1：微信 2：QQ
    } else {
        params[@"authtype"] = @"1";
    }
    params[@"openid"] = self.response.openid;
    params[@"avatar"] = self.response.iconurl;
    params[@"nickname"] = self.response.name;
    params[@"have_pwd"] = @"";
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=auth_reg" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            [kNotiCenter postNotificationName:CODLoginNotificationName object:nil userInfo:nil];
            save(object[@"data"][@"user_id"], CODLoginTokenKey);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD cod_showWithSuccessInfo:@"登录成功"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            });
            
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

-(void)GetYZMBtnClicked:(UIButton*)sender
{
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

#pragma mark - 输入框的代理实现 UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

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
