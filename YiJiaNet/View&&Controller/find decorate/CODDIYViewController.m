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
#import "XHIntegralCollectionReusableView.h"
#import "StoreSearchCollectLayout.h"

#import "CODDIYCateViewController.h"
#import "CODAllSortViewController.h"
#import "CODDIYDetailViewController.h"
#import "CODGoodsDetailViewController.h"
static NSString * const kCODDIYCollectionViewCell = @"CODDIYCollectionViewCell";
static NSString * const kCODReusableHeaderView = @"CODReusableHeaderView";

@interface CODDIYViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MJRefreshEXDelegate>
// 顶部导航栏组件
@property (nonatomic, strong) CODIntrinsicTitleView *titleView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UILabel *searchTextLable;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;
// 列表
@property (nonatomic, strong) UICollectionView *hotCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CODDIYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自装采购";
    self.dataArray = [NSMutableArray array];
    
    [self configureNavgationView];
    [self configureView];
    
    // data
    [self loadDataWithPage:1 andIsHeader:YES];

    [self.hotCollectionView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
    [self.hotCollectionView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    params[@"cate_id"] = @(0);//装修类型：0/不传=全部；1=精装修；2=半包施工；3=自装采购；4=软装设计
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
//    params[@"order_type"] = @(self.orderType);// 排序类型
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);

    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.hotCollectionView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDIYModel class] json:object[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                if (models.count < CODRequstPageSize) [self.hotCollectionView noMoreData];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.hotCollectionView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDIYModel class] json:object[@"data"][@"list"]];
                if (models.count < CODRequstPageSize) [self.hotCollectionView noMoreData];
                [self.dataArray addObjectsFromArray:models];
            }
            // banner
            NSMutableArray *tempAds = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"ads"]) {
                [tempAds addObject:[NSURL URLWithString:dic[@"image"]]];
            }
//            self.bannerView.imageURLStringsGroup = tempAds;

            [self.hotCollectionView reloadData];
        } else {
            if (isHeader) {
                [self.hotCollectionView endHeaderRefreshWithChangePageIndex:NO];
            } else  {
                [self.hotCollectionView endFooterRefreshWithChangePageIndex:NO];
            }
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        if (isHeader) {
            [self.hotCollectionView endHeaderRefreshWithChangePageIndex:NO];
        }else
        {
            [self.hotCollectionView endFooterRefreshWithChangePageIndex:NO];
        }
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
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
        UILabel *label = [UILabel GetLabWithFont:XFONT_SIZE(13) andTitleColor:[UIColor lightGrayColor] andTextAligment:0 andBgColor:nil andlabTitle:@"请输入商品名称"];
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
    self.hotCollectionView = ({
        UICollectionView *collectionView = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:CODColorBackground andFlowLayout:[UICollectionView getCollectFlowLayoutWithMinLineSpace:10 andMinInteritemSpacing:10 andItemSize:CGSizeMake((SCREENWIDTH-30)/2, (SCREENWIDTH-30)/2+80) andSectionInsert:UIEdgeInsetsMake(10, 10, 0, 10) andscrollDirection:UICollectionViewScrollDirectionVertical] andItemClass:[CODDIYCollectionViewCell class] andReuseID:kCODDIYCollectionViewCell];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        // 注册头视图
        [collectionView registerClass:[XHIntegralCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCODReusableHeaderView];
        collectionView;
    });
    [self.view addSubview:self.hotCollectionView];

    [self.hotCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.hotCollectionView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CODDIYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCODDIYCollectionViewCell forIndexPath:indexPath];
    cell.viewModel = (CODDIYModel*)self.dataArray[indexPath.item];
    return cell;
}

//设置CollectionView头部视图的高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREENWIDTH, [XHIntegralCollectionReusableView heightForReusableView]);
}
// 创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        XHIntegralCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCODReusableHeaderView forIndexPath:indexPath];
        headerView.delegate = self;
        
        return headerView;
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CODGoodsDetailViewController *diyDetailVC = [[CODGoodsDetailViewController alloc] init];
    diyDetailVC.goodsId = @"97";
    [self.navigationController pushViewController:diyDetailVC animated:YES];
    
}

#pragma mark - Action
- (void)sendSelectItmeIndex:(NSInteger)index {
    if (index == 4) {
        CODAllSortViewController *sortVC = [[CODAllSortViewController alloc] init];
        [self.navigationController pushViewController:sortVC animated:YES];
    } else {
        CODDIYCateViewController *cateVC = [[CODDIYCateViewController alloc] init];
        cateVC.diyCategory = index;
        [self.navigationController pushViewController:cateVC animated:YES];
    }
}

- (void)searchAction {
    CODSearchViewController *searchVC = [[CODSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)calcuQuoteAction{
    CODCalcuQuoteViewController *VC = [[CODCalcuQuoteViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
