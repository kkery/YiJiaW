//
//  CODHistoryViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/5.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODHistoryViewController.h"
#import "CODHisCompChildController.h"
#import "CODNewHouseViewController.h"

@interface CODHistoryViewController ()

@property(nonatomic,strong) NSArray *titlesArr;
@property(nonatomic,strong) UIButton *editButton;

@property(nonatomic,assign) NSInteger curentIndex;

@end

@implementation CODHistoryViewController

- (instancetype)init {
    if(self = [super init]) {
        self.titlesArr = @[@"装修公司",@"新房",@"二手房",@"长租房"];
        self.selectIndex = 0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressColor = CODColorTheme;
        self.titleColorNormal = CODColor333333;
        self.titleColorSelected = CODColorTheme;
        self.progressViewIsNaughty = YES;
        self.progressHeight = 3;
        self.progressWidth = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的足迹";
    [self wr_setNavBarShadowImageHidden:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_app_return"] style:UIBarButtonItemStyleDone target:self action:@selector(cod_returnAction)];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itmWithTitle:@"清空足迹" SelectTitle:@"清空足迹" Font:XFONT_SIZE(14) textColor:CODColor333333 selectedTextColor:CODColor333333 target:self action:@selector(deleteAction)];

//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [editBtn setTitle:@"清空足迹" forState:UIControlStateNormal];
//    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [editBtn setTitleColor:CODColor333333 forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
//    editBtn.size = CGSizeMake(80, 44);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
//    self.editButton = editBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //YES,透明效果view不会偏移 NO,导航栏不透明,view会向下偏移64px
    self.navigationController.navigationBar.translucent = YES;
}

- (void)cod_returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Action
-(void)deleteAction {
    [self showAlertWithTitle:@"确定清空足迹吗" andMesage:nil andCancel:^(id cancel) {
    } Determine:^(id determine) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = COD_USERID;
        params[@"type"] = @(self.selectIndex+1);
        [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=Setting&a=delete" andParameters:params Sucess:^(id object) {
            if ([object[@"code"] integerValue] == 200) {
                [SVProgressHUD cod_showWithSuccessInfo:@"清空足迹成功"];
                [kNotiCenter postNotificationName:CODDeleteHistotyNotificationName object:nil userInfo:nil];
            } else {
                [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray<NSString *> *)titles {
    return self.titlesArr;
}

#pragma mark - WMPageControllerDataSource
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSString *titles = self.titles[index];
    if ([titles isEqualToString:@"装修公司"]) {
        CODHisCompChildController *childVC = [[CODHisCompChildController alloc] init];
        return childVC;
    } else {
        CODNewHouseViewController *childVC = [[CODNewHouseViewController alloc] init];
        return childVC;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, KTabBarNavgationHeight, SCREENWIDTH, 45);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

#pragma mark - WMMenuViewDataSource
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

@end
