//
//  CODHomeViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODHomeViewController.h"
#import "AutoScrollLabel.h"
#import "UIButton+COD.h"
#import "UIButton+ButtonQuickInit.h"
#import "UIViewController+COD.h"
#import "SDCycleScrollView.h"
#import "HomeFourItemView.h"
#import "HomeLeftRightView.h"
#import "CODAnnouncementCell.h"
#import "CODExampleTableViewCell.h"
#import "CODFindDecorateViewController.h"
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
static CGFloat const kBannerRadio = 375 / 751.0;// 广告图片比例
static CGFloat const kPadding = 12;

static NSString * const kCODExampleTableViewCell = @"CODExampleTableViewCell";

@interface CODHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) UIView *CityVw;
//@property(nonatomic,strong) AutoScrollLabel *cityBtn;

@property (nonatomic, strong) CODIntrinsicTitleView *titleView;// 标题视图
@property (nonatomic, strong) UIView *searchView;// 搜索视图
@property (nonatomic, strong) UILabel *searchTextLable;// 搜索视图
@property (nonatomic, strong) UIView *cityView;// 城市
@property (nonatomic, strong) AutoScrollLabel *cityButton;// 城市
@property (nonatomic, strong) UIButton *qugusuanBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) HomeFourItemView *fourItemView;
@property (nonatomic, strong) HomeLeftRightView *leftRightView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
/** 占位图*/
@property(nonatomic,strong) CQPlaceholderView* placeholderView;


@end

@implementation CODHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCity) name:CODSwitchCityNotificationName object:nil];
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem = nil;
    [self configureNavgationView];
    [self configureView];
    
    [self loadData];
    
}

- (void)loadData {
    // 假数据
    self.dataArray = @[@{@"icon":@"http://www.nczyzs.com/images/kt_699.jpg"}, @{@"icon":@""}, @{@"icon":@"http://www.nczyzs.com/images/699_ws.jpg"}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}
#pragma mark - View
- (void)configureNavgationView {

    self.titleView = [[CODIntrinsicTitleView alloc] init];
    self.titleView.frame = CGRectMake(0, 0, SCREENWIDTH, CODNavigationBarHeight);
    self.navigationItem.titleView = self.titleView;
    
    self.cityView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, CODNavigationBarHeight)];
        view.userInteractionEnabled = YES;
        [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self locationAction];
        }];
        
        self.cityButton = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, 44, CODNavigationBarHeight)];
        self.cityButton.textColor = CODColor333333;
        self.cityButton.font = XFONT_SIZE(14);
        self.cityButton.text = [CODGlobal sharedGlobal].currentCityName;
        [view addSubview:self.cityButton];
        
        UIImageView *arrowImaView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cityButton.frame)+2, CGRectGetMidY(self.cityButton.frame)-3, 8, 6)];
        arrowImaView.image = kGetImage(@"home_top_location");
        [view addSubview:arrowImaView];
        
        view;
    });
    [self.titleView addSubview:self.cityView];

    self.searchView = ({
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 14;
        view.backgroundColor = CODColorBackground;
        [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self calcuQuoteAction];
        }];
        view;
    });
    [self.titleView addSubview:self.searchView];
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 13, 15)];
    imag.image = kGetImage(@"home_top_counter");
    [self.searchView addSubview:imag];
    
    [imag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 15));
        make.centerY.equalTo(self.titleView);
        make.left.equalTo(@10);
    }];
    
    self.searchTextLable = ({
        UILabel *label = [UILabel GetLabWithFont:XFONT_SIZE(13) andTitleColor:[UIColor lightGrayColor] andTextAligment:0 andBgColor:nil andlabTitle:@"10秒算出装修报价"];
        label.backgroundColor = CODColorBackground;
        label;
    });
    [self.searchView addSubview:self.searchTextLable];
    
    self.qugusuanBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button SetBtnTitle:@"去估算" andTitleColor:CODColorTheme andFont:XFONT_SIZE(13) andBgColor:nil andBgImg:nil andImg:kGetImage(@"home_top_arrow") andClickEvent:@selector(calcuQuoteAction) andAddVC:self];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button cod_alignTitleLeftAndImageRight];
        button;
    });
    [self.searchView addSubview:self.qugusuanBtn];
    
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
        make.left.equalTo(self.cityView.mas_right).offset(10);
        make.right.offset(-60);
        make.height.equalTo(@30);
    }];
    
    [self.searchTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.left.equalTo(self.searchView.mas_left).offset(25);
    }];
    [self.qugusuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.right.offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView registerClass:[CODExampleTableViewCell class] forCellReuseIdentifier:kCODExampleTableViewCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.headerView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*kBannerRadio + 100)];
        view;
    });
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.bannerView];
    [self.headerView addSubview:self.fourItemView];
    
    [self.view addSubview:self.placeholderView];
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*kBannerRadio) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.pageControlBottomOffset = 30;
        _bannerView.currentPageDotColor = CODColorTheme;
        _bannerView.localizationImageNamesGroup = @[@"icon_banner", @"icon_banner1", @"icon_banner2"];
    }
    return _bannerView;
}

