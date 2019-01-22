//
//  CODDIYViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/22.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYViewController.h"
#import "UIButton+COD.h"
#import "UIViewController+COD.h"
#import "SDCycleScrollView.h"
#import "CODMessageViewController.h"
#import "CODIntrinsicTitleView.h"
#import "NSString+COD.h"
#import "CODCalcuQuoteViewController.h"
#import "DecorateFourItemView.h"
#import "DecorateConditionView.h"
#import "CODDecorateTableViewCell.h"
#import "CODSearchViewController.h"
#import "CODCompanyDetailViewController.h"
#import "CODAllDecorateViewController.h"

#import "ConditionPopView.h"
#import "DecorateConditionView.h"
#import "ImageBrowserViewController.h"
#import "UIScrollView+EmptyDataSet.h"

#import "CODDIYCollectionViewCell.h"

static CGFloat const kTopHeight = 240;
static CGFloat const kFourItemHeight = 80;
static CGFloat const kBannerHeight = 140;

static NSString * const kCODDIYCollectionViewCell = @"CODDIYCollectionViewCell";

@interface CODDIYViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshEXDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
// 顶部导航栏组件
@property (nonatomic, strong) CODIntrinsicTitleView *titleView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UILabel *searchTextLable;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;
// 头部轮播图+分类视图组件
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) DecorateFourItemView *decorateFourItemView;
// 列表
@property (nonatomic, strong) UICollectionView *hotCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CODDIYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自装采购";
//    self.dataArray = [NSMutableArray array];
//    
//    [self configureNavgationView];
//    [self configureView];
//    
//    // data
//    [self.hotCollectionView addHeaderWithHeaderClass:nil beginRefresh:YES delegate:self animation:YES];
//    [self.hotCollectionView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//
//#pragma mark - Refresh
//-(void)onRefreshing:(id)control {
//    [self loadDataWithPage:1 andIsHeader:YES];
//}
//
//-(void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum {
//    [self loadDataWithPage:pageNum.integerValue andIsHeader:NO];
//}
//
//#pragma mark - Data
//-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"user_id"] = COD_USERID;
//    params[@"cate_id"] = @(0);//装修类型：0/不传=全部；1=精装修；2=半包施工；3=自装采购；4=软装设计
//    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
//    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
////    params[@"order_type"] = @(self.orderType);// 排序类型
//    params[@"page"] = @(pageNum);
//    params[@"pagesize"] = @(CODRequstPageSize);
//
//    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
//        if ([object[@"code"] integerValue] == 200) {
//            if (isHeader) {
//                [self.hotCollectionView endHeaderRefreshWithChangePageIndex:YES];
//                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"list"]];
//                [self.dataArray removeAllObjects];
//                if (models.count < CODRequstPageSize) [self.tableView noMoreData];
//                [self.dataArray addObjectsFromArray:models];
//            } else {
//                [self.hotCollectionView endFooterRefreshWithChangePageIndex:YES];
//                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"list"]];
//                if (models.count < CODRequstPageSize) [self.tableView noMoreData];
//                [self.dataArray addObjectsFromArray:models];
//            }
//            // banner
//            NSMutableArray *tempAds = [NSMutableArray array];
//            for (NSDictionary *dic in object[@"data"][@"ads"]) {
//                [tempAds addObject:[NSURL URLWithString:dic[@"image"]]];
//            }
//            self.bannerView.imageURLStringsGroup = tempAds;
//
//            self.hotCollectionView.mj_footer.hidden = (self.dataArray.count == 0);
//            [self.hotCollectionView reloadData];
//        } else {
//            if (isHeader) {
//                [self.hotCollectionView endHeaderRefreshWithChangePageIndex:NO];
//            } else  {
//                [self.hotCollectionView endFooterRefreshWithChangePageIndex:NO];
//            }
//            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
//            self.tableView.mj_footer.hidden = YES;
//        }
//    } failed:^(NSError *error) {
//        if (isHeader) {
//            [self.tableView endHeaderRefreshWithChangePageIndex:NO];
//        }else
//        {
//            [self.tableView endFooterRefreshWithChangePageIndex:NO];
//        }
//        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
//        self.tableView.mj_footer.hidden = YES;
//    }];
//}
//
//#pragma mark - View
//- (void)configureNavgationView {
//    self.titleView = [[CODIntrinsicTitleView alloc] init];
//    self.titleView.frame = CGRectMake(0, 0, SCREENWIDTH, CODNavigationBarHeight);
//    self.navigationItem.titleView = self.titleView;
//
//    self.searchView = ({
//        UIView *view = [[UIView alloc] init];
//        view.userInteractionEnabled = YES;
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = 14;
//        view.backgroundColor = CODColorBackground;
//        [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//            [self searchAction];
//        }];
//        view;
//    });
//    [self.titleView addSubview:self.searchView];
//
//    UIImageView *imag = [[UIImageView alloc] init];
//    imag.image = kGetImage(@"search_icon_search");
//    [self.searchView addSubview:imag];
//
//    [imag mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(13, 14));
//        make.centerY.equalTo(self.titleView);
//        make.left.equalTo(@10);
//    }];
//
//    self.searchTextLable = ({
//        UILabel *label = [UILabel GetLabWithFont:XFONT_SIZE(13) andTitleColor:[UIColor lightGrayColor] andTextAligment:0 andBgColor:nil andlabTitle:@"请输入商品名称"];
//        label.backgroundColor = CODColorBackground;
//        label;
//    });
//    [self.searchView addSubview:self.searchTextLable];
//
//    self.callBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor clearColor];
//        [button setImage:[UIImage imageNamed:@"home_top_service"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    });
//    [self.titleView addSubview:self.callBtn];
//
//    self.msgBtn = ({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor clearColor];
//        [button setImage:[UIImage imageNamed:@"home_top_message"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    });
//    [self.titleView addSubview:self.msgBtn];
//
//    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleView.mas_centerY);
//        make.left.equalTo(self.titleView.mas_left).offset(10);
//        make.right.offset(-60);
//        make.height.equalTo(@30);
//    }];
//
//    [self.searchTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleView.mas_centerY);
//        make.left.equalTo(self.searchView.mas_left).offset(30);
//    }];
//
//    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleView.mas_centerY);
//        make.width.equalTo(@20);
//        make.height.equalTo(@(CODNavigationBarHeight));
//        make.left.equalTo(self.searchView.mas_right).offset(10);
//    }];
//    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleView.mas_centerY);
//        make.width.equalTo(@20);
//        make.height.equalTo(@(CODNavigationBarHeight));
//        make.left.equalTo(self.callBtn.mas_right).offset(10);
//    }];
//}
//
//- (void)configureView {
//    self.tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.backgroundColor = CODColorBackground;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.estimatedRowHeight = 0;
//        tableView.estimatedSectionHeaderHeight = 0;
//        tableView.estimatedSectionFooterHeight = 0;
//        [tableView registerClass:[CODDecorateTableViewCell class] forCellReuseIdentifier:kCODDecorateTableViewCell];
//        tableView.emptyDataSetSource = self;
//        tableView.emptyDataSetDelegate = self;
//        tableView;
//    });
//    [self.view addSubview:self.tableView];
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    self.headerView = ({
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopHeight)];
//        view.backgroundColor =[UIColor whiteColor];
//        view;
//    });
//    self.tableView.tableHeaderView = self.headerView;
//
//    [self.headerView addSubview:self.decorateFourItemView];
//    [self.headerView addSubview:self.bannerView];
//}
//
//- (DecorateFourItemView *)decorateFourItemView {
//    if (!_decorateFourItemView) {
//        _decorateFourItemView = [[DecorateFourItemView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, kFourItemHeight)];
//        @weakify(self);
//        [_decorateFourItemView setFunctionVWItemClickedBlock:^(NSInteger idx, NSString *title) {
//            // 装修类型：0/不传=全部；1=精装修；2=半包施工；3=自装采购；4=软装设计
//            if ([title isEqualToString:@"精装修"]){
//                @strongify(self);
//                CODAllDecorateViewController *allDecoratVC = [[CODAllDecorateViewController alloc] init];
//                allDecoratVC.decoratType = 1;
//                [self.navigationController pushViewController:allDecoratVC animated:YES];
//            } else if ([title isEqualToString:@"半包施工"]){
//                @strongify(self);
//                CODAllDecorateViewController *allDecoratVC = [[CODAllDecorateViewController alloc] init];
//                allDecoratVC.decoratType = 2;
//                [self.navigationController pushViewController:allDecoratVC animated:YES];
//            } else if ([title isEqualToString:@"自装采购"]){
//                [SVProgressHUD cod_showWithInfo:@"该功能暂未开放，敬请期待..."];
//            } else if ([title isEqualToString:@"软装设计"]) {
//                @strongify(self);
//                CODAllDecorateViewController *allDecoratVC = [[CODAllDecorateViewController alloc] init];
//                allDecoratVC.decoratType = 4;
//                [self.navigationController pushViewController:allDecoratVC animated:YES];
//            }
//        }];
//    }
//    return _decorateFourItemView;
//}
//
//- (SDCycleScrollView *)bannerView {
//    if (!_bannerView) {
//        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10+kFourItemHeight+10, SCREENWIDTH-20, kBannerHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
//        _bannerView.layer.cornerRadius = 5;
//        _bannerView.clipsToBounds = YES;
//        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _bannerView.currentPageDotImage = [UIImage cod_imageWithColor:[UIColor whiteColor] size:CGSizeMake(25, 3)];
//        _bannerView.pageDotImage = [UIImage cod_imageWithColor:CODHexaColor(0xffffff, 0.3) size:CGSizeMake(25, 3)];
//        //        _bannerView.localizationImageNamesGroup = @[@"icon_banner", @"icon_banner1", @"icon_banner2"];
//    }
//    return _bannerView;
//}
//
//
//- (DecorateConditionView *)conditionTitleView {
//    if (!_conditionTitleView) {
//        _conditionTitleView = [[DecorateConditionView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
//        @weakify(self);
//        [_conditionTitleView setBtnSelectItemBlock:^(ConditionType condition) {
//            @strongify(self);
//            // 综合
//            if (condition == ConditionTypeNormal) {
//
//                // 已置顶，直接弹出
//                if (self.tableView.contentOffset.y >= self.tableView.tableHeaderView.height) {
//                    if (self.popVW.isShow == YES) {
//                        [self.popVW dismiss];
//                    } else {
//                        [self.popVW showWithData:self.popArray opitionKey:@"分类"];
//                    }
//                } else {
//                    [self.tableView setContentOffset:CGPointMake(0,self.tableView.tableHeaderView.height) animated:YES];
//                    // 先置顶在弹出
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        if (self.popVW.isShow == YES) {
//                            [self.popVW dismiss];
//                        } else {
//                            [self.popVW showWithData:self.popArray opitionKey:@"分类"];
//                        }
//                    });
//                }
//
//            } else if (condition == ConditionTypePraise) {
//                if (self.popVW.isShow == YES) [self.popVW dismiss];
//                self.orderType = 3;
//                [self refreshData];
//            } else {
//                if (self.popVW.isShow == YES) [self.popVW dismiss];
//                self.orderType = 4;
//                [self refreshData];
//            }
//        }];
//    }return _conditionTitleView;
//}
//
//-(ConditionPopView *)popVW
//{
//    if (!_popVW) {
//        _popVW = [[ConditionPopView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.conditionTitleView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetHeight(self.conditionTitleView.frame)) supView:self.view];
//        @weakify(self);
//        [_popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
//            @strongify(self);
//            [self.popVW dismiss];
//            UIButton *btn = self.conditionTitleView.itmeBtnOne;
//            [btn setTitle:tle forState:0];
//            self.orderType = idx + 1;
//            [self refreshData];
//        }];
//    }return _popVW;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CODDecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODDecorateTableViewCell forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    CODDectateListModel *model = self.dataArray[indexPath.row];
//    [cell configureWithModel:model];
//    cell.corverImageView.singleTap = ^(NSUInteger index) {
//        if ([UIViewController getCurrentVC]) {
//            [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
//                return model.images;
//            }];
//        }
//    };
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CODCompanyDetailViewController *comDetailVC = [[CODCompanyDetailViewController alloc] init];
//    comDetailVC.companyId = [(CODDectateListModel *)self.dataArray[indexPath.row] compId];
//    [self.navigationController pushViewController:comDetailVC animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    CODDectateListModel *model = self.dataArray[indexPath.row];
//
//    if (model.images.count > 0) {
//        return [CODDecorateTableViewCell heightForRow];
//    } else {
//        return 90;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 60;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *sectionHeaderview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
//    sectionHeaderview.backgroundColor = [UIColor whiteColor];
//
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 9, SCREENWIDTH, 1)];
//    lineView1.backgroundColor = CODColorBackground;
//    [sectionHeaderview addSubview:lineView1];
//
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREENWIDTH, 1)];
//    lineView2.backgroundColor = CODColorBackground;
//    [sectionHeaderview addSubview:lineView2];
//
//    // warning！必须懒加载设置，否则刷新table时会重新创建导致赋值错误
//    [sectionHeaderview addSubview:self.conditionTitleView];
//
//    return sectionHeaderview;
//}
//
//#pragma mark - Action
//- (void)searchAction {
//    CODSearchViewController *searchVC = [[CODSearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}
//
//- (void)calcuQuoteAction{
//    CODCalcuQuoteViewController *VC = [[CODCalcuQuoteViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
//}
//- (void)callAction {
//    [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", get(CODServiceTelKey)) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
//    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (@available(iOS 10.0, *)) {
//                kCall(kFORMAT(@"%@",get(CODServiceTelKey)));
//            } else {
//                // Fallback on earlier versions
//            }
//        });
//    }];
//}
//- (void)msgAction {
//    if (COD_LOGGED) {
//        CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
//        [self.navigationController pushViewController:messageVC animated:YES];
//    } else {
//        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
//        loginViewController.loginBlock = ^{
//            CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
//            [self.navigationController pushViewController:messageVC animated:YES];
//        };
//        [self.navigationController pushViewController:loginViewController animated:YES];
//    }
//}
//
//#pragma mark - EmptyDataSet
//-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return kGetImage(@"icon_data_no");
//}
//
//-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    return [[NSAttributedString alloc] initWithString:@"数据空空如也，去别处逛逛吧" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
//}
//
//-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}
//
//-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return 100;
//}

@end
