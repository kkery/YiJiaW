//
//  CODNewHsDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODNewHsDetailViewController.h"
#import "UIButton+COD.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CODCompanyDetailModel.h"
#import "JXMapNavigationView.h"
#import "CODDIYDetailViewController.h"
#import "CODLoupanInfoViewController.h"
#import "CODHouseDetailIntroCell.h"
#import "CODLouPanInfoViewCell.h"
#import "CODVideoImageCell.h"
#import "JPVideoPlayerKit.h"
#import "XWXShareView.h"
#import "UIViewController+COD.h"
static CGFloat const kTopViewHeight = 200;// 顶部图高度
#define kOffsety 200.f  // 导航栏渐变的判定值

@interface CODNewHsDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, JPVideoPlayerDelegate, CODVideoImageCellDelegate>
/** 导航栏 */
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) UIButton *homeBtn;
/** 轮播图 */
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *scrollImgNumLabel;
/** table */
@property (nonatomic, strong) UITableView *tableView;
/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, strong) JXMapNavigationView *mapNavigationView;
@property (nonatomic,strong) CODCompanyDetailModel *MModel;

@property (nonatomic, strong) CODVideoImageCell *playingCell;

@end

@implementation CODNewHsDetailViewController
-(NSArray *)bannerArray
{
    return @[
             @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}
-(NSArray *)imgArray
{
    return @[
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc] init];
        _mapNavigationView.selfClass = self;
    }
    return _mapNavigationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetNav];
    // view
    [self configureView];
    // data
    [self loadNewHorseDetailData];
    // rac
    @weakify(self);
    [[RACObserve(self, MModel) distinctUntilChanged] subscribeNext:^(CODCompanyDetailModel *mod) {
        @strongify(self);
        self.navTitleLabel.text = mod.name;
        self.bannerView.imageURLStringsGroup = mod.images;
        self.scrollImgNumLabel.hidden = (mod.images.count == 0);
        [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(1), @(self.MModel.images.count))];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        // tableView 偏移20/64适配
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = YES;
    self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1];
    
    if (self.playingCell) {
        [self.playingCell.placeholderImg jp_stopPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
- (void)loadNewHorseDetailData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.hourseId   ;
    params[@"user_id"] = COD_USERID;
    [SVProgressHUD cod_showStatu];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=merchant" andParameters:params Sucess:^(id object) {
        [self.tableView.mj_header endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            CODCompanyDetailModel *model = [CODCompanyDetailModel modelWithJSON:object[@"data"][@"info"]];
            self.MModel = model;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - View
- (void)configureView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = self.topView;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewHorseDetailData)];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
//    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight-12)];
//
//    self.bannerView = ({
//        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
//        bannerView.delegate = self;
//        bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
//        bannerView;
//    });
//    [self.topView addSubview:self.bannerView];
//
//    self.scrollImgNumLabel = [UILabel GetLabWithFont:kFont(12) andTitleColor:[UIColor whiteColor] andTextAligment:1 andBgColor:CODHexaColor(0x000000, 0.3) andlabTitle:nil];
//    [self.scrollImgNumLabel setLayWithCor:9 andLayerWidth:0 andLayerColor:nil];
//    [self.topView addSubview:self.scrollImgNumLabel];
//    [self.scrollImgNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.topView.mas_bottom).offset(-10);
//        make.right.equalTo(self.topView.mas_right).offset(-5);
//        make.height.equalTo(@20);
//        make.width.equalTo(@35);
//    }];
//    [self.tableView sendSubviewToBack:self.topView];
//
//    self.tableView.tableHeaderView = self.topView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-50);
            make.left.right.offset(0);
            make.height.equalTo(@50);
        }];
        UIButton *collectBtn = [[UIButton alloc] init];
        [collectBtn SetBtnTitle:@"收藏" andTitleColor:CODColor666666 andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(collectAction:) andAddVC:self];
        [collectBtn setImage:kGetImage(@"decorate_collection") forState:UIControlStateNormal];
        [collectBtn setImage:kGetImage(@"decorate_collection_fill") forState:UIControlStateSelected];
        [collectBtn cod_alignImageUpAndTitleDown];
        [view addSubview:collectBtn];
        self.collectButton = collectBtn;
        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.offset(10);
            make.top.offset(0);
            make.width.equalTo(@50);
        }];
        UIButton *callBtn = [[UIButton alloc] init];
        [callBtn SetBtnTitle:@"分享" andTitleColor:CODColor666666 andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:kGetImage(@"house_details_share") andClickEvent:@selector(shareAction) andAddVC:self];
        [callBtn cod_alignImageUpAndTitleDown];
        [view addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(collectBtn.mas_right).offset(10);
            make.top.offset(0);
            make.width.equalTo(@50);
        }];
        
        UIView *btnBackView = [[UIView alloc] init];
        [btnBackView setLayWithCor:18 andLayerWidth:0 andLayerColor:0];
        [view addSubview:btnBackView];
        CGFloat btnBackViewW = SCREENWIDTH - 150 - 10;
        [btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.offset(150);
            make.right.offset(-10);
            make.height.equalTo(@40);
        }];
        
        UIButton *orderBtn = [[UIButton alloc] init];
        
        [orderBtn SetBtnTitle:@"电话" andTitleColor:[UIColor whiteColor] andFont:kFont(12) andBgColor:nil andBgImg:[UIImage cod_imageWithColor:CODColorButtonNormal] andImg:kGetImage(@"house_details_phone") andClickEvent:@selector(callAction) andAddVC:self];
        [btnBackView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btnBackView);
        }];
        view;
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *kCODVideoImageCell = @"CODVideoImageCell";
        CODVideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODVideoImageCell];
        if (!cell) {
            cell = [[CODVideoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCODVideoImageCell];
        }
        cell.delegate = self;
        [cell setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
        
        return cell;
    }
    else if (indexPath.row == 1) {
        static NSString *kCODHouseDetailIntroCell = @"CODHouseDetailIntroCell";
        CODHouseDetailIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODHouseDetailIntroCell];
        if (!cell) {
            cell = [[CODHouseDetailIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCODHouseDetailIntroCell];
        }
        [cell.addressBtn addTarget:self action:@selector(gotoAddressAction) forControlEvents:UIControlEventTouchUpInside];

        [cell configureWithModel:nil];

        return cell;
    }
    else {
        static NSString *kCODLouPanInfoViewCell = @"CODLouPanInfoViewCell";
        CODLouPanInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODLouPanInfoViewCell];
        if (!cell) {
            cell = [[CODLouPanInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCODLouPanInfoViewCell];
        }
        
        [cell.moreButton addTarget:self action:@selector(gotoLoupanInfoAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell configureWithModel:nil];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!self.playingCell) {
            return;
        }
        if (cell.hash == self.playingCell.hash) {
            [self.playingCell.placeholderImg jp_stopPlay];
            self.playingCell.playBtn.hidden = NO;
            self.playingCell = nil;
        }
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [CODVideoImageCell heightForRow];
    }
    else if (indexPath.row == 1) {
        return [CODHouseDetailIntroCell heightForRow];
    }
    else {
        
        return  [CODLouPanInfoViewCell heightForRow];;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (void)collectAction:(UIButton *)btn {
    if (!COD_LOGGED) {
        [SVProgressHUD cod_showWithInfo:@"未登录,请先登录"];
        return;
    }
    
    NSString *path;
    if (btn.selected == YES) {
        path = @"m=App&c=collect&a=delete";
    } else {
        path = @"m=App&c=collect&a=add";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"all_id"] = self.MModel.companyId;
    params[@"type"] = @"2";// 1：装修公司 2：新房 3：二手房 4：租房
    [[CODNetWorkManager shareManager] AFRequestData:path andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if ([path isEqualToString:@"m=App&c=collect&a=add"]) {
                btn.selected = YES;
                [SVProgressHUD cod_showWithSuccessInfo:@"收藏成功"];
            } else {
                btn.selected = NO;
                [SVProgressHUD cod_showWithSuccessInfo:@"已取消收藏"];
            }
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

- (void)shareAction {
    XWXShareView *shareView = [[XWXShareView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"益家网", @"share_title",
                         @"找不到房子信息，下载益家网APP", @"share_content",
                         nil ];
    shareView.dic = dic;
    shareView.navSelf = self;
    [shareView show];
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

- (void)gotoHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gotoLoupanInfoAction {
    CODLoupanInfoViewController *infoVC = [[CODLoupanInfoViewController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)gotoAddressAction {
    [self.mapNavigationView showMapNavigationViewWithtargetLatitude:[self.MModel.latitude doubleValue] targetLongitute:[self.MModel.longitude doubleValue] toName:self.MModel.address];
}

#pragma mark - 视频播放
- (void)cellPlayButtonDidClick:(CODVideoImageCell *)cell {
    if (self.playingCell) {
        [self.playingCell.placeholderImg jp_stopPlay];
        self.playingCell.playBtn.hidden = NO;
    }
    self.playingCell = cell;
    self.playingCell.playBtn.hidden = YES;
    self.playingCell.placeholderImg.jp_videoPlayerDelegate = self;
    
    NSString *url = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
    
    [cell.placeholderImg jp_playVideoWithURL:[NSURL URLWithString:url]
                                     bufferingIndicator:[JPVideoPlayerBufferingIndicator new]
                                            controlView:[[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil]
                                           progressView:nil
                                          configuration:nil];
}
#pragma mark - JPVideoPlayerDelegate
- (BOOL)shouldShowBlackBackgroundWhenPlaybackStart {
    return YES;
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}

- (BOOL)shouldAutoHideControlContainerViewWhenUserTapping {
    return YES;
}

- (BOOL)shouldShowDefaultControlAndIndicatorViews {
    return NO;
}
#pragma mark - 轮播图的代理实现
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(index+1), @(self.MModel.images.count))];
    CGFloat width = kGetTextSize(self.scrollImgNumLabel.text, 200, 20, 12).width;
    if (width>35) {
        [self.scrollImgNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width+20));
        }];
    }
}
// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([UIViewController getCurrentVC]) {
        //        [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
        //            return self.MModel.images;
        //        }];
    }
}


#pragma mark - 导航栏设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= kOffsety) {
        _alphaMemory = offsetY/kOffsety >= 1 ? 1 : offsetY/kOffsety;
        [self wr_setNavBarBackgroundAlpha:_alphaMemory];
        self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:_alphaMemory];
    }else if (offsetY>kOffsety){
        _alphaMemory = 1;
        [self wr_setNavBarBackgroundAlpha:_alphaMemory];
        self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:_alphaMemory];
    }
    if (_alphaMemory < .8) {
        [self.returnBtn setImage:kGetImage(@"decorate_incon_return") forState:0];
        [self.homeBtn setImage:kGetImage(@"mall_details_home") forState:0];
        
    } else {
        [self.returnBtn setImage:kGetImage(@"nav_app_return") forState:0];
        [self.homeBtn setImage:kGetImage(@"mall_details_home_sliding") forState:0];
    }
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    } return _navTitleLabel;
}

- (void)SetNav {
    // 一行代码搞定导航栏底部分割线是否隐藏
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:0.0];
    
    self.navigationItem.titleView = self.navTitleLabel;
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:kGetImage(@"decorate_incon_return") forState:0];
    self.returnBtn.size = self.returnBtn.currentImage.size;
    [self.returnBtn addTarget:self action:@selector(cod_returnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:self.returnBtn];
    self.navigationItem.leftBarButtonItems = @[returnBtnItem];
    
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.homeBtn setImage:kGetImage(@"mall_details_home") forState:0];
    self.homeBtn.size = self.homeBtn.currentImage.size;
    [self.homeBtn addTarget:self action:@selector(gotoHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:self.homeBtn];
    self.navigationItem.rightBarButtonItem = homeBtnItem;
}

@end
