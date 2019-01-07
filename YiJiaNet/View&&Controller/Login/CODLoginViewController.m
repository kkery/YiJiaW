//
//  CODLoginViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODLoginViewController.h"
#import "CODRegistViewController.h"
#import "CODForgetPwdViewController.h"
#import "NSString+COD.h"
//#import "CYHForgetPassViewController.h"

//#import "XWXBindingMobileViewController.h" // 去绑定手机号
//#import <UMSocialCore/UMSocialCore.h>  // 友盟第三方登录
//#import "JPUSHService.h" // 极光推送

@interface CODLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIView* lineView;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) NSMutableArray* scrArray;
@property(nonatomic,assign) NSInteger index;

@property(nonatomic,strong) UITextField* telNumTextField;
@property(nonatomic,strong) UITextField* passwordTextField;
@property(nonatomic,strong) UITextField* verificationTextField;

/** 微信登录 */
@property(nonatomic,strong) UIButton* weiChatBtn;
/** qq登录 */
@property(nonatomic,strong) UIButton* qqChatFuBtn;
/** 获取验证码 */
@property(nonatomic,strong) UIButton *GetYZMBtn;

@end

@implementation CODLoginViewController

-(NSMutableArray *)scrArray{
    if (!_scrArray) {
        _scrArray=[[NSMutableArray alloc]init];
    }
    return _scrArray;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(35*proportionW,33*proportionH, 90*proportionW, 1.5)];
        _lineView.backgroundColor = CODColorTheme;
        
    }return _lineView;
}

-(UIView *)backView
{
    if (!_backView) {
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*proportionH, SCREENWIDTH, 40*proportionH)];
        _backView.backgroundColor = [UIColor whiteColor];
        
        NSArray* titleArr = @[@"账号密码登录",@"手机号快捷登录"];
        for (int i=0; i<2; i++) {
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(SCREENWIDTH/2*i, 0, SCREENWIDTH/2,40*proportionH);
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:IS_IPHONE_5?13:15];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:CODColorTheme forState:UIControlStateSelected];
            btn.tag=10+i;
            _index = 10;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
            }
            //        将btn保存在数组中，以便遍历
            [self.scrArray addObject:btn];
            
        }
        
    }return _backView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115*proportionH, SCREENWIDTH, KPad?200*proportionH:170*proportionH)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*2, KPad?200*proportionH:170*proportionH);
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        //    设置代理
        _scrollView.delegate=self;
        
    }return _scrollView;
}

-(UIButton *)weiChatBtn {
    if (!_weiChatBtn) {
        _weiChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiChatBtn.tag = 100;
        [_weiChatBtn SetBtnTitle:nil andTitleColor:nil andFont:nil andBgColor:[UIColor whiteColor] andBgImg:nil andImg:kGetImage(@"login_wx") andClickEvent:@selector(SDKLoginBtnClicked:) andAddVC:self];
    }return _weiChatBtn;
}

-(UIButton *)qqChatFuBtn {
    if (!_qqChatFuBtn) {
        _qqChatFuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqChatFuBtn.tag = 101;
        [_qqChatFuBtn SetBtnTitle:nil andTitleColor:nil andFont:nil andBgColor:nil andBgImg:nil andImg:kGetImage(@"login_qq") andClickEvent:@selector(SDKLoginBtnClicked:) andAddVC:self];
    }return _qqChatFuBtn;
}

