//
//  CODDecorateViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODFindDecorateViewController.h"
#import "AutoScrollLabel.h"
#import "UIButton+COD.h"
#import "UIButton+ButtonQuickInit.h"
#import "UIViewController+COD.h"
#import "SDCycleScrollView.h"
#import "HomeFourItemView.h"
#import "HomeLeftRightView.h"
#import "CODAnnouncementCell.h"
#import "CODExampleTableViewCell.h"
#import "CODSecondHorseViewController.h"
#import "CODNewHorseViewController.h"
#import "SwitchCityViewController.h"
#import "CODCalcuQuoteViewController.h"
#import "CODEffectPicViewController.h"
#import "CODHotViewController.h"
#import "CODExamDetailViewController.h"
#import "CODMessageViewController.h"
#import "CODIntrinsicTitleView.h"
#import "NSString+COD.h"
#import "CQPlaceholderView.h"

#import "DecorateFourItemView.h"
#import "DecorateConditionView.h"
#import "CODDecorateTableViewCell.h"
#import "HPSearchViewController.h"
#import "CODCompanyDetailViewController.h"
#import "CODAllDecorateViewController.h"
static CGFloat const kBannerRadio = 375 / 751.0;// 广告图片比例
static CGFloat const kPadding = 12;

static CGFloat const kTopHeight = 240;
static CGFloat const kFourItemHeight = 80;
static CGFloat const kBannerHeight = 140;


static NSString * const kCODDecorateTableViewCell = @"CODDecorateTableViewCell";

@interface CODFindDecorateViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UIView *CityVw;
//@property(nonatomic,strong) AutoScrollLabel *cityBtn;

@property (nonatomic, strong) CODIntrinsicTitleView *titleView;// 标题视图

@property (nonatomic, strong) UIView *searchView;// 搜索视图
@property (nonatomic, strong) UILabel *searchTextLable;// 搜索视图;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) DecorateFourItemView *decorateFourItemView;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, strong) DecorateConditionView *conditionTitleView;


@end

@implementation CODFindDecorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找装修";
    
    [self configureNavgationView];
    [self configureView];
    
    [self loadData];
    
}

- (void)loadData {
    // 假数据
    self.dataArray = @[@{@"icon":@"http://www.nczyzs.com/images/kt_699.jpg"}, @{@"icon":@""}, @{@"icon":@"http://www.nczyzs.com/images/699_ws.jpg"}, @{@"icon":@""}, @{@"icon":@""}, @{@"icon":@""}, @{@"icon":@""}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}
#pragma mark - View
- (void)configureNavgationView {
    
    self.titleView = [[CODIntrinsicTitleView alloc] init];
    self.titleView.frame = CGRectMake(0, 0, SCREENWIDTH, CODNavigationBarHeight);
    self.navigationItem.titleView = self.titleView;
    
    self.searchView = ({
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 14;
        view.backgroundColor = CODColorBackground;
        [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self searchAction];
        }];
        view;
    });
    [self.titleView addSubview:self.searchView];
    
    UIImageView *imag = [[UIImageView alloc] init];
    imag.image = kGetImage(@"search_icon_search");
    [self.searchView addSubview:imag];
    
    [imag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 14));
        make.centerY.equalTo(self.titleView);
        make.left.equalTo(@10);
    }];
    
    self.searchTextLable = ({
        UILabel *label = [UILabel GetLabWithFont:XFONT_SIZE(13) andTitleColor:[UIColor lightGrayColor] andTextAligment:0 andBgColor:nil andlabTitle:@"请输入装修公司"];
        label.backgroundColor = CODColorBackground;
        label;
    });
    [self.searchView addSubview:self.searchTextLable];
    
    self.callBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"home_top_service"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.titleView addSubview:self.callBtn];
    
    self.msgBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"home_top_message"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.titleView addSubview:self.msgBtn];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.left.equalTo(self.titleView.mas_left).offset(10);
        make.right.offset(-60);
        make.height.equalTo(@30);
    }];
    
    [self.searchTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.left.equalTo(self.searchView.mas_left).offset(30);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@(CODNavigationBarHeight));
        make.left.equalTo(self.searchView.mas_right).offset(10);
    }];
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@(CODNavigationBarHeight));
        make.left.equalTo(self.callBtn.mas_right).offset(10);
    }];
}


