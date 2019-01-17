//
//  CODComentSuccViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/17.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODComentSuccViewController.h"

@interface CODComentSuccViewController ()

@end

@implementation CODComentSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价成功";
    self.view.backgroundColor = [UIColor whiteColor];
    [self wr_setNavBarShadowImageHidden:NO];

    
    UIImageView *imgeV = [[UIImageView alloc] initWithImage:kGetImage(@"evaluation_successful")];
    imgeV.size = CGSizeMake(75, 75);
    imgeV.top = 70;
    imgeV.centerX = 0;
    [self.view addSubview:imgeV];
    [imgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.offset(50);
        make.centerX.offset(0);
    }];
    
    UILabel *titLab = [UILabel GetLabWithFont:kFont(17) andTitleColor:CODColor333333 andTextAligment:1 andBgColor:nil andlabTitle:@"评价成功"];
    [self.view addSubview:titLab];
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgeV.mas_bottom).offset(15);
        make.centerX.offset(0);
    }];
    
    UIButton *btn = [UIButton GetBtnWithTitleColor:CODColorTheme andFont:kFont(15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(backRoot) andAddVC:self andTitle:@"返回首页"];
    [btn SetLayWithCor:19 andLayerWidth:1 andLayerColor:CODColorTheme];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SCREENHEIGHT/2-20);
        make.centerX.offset(0);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