-(UITextField *)telNumTextField
{
    if (!_telNumTextField) {
        _telNumTextField = [[UITextField alloc]init];
        [_telNumTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入手机号码"];
        _telNumTextField.tintColor = CODColorTheme;
        _telNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _telNumTextField.tag = 3;
        _telNumTextField.delegate = self;
        _telNumTextField.backgroundColor = [UIColor clearColor];
        [_telNumTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_username"] andSize:[UIImage imageNamed:@"login_username"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        
    }return _telNumTextField;
}

-(UITextField *)passwordTextField {
    
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        [_passwordTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入密码"];
        _passwordTextField.tintColor = CODColorTheme;
        _passwordTextField.tag = 4;
        _passwordTextField.secureTextEntry=YES;
        _passwordTextField.delegate = self;
        _passwordTextField.backgroundColor = [UIColor clearColor];
        [_passwordTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_paddword"] andSize:[UIImage imageNamed:@"login_paddword"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        
    }return _passwordTextField;
}

-(UITextField *)verificationTextField {
    
    if (!_verificationTextField) {
        _verificationTextField = [[UITextField alloc]init];
        [_verificationTextField SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(IS_IPHONE_5?13:15) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入验证码"];
        _verificationTextField.delegate = self;
        _verificationTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verificationTextField.tag = 5;
        _verificationTextField.tintColor = CODColorTheme;
        _verificationTextField.backgroundColor = [UIColor clearColor];
        [_verificationTextField quickSetLeftViewWithImg:[UIImage imageNamed:@"login_code"] andSize:[UIImage imageNamed:@"login_code"].size andLeftVWSize:CGSizeMake(35*proportionW, 40*proportionH)];
        
    }return _verificationTextField;
}

- (UIButton *)GetYZMBtn
{
    if (!_GetYZMBtn) {
        _GetYZMBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_GetYZMBtn SetBtnTitle:@"获取动态验证码" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?13:15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(GetYZMBtnClicked:) andAddVC:self];
        
    } return _GetYZMBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"登录";
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.lineView];
    
    [self.view addSubview:self.scrollView];
    
    
    [self CreateView];
    
}

-(void)CreateView {
    
    //输入手机号码
    [self.view addSubview:self.telNumTextField];
    [self.telNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(280*proportionW);
        make.height.offset(40*proportionH);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.backView.mas_bottom).offset(12*proportionH);
    }];
    UIView* telLineView = [[UIView alloc] init];
    telLineView.backgroundColor = kSepLineColor;
    [self.view addSubview:telLineView];
    [telLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(0.8);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.telNumTextField.mas_bottom).offset(4*proportionH);
    }];
    
    
    //输入密码
    UIView* passLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, KPad?200*proportionH:170*proportionH)];
    passLoginView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:passLoginView];
    
    [passLoginView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(280*proportionW);
        make.height.offset(40*proportionH);
        make.centerX.equalTo(passLoginView);
        make.top.equalTo(passLoginView);
    }];
    UIView* passLineView = [[UIView alloc] init];
    passLineView.backgroundColor = kSepLineColor;
    [passLoginView addSubview:passLineView];
    [passLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(0.8);
        make.centerX.equalTo(passLoginView);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(4*proportionH);
    }];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn SetBtnTitle:@"登录" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(loginBtnAction:) andAddVC:self];
    loginBtn.tag = 102;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5;
    [passLoginView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(45);
        make.centerX.equalTo(passLoginView);
        make.top.equalTo(passLoginView).offset(78*proportionW);
    }];
    
    UIButton* forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn SetBtnTitle:@"忘记密码？" andTitleColor:[UIColor grayColor] andFont:kFont(IS_IPHONE_5?11:13) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(forgerBtnAction) andAddVC:self];
    [passLoginView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(13*proportionW);
    }];
    
    UIButton* registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registeredBtn SetBtnTitle:@"去注册" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?11:13) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(registeredBtnAction) andAddVC:self];
    [passLoginView addSubview:registeredBtn];
    [registeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn);
        make.top.equalTo(loginBtn.mas_bottom).offset(13*proportionW);
    }];
    
    UILabel* noLabel = [[UILabel alloc] init];
    [noLabel SetlabTitle:@"还没有账号？" andFont:kFont(IS_IPHONE_5?11:13) andTitleColor:[UIColor grayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil];
    [passLineView addSubview:noLabel];
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(registeredBtn.mas_left);
        make.centerY.equalTo(registeredBtn);
    }];
    
    
    //输入验证码
    UIView* tleLoginView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, KPad?200*proportionH:170*proportionH)];
    tleLoginView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:tleLoginView];
    
    [tleLoginView addSubview:self.GetYZMBtn];
    [self.GetYZMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100*proportionH);
        make.height.offset(40*proportionH);
        make.right.equalTo(tleLoginView).offset(-25*proportionW);
        make.top.equalTo(tleLoginView);
    }];
    
    
    [tleLoginView addSubview:self.verificationTextField];
    [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(170*proportionW);
        make.height.offset(40*proportionH);
        make.left.equalTo(tleLoginView).offset(20*proportionW);
        make.top.equalTo(tleLoginView);
    }];
    UIView* verifiLineView = [[UIView alloc] init];
    verifiLineView.backgroundColor = kSepLineColor;
    [tleLoginView addSubview:verifiLineView];
    [verifiLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(0.8);
        make.centerX.equalTo(tleLoginView);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(4*proportionH);
    }];
    UIButton* loginBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn2 SetBtnTitle:@"登录" andTitleColor:[UIColor whiteColor] andFont:kFont(IS_IPHONE_5?13:15) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(loginBtnAction:) andAddVC:self];
    loginBtn2.tag = 103;
    loginBtn2.layer.masksToBounds = YES;
    loginBtn2.layer.cornerRadius = 5;
    [tleLoginView addSubview:loginBtn2];
    [loginBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(45);
        make.centerX.equalTo(tleLoginView);
        make.top.equalTo(tleLoginView).offset(78*proportionW);
    }];
    
    UIButton* registeredBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [registeredBtn1 SetBtnTitle:@"去注册" andTitleColor:CODColorTheme andFont:kFont(IS_IPHONE_5?11:13) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(registeredBtnAction) andAddVC:self];
    [tleLoginView addSubview:registeredBtn1];
    [registeredBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginBtn2);
        make.top.equalTo(loginBtn2.mas_bottom).offset(13*proportionW);
    }];
    
    UILabel* noLabel1 = [[UILabel alloc] init];
    [noLabel1 SetlabTitle:@"还没有账号？" andFont:kFont(IS_IPHONE_5?11:13) andTitleColor:[UIColor grayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil];
    [tleLoginView addSubview:noLabel1];
    [noLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(registeredBtn1.mas_left);
        make.centerY.equalTo(registeredBtn1);
    }];
    
    
    
    //第三方登录
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(260*proportionW);
        make.height.offset(0.5);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-115*proportionH);
    }];
    
    UILabel* loginTypeLabel = [[UILabel alloc] init];
    loginTypeLabel.text = @"其他方式登录";
    loginTypeLabel.textAlignment = NSTextAlignmentCenter;
    loginTypeLabel.textColor = [UIColor grayColor];
    loginTypeLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?11:13];
    loginTypeLabel.backgroundColor = [UIColor whiteColor];
    [lineView addSubview:loginTypeLabel];
    [loginTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90*proportionW);
        make.centerX.equalTo(lineView);
        make.centerY.equalTo(lineView);
    }];
    
    [self.view addSubview:self.weiChatBtn];
    [self.weiChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(27*proportionW);
        make.height.offset(22*proportionH);
        make.top.equalTo(loginTypeLabel.mas_bottom).offset(20*proportionH);
        make.centerX.equalTo(self.view).offset(-50*proportionW);
    }];
    UILabel* weiChatLabel = [[UILabel alloc] init];
    weiChatLabel.text = @"微信";
    weiChatLabel.textColor = [UIColor grayColor];
    weiChatLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?11:13];
    [self.view addSubview:weiChatLabel];
    [weiChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weiChatBtn);
        make.top.equalTo(self.weiChatBtn.mas_bottom).offset(20*proportionH);
    }];
    
    
    
    [self.view addSubview:self.qqChatFuBtn];
    [self.qqChatFuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(27*proportionW);
        make.height.offset(22*proportionH);
        make.top.equalTo(loginTypeLabel.mas_bottom).offset(20*proportionH);
        make.centerX.equalTo(self.view).offset(50*proportionW);
    }];
    UILabel* qqChatLabel = [[UILabel alloc] init];
    qqChatLabel.text = @"QQ";
    qqChatLabel.textColor = [UIColor grayColor];
    qqChatLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?11:13];
    [self.view addSubview:qqChatLabel];
    [qqChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqChatFuBtn);
        make.top.equalTo(self.qqChatFuBtn.mas_bottom).offset(20*proportionH);
    }];
}