- (HomeFourItemView *)fourItemView {
    if (!_fourItemView) {
        _fourItemView = [[HomeFourItemView alloc] initWithFrame:CGRectMake(kPadding, CGRectGetMaxY(self.bannerView.frame)-kPadding*2, SCREENWIDTH-kPadding*2, 123.5)];
        @weakify(self);
        [_fourItemView setFunctionVWItemClickedBlock:^(NSInteger idx, NSString *title) {
            
            if ([title isEqualToString:@"找装修"]) {
                @strongify(self);
                CODFindDecorateViewController *vc = [[CODFindDecorateViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [SVProgressHUD cod_showWithErrorInfo:@"该功能暂未开放，敬请期待..."];
            }
        }];
    }
    return _fourItemView;
}

- (HomeLeftRightView *)leftRightView {
    if (!_leftRightView) {
        _leftRightView = [[HomeLeftRightView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
        @weakify(self);
        _leftRightView.SelectImgVwBack = ^(NSString *str) {
            if ([str isEqualToString:@"算报价"]) {
                @strongify(self);
                [self calcuQuoteAction];
            } else if ([str isEqualToString:@"效果图"]) {
                @strongify(self);
                CODEffectPicViewController *VC = [[CODEffectPicViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                @strongify(self);
//                CODCompanyViewController *VC = [[CODCompanyViewController alloc] init];
//                [self.navigationController pushViewController:VC animated:YES];
            }
        };
    }
    return _leftRightView;
}

-(CQPlaceholderView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc] initWithFrame:self.view.bounds type:CQPlaceholderViewTypeNoOrder delegate:self];
        _placeholderView.backgroundColor = [UIColor whiteColor];
        _placeholderView.imageView.image = [UIImage imageNamed:@"positioning_icon_empty"];
        _placeholderView.descLabel.text = @"您所在城市本地服务暂未开通敬请期待";
        _placeholderView.descLabel.textColor = CODColor333333;
        _placeholderView.subtitleLabel.text = @"您可以选择其他已开通城市";
        _placeholderView.subtitleLabel.textColor = CODColor999999;
        _placeholderView.hidden = YES;
    }return _placeholderView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *kLeftRightCell = @"leftRightCell";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftRightCell];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftRightCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.leftRightView];
            [self.leftRightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(12,12,12,12));
            }];
        }
        return cell;
    }
    
    else if (indexPath.section == 1) {
        //轮播公告
        CODAnnouncementCell *anceCell = [CODAnnouncementCell cellWithTableView:tableView reuseIdentifier:nil];

//        anceCell.topSignImages = self.leftImgS;
//        anceCell.topTitles = self.titleStr;
//        anceCell.bottomTitles = self.titleRightStr;
//        [anceCell setNoticeScrollBlock:^(SGAdvertScrollView *view, NSInteger idx) {
//            [SVProgressHUD cod_showWithErrorInfo:@"敬请期待"];
//        }];
        return anceCell;
    }
    else if (indexPath.section == 2) {
        static NSString *kExampleReusableCellID = @"exampleReusableCellID";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kExampleReusableCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExampleReusableCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 20)];
            [exampleLabel SetlabTitle:@"— 装修案例 —" andFont:[UIFont systemFontOfSize:16] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil];
            [cell.contentView addSubview:exampleLabel];
        }
        return cell;
    }
    
    else {
        CODExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODExampleTableViewCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureWithModel:self.dataArray[indexPath.row]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        CODHotViewController *hotVC = [[CODHotViewController alloc] init];
        [self.navigationController pushViewController:hotVC animated:YES];

    }
    else if (indexPath.section == 3) {
        CODExamDetailViewController *detailVC = [[CODExamDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
         return 150 + kPadding*2;
    } else if (indexPath.section == 1) {
        return [CODAnnouncementCell heightForRow];
    } else if (indexPath.section == 2) {
        return 40;
    } else {
        return [CODExampleTableViewCell heightForRow];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Switch city
- (void)switchCity {
   
    self.cityButton.text = [CODGlobal sharedGlobal].currentCityName;
    
    if ([self.cityButton.text isEqualToString:@"南昌市"]) {
        self.placeholderView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.placeholderView.hidden = YES;
        self.tableView.hidden = NO;
    }
}
#pragma mark - Action
- (void)locationAction {
    SwitchCityViewController *cityVC = [[SwitchCityViewController alloc] init];
//    @weakify(self);
//    [cityVC setSelectCity:^(NSString *CityStr) {
//        @strongify(self);
//        self.cityButton.text = CityStr;
//        // 序列
//        [[NSUserDefaults standardUserDefaults] setObject:CityStr forKey:CODCityDefaultNameKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }];
    [self.navigationController pushViewController:cityVC animated:YES];
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
