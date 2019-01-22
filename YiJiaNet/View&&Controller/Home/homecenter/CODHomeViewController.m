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
#import "CODAllDecorateViewController.h"// 装修公司
#import "CODExampleListViewController.h"// 效果图
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
#import "MJRefresh.h"
#import "UIView+YeeBadge.h"

static CGFloat const kBannerRadio = 375 / 751.0;// 广告图片比例
static CGFloat const kPadding = 12;

static NSString * const kCODExampleTableViewCell = @"CODExampleTableViewCell";

@interface CODHomeViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshEXDelegate>

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
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *lineNews;
@property (nonatomic, strong) NSArray *lineNewsIcon;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger messageNum;

/** 占位图*/
@property(nonatomic,strong) CQPlaceholderView* placeholderView;


@end

@implementation CODHomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CODLocationNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CODSwitchCityNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CODLoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CODMsgUnreadNotificationName object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LocationNotification) name:CODLocationNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCityNotification) name:CODSwitchCityNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:CODLoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:CODMsgUnreadNotificationName object:nil];
    
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem = nil;
    
    self.banners = [NSArray array];
    self.lineNews = [NSArray array];
    self.lineNewsIcon = [NSArray array];

    self.listArray = [NSMutableArray array];
    
    [self configureNavgationView];
    [self configureView];
    
    // data
    [self.tableView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
    [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
    
    @weakify(self);
     [RACObserve(self, messageNum) subscribeNext:^(id x) {
        @strongify(self);
         NSInteger count = [x integerValue];
         if (count == 0) {
             [self.msgBtn hideBadgeView];
         } else {
             [self.msgBtn ShowBadgeView];
         }
    }];
    // data
//    [self loadDataWithPage:1 andIsHeader:YES];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //更新地理位置
}

#pragma mark - Data
- (void)refreshData {
    [self loadDataWithPage:1 andIsHeader:YES];
}

#pragma mark - Notification
- (void)LocationNotification {
    // 检测定位权限
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        self.placeholderView.hidden = NO;
        self.tableView.hidden = YES;
        [self alertLocation];
    } else {
        self.placeholderView.hidden = YES;
        self.tableView.hidden = NO;
        [self refreshData];
    }
    self.cityButton.text = kStringIsEmpty([CODGlobal sharedGlobal].currentCityName) ? @"定位中~" : [CODGlobal sharedGlobal].currentCityName;
}

- (void)switchCityNotification {
    [SVProgressHUD cod_showStatu];
    self.cityButton.text = kStringIsEmpty([CODGlobal sharedGlobal].currentCityName) ? @"定位中~" : [CODGlobal sharedGlobal].currentCityName;
    [self refreshData];
}

- (void)alertLocation {
    [self alertVcTitle:@"定位服务未开启" message:@"请到设置->隐私->定位服务中开启定位服务，益家网需要知道您的位置才能提供更好的服务~" leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"去开启" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL])
        {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
}

#pragma mark - Refresh
-(void)onRefreshing:(id)control {
    [self loadDataWithPage:1 andIsHeader:YES];
}

