//
//  CODAuthenStatusViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/4.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODAuthenStatusViewController.h"
#import "CODAuthenViewController.h"

@interface CODAuthenStatusViewController ()

@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UIImageView *statusImageView;
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UILabel *reasonLabel;
@property(nonatomic,strong) UIButton *actionButton;
@property(nonatomic,strong) UIButton *returnBtn;

@end

@implementation CODAuthenStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CODRgbColor(246, 252, 254);
    
    self.headerImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    [self.view addSubview:self.headerImageView];
    
    self.returnBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"nav_app_return"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cod_returnAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.headerImageView addSubview:self.returnBtn];

    self.statusImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    [self.view addSubview:self.statusImageView];
    
    self.statusLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CODColor333333;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:self.statusLabel];
    
    self.reasonLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CODColor999999;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self.view addSubview:self.reasonLabel];
    
    self.actionButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:CODColorTheme forState:UIControlStateNormal];
        [button setTitle:@"确  定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.actionButton];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@330);
    }];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.headerImageView).offset(30);
        make.left.equalTo(self.headerImageView).offset(15);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(94, 95));
        make.centerX.offset(0);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
//        make.top.equalTo(self.headerImageView.mas_top).offset(10);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(50);
        make.centerX.offset(0);
        make.height.equalTo(@20);
    }];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10);
        make.centerX.offset(0);
    }];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.height.equalTo(@44);
        make.left.offset(40);
        make.right.offset(-40);
    }];
    [self configureWithData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithData {
    UIImage *headImage;
    UIImage *statusImage;
    NSString *describe;
    NSString *reason;
    NSString *buttonValue = @"";
    UIColor *color = CODColorTheme;
    UIColor *backColor = CODRgbColor(246, 252, 254);
    // 0认证中 1成功 2失败 3未认证
    if (self.status == 0) {
        headImage = kGetImage(@"apply_merchants_review_bg");
        statusImage = kGetImage(@"apply_merchants_review_icon");
        describe = @"提交审核中，请等待管理员审核";
        reason = @"预计1-3个工作日内审核完毕\n请随时关注本页面";
        buttonValue = @"";
    } else if (self.status == 1) {
        headImage = kGetImage(@"apply_merchants_review_bg");
        statusImage = kGetImage(@"apply_merchants_success_icon");
        describe = @"恭喜您!实名认证成功";
        reason = @"经核实您提交的资料已通过";
        color = CODHexColor(0xF96812);
        buttonValue = @"确  定";
    } else if (self.status == 2) {
        headImage = kGetImage(@"apply_merchants_failure_bg");
        statusImage = kGetImage(@"apply_merchants_failure_icon");
        describe = @"很抱歉，你的审核未通过";
        reason = @"抱歉，您的资料信息存在不符\n请重新核实后再申请";
        color = CODHexColor(0xF96812);
        buttonValue = @"重新申请";
        backColor = CODRgbColor(255, 248, 248);
    } 
    
    self.headerImageView.image = headImage;
    self.statusImageView.image = statusImage;
    self.statusLabel.text = describe;
    self.reasonLabel.text = reason;

    self.actionButton.hidden = kStringIsEmpty(buttonValue);
    [self.actionButton setTitle:buttonValue forState:UIControlStateNormal];
    [self.actionButton setTitleColor:color forState:UIControlStateNormal];
    [self.actionButton SetLayWithCor:22 andLayerWidth:1 andLayerColor:color];
    
    self.view.backgroundColor = backColor;
}

- (void)btnAction {
    if (self.status == 2) {// 重新认证 进入认证界面
        CODAuthenViewController *authenVC = [[CODAuthenViewController alloc] init];
        [self.navigationController pushViewController:authenVC animated:YES];
    } else {
        [self cod_returnAction];
    }
}

@end
