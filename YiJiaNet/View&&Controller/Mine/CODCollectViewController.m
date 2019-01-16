//
//  CODCollectViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/5.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCollectViewController.h"
#import "CODCompanyListViewController.h"
#import "CODNewHouseViewController.h"

@interface CODCollectViewController ()

@property(nonatomic,strong) NSArray *titlesArr;
@property(nonatomic,strong) UIButton *editButton;

@end

@implementation CODCollectViewController

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
    self.title = @"我的收藏";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_app_return"] style:UIBarButtonItemStyleDone target:self action:@selector(cod_returnAction)];
    [self wr_setNavBarShadowImageHidden:NO];
}

- (void)cod_returnAction {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)editClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSDictionary *dict = @{@"key":sender};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editNotification" object:nil userInfo:dict];
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
        CODCompanyListViewController *childVC = [[CODCompanyListViewController alloc] init];
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