-(void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum {
    [self loadDataWithPage:pageNum.integerValue andIsHeader:NO];
}

#pragma mark - Data
-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
    params[@"city"] = [CODGlobal sharedGlobal].currentCityName;
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=index" andParameters:params Sucess:^(id object) {
        [SVProgressHUD cod_dismis];
        if ([object[@"code"] integerValue] == 200) {
            // 电话
            save(object[@"data"][@"tel"], CODServiceTelKey);
            // 新消息数量
            self.messageNum = [object[@"data"][@"new_message"] integerValue];
            // banner
            NSMutableArray *tempAds = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"ad"]) {
                [tempAds addObject:[NSURL URLWithString:dic[@"content"]]];
            }
            self.banners = tempAds;
            self.bannerView.imageURLStringsGroup = self.banners;
            // 头条
            NSMutableArray *tempNews = [NSMutableArray array];
            NSMutableArray *tempNews1 = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"news"]) {
                [tempNews addObject:dic[@"title"]];
                [tempNews1 addObject:@"hp_notice_point"];
            }
            self.lineNews = tempNews;
            self.lineNewsIcon = tempNews1;
            // 列表
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateExampleModel class] json:object[@"data"][@"list"]];
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateExampleModel class] json:object[@"data"][@"list"]];
                [self.listArray addObjectsFromArray:models];
            }
            if (self.listArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        
        else {
            self.placeholderView.hidden = NO;
            self.tableView.hidden = YES;
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:NO];
            } else  {
                [self.tableView endFooterRefreshWithChangePageIndex:NO];
            }
            if ([object[@"code"] integerValue] == 405) {
            }
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        self.placeholderView.hidden = NO;
        self.tableView.hidden = YES;
        if (isHeader) {
            [self.tableView endHeaderRefreshWithChangePageIndex:NO];
        }else
        {
            [self.tableView endFooterRefreshWithChangePageIndex:NO];
        }
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
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
        self.cityButton.text = kStringIsEmpty([CODGlobal sharedGlobal].currentCityName) ? @"定位中~" : [CODGlobal sharedGlobal].currentCityName;
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
        make.height.equalTo(@(17));
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
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*kBannerRadio) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.currentPageDotImage = [UIImage cod_imageWithColor:[UIColor whiteColor] size:CGSizeMake(25, 3)];
        _bannerView.pageDotImage = [UIImage cod_imageWithColor:CODHexaColor(0xffffff, 0.3) size:CGSizeMake(25, 3)];
        _bannerView.pageControlBottomOffset = 25;
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
                [SVProgressHUD cod_showWithInfo:@"该功能暂未开放，敬请期待..."];
            }
        }];
    }
    return _fourItemView;
}

- (HomeLeftRightView *)leftRightView {
    if (!_leftRightView) {
        _leftRightView = [[HomeLeftRightView alloc] init];
        @weakify(self);
        _leftRightView.SelectImgVwBack = ^(NSString *str) {
            if ([str isEqualToString:@"算报价"]) {
                @strongify(self);
                [self calcuQuoteAction];
            } else if ([str isEqualToString:@"效果图"]) {
                @strongify(self);
                CODExampleListViewController *exampleListVV = [[CODExampleListViewController alloc] init];
                exampleListVV.companyId = @"";
                [self.navigationController pushViewController:exampleListVV animated:YES];
            } else {
                @strongify(self);
                CODAllDecorateViewController *allDecoratVC = [[CODAllDecorateViewController alloc] init];
                allDecoratVC.title = @"装修公司";
                allDecoratVC.decoratType = 0;
                [self.navigationController pushViewController:allDecoratVC animated:YES];
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
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
        return self.listArray.count;
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

        anceCell.newstitles = self.lineNews;
        anceCell.newstitlesIcons = self.lineNewsIcon;
        
//        anceCell.topSignImages = self.leftImgS;
        
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
        
        [cell configureWithModel:(CODDectateExampleModel *)self.listArray[indexPath.row]];
        
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
        CODDectateExampleModel *model = self.listArray[indexPath.row];
        detailVC.exampId = kFORMAT(@"%@", @(model.examId));
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
         return 153 + kPadding*2;
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
    if (!COD_LOGGED) {
        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
        loginViewController.loginBlock = ^{
            CODCalcuQuoteViewController *VC = [[CODCalcuQuoteViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        };
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        CODCalcuQuoteViewController *VC = [[CODCalcuQuoteViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)callAction {
    [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", get(CODServiceTelKey)) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                kCall(kFORMAT(@"%@",get(CODServiceTelKey)));
            } else {
                // Fallback on earlier versions
            }
        });
    }];
}
- (void)msgAction {
    if (COD_LOGGED) {
        CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else {
        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
        loginViewController.loginBlock = ^{
            CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        };
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

@end