- (void)configureView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView registerClass:[CODDecorateTableViewCell class] forCellReuseIdentifier:kCODDecorateTableViewCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopHeight)];
        view.backgroundColor =[UIColor whiteColor];
        view;
    });
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.decorateFourItemView];
    [self.headerView addSubview:self.bannerView];
    
    
}

- (DecorateFourItemView *)decorateFourItemView {
    if (!_decorateFourItemView) {
        _decorateFourItemView = [[DecorateFourItemView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, kFourItemHeight)];
        @weakify(self);
        [_decorateFourItemView setFunctionVWItemClickedBlock:^(NSInteger idx, NSString *title) {
            if ([title isEqualToString:@"精装修"]) {
                @strongify(self);
                CODAllDecorateViewController *allDecoratVC = [[CODAllDecorateViewController alloc] init];
                [self.navigationController pushViewController:allDecoratVC animated:YES];

            } else {
                [SVProgressHUD cod_showWithErrorInfo:@"该功能暂未开放，敬请期待..."];
            }
        }];
    }
    return _decorateFourItemView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10+kFourItemHeight+10, SCREENWIDTH-20, kBannerHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _bannerView.layer.cornerRadius = 5;
        _bannerView.clipsToBounds = YES;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.currentPageDotColor = CODColorTheme;
        _bannerView.localizationImageNamesGroup = @[@"icon_banner", @"icon_banner1", @"icon_banner2"];
    }
    return _bannerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (indexPath.section == 0) {
//        static NSString *kExampleReusableCellID = @"exampleReusableCellID";
//        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExampleReusableCellID];
//        if (!cell) {
//            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExampleReusableCellID];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UILabel *exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 20)];
//            [exampleLabel SetlabTitle:@"— 装修案例 —" andFont:[UIFont systemFontOfSize:16] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil];
//            [cell.contentView addSubview:exampleLabel];
//        }
//        return cell;
//    } else {
//        CODExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODExampleTableViewCell forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell configureWithModel:self.dataArray[indexPath.row]];
//        return cell;
//    }
    CODDecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODDecorateTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithModel:self.dataArray[indexPath.row]];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODCompanyDetailViewController *comDetailVC = [[CODCompanyDetailViewController alloc] init];
    [self.navigationController pushViewController:comDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return [CODDecorateTableViewCell heightForRow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        UIView *sectionHeaderview = ({
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
//            view;
//        });
//
//        self.moreBtnView = [[HJMoreBtnView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
//
//        [self.moreBtnView setBtnSelectItemBlock:^(NSString *itemStr) {
//
//        }];
//
//        [sectionHeaderview addSubview:self.moreBtnView];
//
//
//        return sectionHeaderview;
//    }
//    return nil;
    
    UIView *sectionHeaderview = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    self.conditionTitleView = [[DecorateConditionView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
    
//    [self.moreBtnView setBtnSelectItemBlock:^(NSString *itemStr) {
//
//    }];
    
    [sectionHeaderview addSubview:self.conditionTitleView];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
//    lineView.backgroundColor = [UIColor redColor];
//    [sectionHeaderview addSubview:lineView];

    return sectionHeaderview;
    
}

#pragma mark - Action
- (void)searchAction {
    HPSearchViewController *searchVC = [[HPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)calcuQuoteAction{
    CODCalcuQuoteViewController *VC = [[CODCalcuQuoteViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)callAction {
    [self alertVcTitle:nil message:@"是否拨打10086" leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{;
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",@"10086"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        });
    }];
}
- (void)msgAction {
    CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

@end
