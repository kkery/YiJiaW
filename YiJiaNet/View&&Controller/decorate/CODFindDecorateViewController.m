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

#import "ConditionPopView.h"
#import "DecorateConditionView.h"
#import "ImageBrowserViewController.h"
#import "UIScrollView+EmptyDataSet.h"

static CGFloat const kTopHeight = 240;
static CGFloat const kFourItemHeight = 80;
static CGFloat const kBannerHeight = 140;

static NSString * const kCODDecorateTableViewCell = @"CODDecorateTableViewCell";

@interface CODFindDecorateViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshEXDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UIView *CityVw;
//@property(nonatomic,strong) AutoScrollLabel *cityBtn;

@property (nonatomic, strong) CODIntrinsicTitleView *titleView;// 标题视图


/** 条件帅选框*/
@property (nonatomic, strong) DecorateConditionView *conditionTitleView;
/** 下拉视图 */
@property (nonatomic,strong) ConditionPopView *popVW;
/** 下拉选项数据*/
@property (nonatomic,strong) NSArray *popArray;

@property (nonatomic, strong) UIView *searchView;// 搜索视图
@property (nonatomic, strong) UILabel *searchTextLable;// 搜索视图;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@property (nonatomic, strong) DecorateFourItemView *decorateFourItemView;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 请求参数*/
@property(nonatomic, assign) NSInteger orderType;//1综合 2案例 3口碑 4距离

@end

@implementation CODFindDecorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找装修";
    self.dataArray = [NSMutableArray array];
    self.popArray = @[@"综合",@"案例"];

    [self configureNavgationView];
    [self configureView];
    
    // data
    self.orderType = 1;
    [self refreshData];
    [self.tableView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
    [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
    
//    [[RACObserve(self, dataArray) distinctUntilChanged] subscribeNext:^(id x) {
//        @strongify(self);
//        self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
//        [self.tableView reloadData];
//    }];
    @weakify(self);
    [[RACObserve(self.popVW, isShow) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.conditionTitleView.itmeBtnOne setImage:[UIImage imageNamed:@"mall_screening_selected"] forState:UIControlStateSelected];
        } else {
            [self.conditionTitleView.itmeBtnOne setImage:[UIImage imageNamed:@"mall_screening"] forState:UIControlStateSelected];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)refreshData {
     [self loadDataWithPage:1 andIsHeader:YES];
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
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;;
    params[@"order_type"] = @(self.orderType);// 排序类型
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @"10";
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                if (models.count < CODRequstPageSize) [self.tableView noMoreData];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"list"]];
                if (models.count < CODRequstPageSize) [self.tableView noMoreData];
                [self.dataArray addObjectsFromArray:models];
            }
            self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
            [self.tableView reloadData];
        } else {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:NO];
            } else  {
                [self.tableView endFooterRefreshWithChangePageIndex:NO];
            }
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            self.tableView.mj_footer.hidden = YES;
        }
    } failed:^(NSError *error) {
        if (isHeader) {
            [self.tableView endHeaderRefreshWithChangePageIndex:NO];
        }else
        {
            [self.tableView endFooterRefreshWithChangePageIndex:NO];
        }
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
        self.tableView.mj_footer.hidden = YES;
    }];
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView registerClass:[CODDecorateTableViewCell class] forCellReuseIdentifier:kCODDecorateTableViewCell];
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
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
        _bannerView.currentPageDotImage = [UIImage cod_imageWithColor:[UIColor whiteColor] size:CGSizeMake(25, 3)];
        _bannerView.pageDotImage = [UIImage cod_imageWithColor:CODHexaColor(0xffffff, 0.3) size:CGSizeMake(25, 3)];
        _bannerView.localizationImageNamesGroup = @[@"icon_banner", @"icon_banner1", @"icon_banner2"];
    }
    return _bannerView;
}


- (DecorateConditionView *)conditionTitleView {
    if (!_conditionTitleView) {
        _conditionTitleView = [[DecorateConditionView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
        @weakify(self);
        [_conditionTitleView setBtnSelectItemBlock:^(ConditionType condition) {
            @strongify(self);
            // 综合
            if (condition == ConditionTypeNormal) {
                
                // 已置顶，直接弹出
                if (self.tableView.contentOffset.y >= self.tableView.tableHeaderView.height) {
                    if (self.popVW.isShow == YES) {
                        [self.popVW dismiss];
                    } else {
                        [self.popVW showWithData:self.popArray opitionKey:@"分类"];
                    }
                } else {
                    [self.tableView setContentOffset:CGPointMake(0,self.tableView.tableHeaderView.height) animated:YES];
                    // 先置顶在弹出
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.popVW.isShow == YES) {
                            [self.popVW dismiss];
                        } else {
                            [self.popVW showWithData:self.popArray opitionKey:@"分类"];
                        }
                    });
                }
                
            } else if (condition == ConditionTypePraise) {
                if (self.popVW.isShow == YES) [self.popVW dismiss];
                self.orderType = 3;
                [self refreshData];
            } else {
                if (self.popVW.isShow == YES) [self.popVW dismiss];
                self.orderType = 4;
                [self refreshData];
            }
        }];
    }return _conditionTitleView;
}

-(ConditionPopView *)popVW
{
    if (!_popVW) {
        _popVW = [[ConditionPopView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.conditionTitleView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetHeight(self.conditionTitleView.frame)) supView:self.view];
        @weakify(self);
        [_popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
            @strongify(self);
            [self.popVW dismiss];
            //            UIButton *btn = weakself.conditionTitleView.recodeChoseDic[@"select"];
            UIButton *btn = self.conditionTitleView.itmeBtnOne;
            //        if (self.isOn) {
            //            [self.itmeBtnOne setImage:kGetImage(@"shop_up_sel") forState:UIControlStateSelected];
            //            self.isOn = NO;
            //        } else {
            //            [self.itmeBtnOne setImage:kGetImage(@"top_sel") forState:UIControlStateSelected];
            //            self.isOn = YES;
            //        }
            [btn setTitle:tle forState:0];
    
            self.orderType = idx + 1;
            [self refreshData];
        }];
        
    }return _popVW;
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODDecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODDecorateTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CODDectateListModel *model = self.dataArray[indexPath.row];
    [cell configureWithModel:model];
    cell.corverImageView.singleTap = ^(NSUInteger index) {
        if ([UIViewController getCurrentVC]) {
            [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
                return model.images;
            }];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODCompanyDetailViewController *comDetailVC = [[CODCompanyDetailViewController alloc] init];
    comDetailVC.companyId = [(CODDectateListModel *)self.dataArray[indexPath.row] compId];
    [self.navigationController pushViewController:comDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CODDectateListModel *model = self.dataArray[indexPath.row];

    if (model.images.count > 0) {
        return [CODDecorateTableViewCell heightForRow];
    } else {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    sectionHeaderview.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 1)];
    lineView1.backgroundColor = CODColorBackground;
    [sectionHeaderview addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 1)];
    lineView2.backgroundColor = CODColorBackground;
    [sectionHeaderview addSubview:lineView2];
    
    // warning！必须懒加载设置，否则刷新table时会重新创建导致赋值错误
    [sectionHeaderview addSubview:self.conditionTitleView];
    
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
    [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", CODCustomerServicePhone) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CODCustomerServicePhone] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CODCustomerServicePhone]];
            }
        });
    }];
}
- (void)msgAction {
    CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - EmptyDataSet
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return kGetImage(@"icon_data_no");
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"数据空空如也，去别处逛逛吧" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 100;
}
@end
