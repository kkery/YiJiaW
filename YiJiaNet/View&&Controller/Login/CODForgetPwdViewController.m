//
//  CODForgetPwdViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODForgetPwdViewController.h"

@interface CODForgetPwdViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField* telNumTextField;
@property(nonatomic,strong) UITextField* verificationTextField;
@property(nonatomic,strong) UITextField* passwordTextField;
@property(nonatomic,strong) UITextField* againPassTextField;

/** 获取验证码 */
@property(nonatomic,strong) UIButton *GetYZMBtn;

@end

@implementation CODForgetPwdViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"忘记密码";
    
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
    [registerBtn SetBtnTitle:@"确定" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(registerBtnAction) andAddVC:self];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 5;
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(45);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.againPassTextField.mas_bottom).offset(35*proportionW);
    }];
    
    
}

- (UIButton *)GetYZMBtn
{
    if (!_GetYZMBtn) {
        _GetYZMBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_GetYZMBtn SetBtnTitle:@"获取动态验证码" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?13:15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(GetYZMBtnClicked:) andAddVC:self];
        
    } return _GetYZMBtn;
}

-(void)registerBtnAction {
    
//    if (self.telNumTextField.text.length > 0) {
//        if (self.verificationTextField.text.length > 0) {
//            if (self.passwordTextField.text.length > 5) {
//                if ([self.againPassTextField.text isEqualToString:self.passwordTextField.text]) {
//                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                    params[@"mobile"] = self.telNumTextField.text;
//                    params[@"code"] = self.verificationTextField.text;
//                    params[@"password"] = self.passwordTextField.text;
//                    params[@"confirm_password"] = self.againPassTextField.text;
//                    [self showLoading];
//                    [[LXGNetWorkQuery shareManager] AFrequestData:@"10004" HttpMethod:@"POST" params:params completionHandle:^(id result) {
//                        NSLog(@"----10004: %@",result);
//                        [self dismissLoading];
//
//                        if (kMessage(result)) {
//                            [self showSuccessText:@"修改成功"];
//
//                            [self.navigationController popViewControllerAnimated:YES];
//                        } else {
//                            [self showErrorText:result[@"status"][@"message"]];
//                        }
//                    } errorHandle:^(NSError *result) {
//                        [self showErrorText:@"网络异常，请重试!"];
//                        NSLog(@"===Error: %@",result);
//                    }];
//
//                } else {
//                    [self showErrorText:@"两次输入的密码不一致"];
//                }
//
//            } else {
//                [self showErrorText:@"密码长度不少于6个字符"];
//            }
//
//        } else {
//            [self showErrorText:@"请输入验证码"];
//        }
//
//    } else {
//        [self showErrorText:@"请输入手机号码"];
//    }
}

-(void)GetYZMBtnClicked:(UIButton*)sender
{
//    if (self.telNumTextField.text.length <= 0) {
//        [self showErrorText:@"请输入手机号码"];
//    } else {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"mobile"] = self.telNumTextField.text;
//        [self showLoading];
//        [[LXGNetWorkQuery shareManager] AFrequestData:@"10002" HttpMethod:@"POST" params:params completionHandle:^(id result) {
//            NSLog(@"----10002: %@",result);
//            [self dismissLoading];
//
//            if (kMessage(result)) {
//                [sender startWithTime:60 title:@"重新获取验证码" countDownTitle:@"秒" mainColor:[UIColor clearColor] countColor:[UIColor clearColor]];
//            }else
//            {
//                [self showErrorText:@"获取失败!"];
//            }
//        } errorHandle:^(NSError *result) {
//            [self showErrorText:@"网络异常，请重试!"];
//            NSLog(@"===Error: %@",result);
//        }];
//    }
}

#pragma mark - 输入框的代理实现 UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