#pragma mark - Action
-(void)GetYZMBtnClicked:(UIButton*)sender
{
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

-(void)forgerBtnAction {
    
    CODForgetPwdViewController* forgetVC = [[CODForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

-(void)registeredBtnAction {
    
    CODRegistViewController* regisVC = [[CODRegistViewController alloc] init];
    [self.navigationController pushViewController:regisVC animated:YES];
    
}

-(void)loginBtnAction:(UIButton*)sender {
    if (self.telNumTextField.text.length == 0) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入手机号"];
        return;
    }
    if (![self.telNumTextField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入正确格式的手机号"];
        return;
    }
    
    if (sender.tag == 102) {
        if (self.passwordTextField.text.length == 0) {
            [SVProgressHUD cod_showWithErrorInfo:@"请输入密码"];
            return;
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.telNumTextField.text;
        params[@"password"] = self.passwordTextField.text;
        params[@"type"] = @"1";
        
        [SVProgressHUD cod_showStatu];
        [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=login" andParameters:params Sucess:^(id object) {
            [SVProgressHUD cod_dismis];
            if ([object[@"code"] integerValue] == 200) {
                [SVProgressHUD cod_showWithSuccessInfo:@"登录成功"];
                
                save(object[@"data"][@"user_id"], CODLoginTokenKey);
                
                [kNotiCenter postNotificationName:CODLoginNotificationName object:nil userInfo:nil];
                
//                [self loadUserInfo];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
        }];
    }
    else {
        if (self.verificationTextField.text.length == 0) {
            [SVProgressHUD cod_showWithErrorInfo:@"请输入验证码"];
            return;
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.telNumTextField.text;
        params[@"code"] = self.verificationTextField.text;
        params[@"type"] = @"2";
        [SVProgressHUD cod_showStatu];
        
        [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=login" andParameters:params Sucess:^(id object) {
            if ([object[@"code"] integerValue] == 200) {
                [SVProgressHUD cod_showWithSuccessInfo:@"登录成功"];
                
                save(object[@"data"][@"user_id"], CODLoginTokenKey);
                
                [kNotiCenter postNotificationName:CODLoginNotificationName object:nil userInfo:nil];
                
//                [self loadUserInfo];
                if (self.loginBlock) {
                    self.loginBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:CODLoginCompletionNotificationName object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
        }];
    }
}


-(void)loadUserInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=user_info" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            save(object[@"data"][@"user_id"], CODLoginTokenKey);
            
            [kNotiCenter postNotificationName:CODLoginNotificationName object:nil userInfo:nil];
            [self loadUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - 第三方登录
-(void)SDKLoginBtnClicked:(UIButton*)sender
{
//    if (sender.tag == 101) {
//        // QQ
//        [self getUserInfoForPlatform:UMSocialPlatformType_QQ withType:@"1"];
//    } else if (sender.tag == 100) {
//        // 微信
//        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession withType:@"2"];
//    }
    
}

//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType withType:(NSString *)type
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//
//        NSString *message = nil;
//        if (error) {
//            message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
//            UMSocialLogInfo(@"Get info fail with error %@",error);
//            NSLog(@"error = %@",error);
//        }else{
//            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
//                UMSocialUserInfoResponse *resp = result;
//                // 第三方登录数据(为空表示平台未提供)
//                // 授权数据
//                NSLog(@" uid: %@", resp.uid);
//                NSLog(@" openid: %@", resp.openid);
//                NSLog(@" accessToken: %@", resp.accessToken);
//                NSLog(@" refreshToken: %@", resp.refreshToken);
//                NSLog(@" expiration: %@", resp.expiration);
//                // 用户数据
//                NSLog(@" name: %@", resp.name);
//                NSLog(@" iconurl: %@", resp.iconurl);
//                NSLog(@" gender: %@", resp.unionGender);
//                // 第三方平台SDK原始数据
//                NSLog(@" originalResponse: %@", resp.originalResponse);
//                message = kFORMAT(@"%@",resp.openid);
//                if (message) {
//                    NSMutableDictionary* paramsL = [[NSMutableDictionary alloc]init];
//                    paramsL[@"openid"] = message;
//                    paramsL[@"authtype"] = type;
//                    NSMutableDictionary *params = [NSMutableDictionary new];
//                    params[@"head"] = resp.iconurl;
//                    params[@"openid"] = message;
//                    params[@"authtype"] = type;
//                    params[@"nickname"] = resp.name;
//                    [self UMLoginLoat:paramsL withDic:params];
//                }else {
//                    [SVProgressHUD showErrorWithStatus:@"授权登录失败"];
//                }
//
//            }else{
//                message = @"Get info fail";
//            }
//        }
//
//    }];
//
//}
//
//-(void)UMLoginLoat:(NSMutableDictionary *)paramsL withDic:(NSMutableDictionary *)params
//{
//    [[LXGNetWorkQuery shareManager] AFrequestData:@"11025" HttpMethod:@"POST" params:paramsL completionHandle:^(id result) {
//        if (kMessage(result)) {
//
//            if ([kFORMAT(@"%@",result[@"data"][@"is_bind"]) isEqualToString:@"0"]) {
//                // 未绑定手机号
//                XWXBindingMobileViewController *Vw = [XWXBindingMobileViewController new];
//                Vw.Dic = params;
//                [self.navigationController pushViewController:Vw animated:YES];
//            } else {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    //异步线程处理数据
//                    // 极光推送设置别名
//                    [JPUSHService setAlias:kFORMAT(@"%@",result[@"data"][@"mobile"]) completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                        NSLog(@"别名设置-------------%@",iAlias);
//                    } seq:1];
//
//                    // 保存登录标识
//                    [[NSUserDefaults standardUserDefaults] setObject:result[@"data"][@"user_id"] forKey:@"login_credentials"];
//                    [kNotiCenter postNotificationName:@"logoinRefresh" object:nil userInfo:nil];
//                    [self loadDataSource];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //回到主线程更新UI 去切换window根视图
//                        [self.navigationController popViewControllerAnimated:YES];
//                        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    });
//                });
//            }
//
//        }else{
//            [self showErrorText:result[@"status"][@"message"]];
//        }
//    }errorHandle:^(NSError *result) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
//
//}
//

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat point = scrollView.contentOffset.x;
    [self createBtnScroll:point/SCREENWIDTH+10 isScroll:NO];
}

-(void)btnAction:(UIButton*)sender
{
    //    将btn按钮事件封装以便scrollview 调用
    [self createBtnScroll:sender.tag isScroll:YES];
    
}

-(void)createBtnScroll:(NSUInteger)senderTag isScroll:(BOOL )scroll
{
    //    采用枚举便利可更好的控制停止遍历
    [self.scrArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        idx += 10;
        
        if (idx == senderTag) {
            obj.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
                //                移动其中心点
                self.lineView.centerX = obj.centerX;
                if (scroll == YES) {
                    self.scrollView.contentOffset=CGPointMake((idx-10)*SCREENWIDTH, 0);
                }
            }];
        } else {
            obj.selected =NO;
        }
        
    }];
}

#pragma mark - 导航栏的返回按钮 Click Event
-(void)NavAllBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
    if (textField == (UITextField*)[self.view viewWithTag:3]) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    if (textField == (UITextField*)[self.view viewWithTag:4]) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    if (textField == (UITextField*)[self.view viewWithTag:5]) {
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

#pragma mark- 界面即将出现的时候清除第三方登录信息
-(void)viewWillAppear:(BOOL)animated {
    
//    [self cleanData:UMSocialPlatformType_QQ];
//    [self cleanData:UMSocialPlatformType_WechatSession];
}

#pragma mark - 清除登录消息
//- (void)cleanData:(UMSocialPlatformType)platformType{
//
//    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
//
//    }];
//
//}

@end
