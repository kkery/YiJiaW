//
//  CODDIYCateViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYCateViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "CODCompanyDetailViewController.h"
#import "ImageBrowserViewController.h"
#import "XWXStoreDetailsItemVw.h"  // 条件选择框

#import "CODDIYCollectionViewCell.h"
#import "CODDIYConditionView.h"
#import "ConditionPopView.h"

static NSString * const kCODCateCollectionViewCell = @"CODCateCollectionViewCell";

@interface CODDIYCateViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MJRefreshEXDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CODDIYConditionView *conditionTitleView;//条件选择框
@property (nonatomic,strong) ConditionPopView *popVW;//下拉视图
@property (nonatomic,strong) NSArray *sortArray;//下拉选项数据
@property (nonatomic,strong) NSArray *brandArray;//下拉选项数据

@property(nonatomic, assign) NSInteger parameIndex;//请求参数: 1综合 2案例 3口碑 4距离


@property(nonatomic, assign) NSInteger selctedIndex;

@property(nonatomic, assign) NSInteger selctedItem;

@end

@implementation CODDIYCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarShadowImageHidden:NO];
    
    if (self.diyCategory == 1) {
        self.title = @"智能家具";
    } else if (self.diyCategory == 2) {
        self.title = @"智能安防";
    } else if (self.diyCategory == 3) {
        self.title = @"生活电器";
    } else {
        self.title = @"生活电器";
    }
    
    self.dataArray = [NSMutableArray array];
    
    self.sortArray = @[@"全部分类",@"智能家具",@"智能家具",@"智能安防",@"厨卫小电",@"生活电器"];
    self.brandArray = @[@"全部品牌",@"卫宁",@"格力",@"海尔",@"阿迪达斯"];

    self.conditionTitleView = [[CODDIYConditionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    [self.view addSubview:self.conditionTitleView];
    
    self.mCollectionView = ({
        UICollectionView *collectionView = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:CODColorBackground andFlowLayout:[UICollectionView getCollectFlowLayoutWithMinLineSpace:10 andMinInteritemSpacing:10 andItemSize:CGSizeMake((SCREENWIDTH-30)/2, (SCREENWIDTH-30)/2+10+30+10+20+10) andSectionInsert:UIEdgeInsetsMake(0, 10, 0, 10) andscrollDirection:UICollectionViewScrollDirectionVertical] andItemClass:[CODDIYCollectionViewCell class] andReuseID:kCODCateCollectionViewCell];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.emptyDataSetSource = self;
        collectionView.emptyDataSetDelegate = self;
        collectionView;
    });
    [self.view addSubview:self.mCollectionView];
    
    [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(60, 0, 0, 0));
    }];
    
    // data
    self.parameIndex = 1;
    [self refreshData];
    [self.mCollectionView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
    [self.mCollectionView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
    
    
    @weakify(self);
    [self.conditionTitleView setBtnSelectItemBlock:^(DIYConditionType condition) {
        @strongify(self);
        if (condition == ConditionTypeOne) {// 全部分类
            self.selctedItem = 1;
        } else if (condition == ConditionTypeTwo) {// 人气
            self.selctedItem = 2;
        } else {// 品牌
            self.selctedItem = 3;
        }
    }];
    
    [[RACObserve(self.popVW, isShow) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        if (self.selctedItem == 1){
            if ([x boolValue]) {
                [self.conditionTitleView.itmeBtnOne setImage:[UIImage imageNamed:@"mall_screening_selected"] forState:UIControlStateSelected];
            } else {
                [self.conditionTitleView.itmeBtnOne setImage:[UIImage imageNamed:@"mall_screening"] forState:UIControlStateSelected];
            }
        } else if (self.selctedItem == 3){
            if ([x boolValue]) {
                [self.conditionTitleView.itmeBtnThree setImage:[UIImage imageNamed:@"mall_screening_selected"] forState:UIControlStateSelected];
            } else {
                [self.conditionTitleView.itmeBtnThree setImage:[UIImage imageNamed:@"mall_screening"] forState:UIControlStateSelected];
            }
        }
    }];
    
    [RACObserve(self, selctedItem) subscribeNext:^(id x) {
        @strongify(self);
        if ([x integerValue] == 1) {
            if (self.popVW.isShow == YES) {
                [self.popVW dismiss];
            } else {
                [self.popVW showWithData:self.sortArray opitionKey:@"分类"];
                
                [self.popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
                    [self.popVW dismiss];
                    UIButton *btn = self.conditionTitleView.itmeBtnOne;
                    [btn setTitle:tle forState:0];
                    self.parameIndex = idx + 1;
                    [self refreshData];
                }];
            }
        } else if ([x integerValue] == 2) {
            if (self.popVW.isShow == YES) [self.popVW dismiss];
            self.parameIndex = 3;
            [self refreshData];
            
        } else if ([x integerValue] == 3) {
            if (self.popVW.isShow == YES) {
                [self.popVW dismiss];
            } else {
                [self.popVW showWithData:self.brandArray opitionKey:@"品牌"];
                [self.popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
                    [self.popVW dismiss];
                    UIButton *btn = self.conditionTitleView.itmeBtnThree;
                    [btn setTitle:tle forState:0];
                    self.parameIndex = idx + 1;
                    [self refreshData];
                }];
            }
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh
-(void)onRefreshing:(id)control {
    [self loadDataWithPage:1 andIsHeader:YES];
}

-(void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum {
    [self loadDataWithPage:pageNum.integerValue andIsHeader:NO];
}

#pragma mark - Data
- (void)refreshData {
    [self loadDataWithPage:1 andIsHeader:YES];
}

-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"cate_id"] = @(self.diyCategory);//装修类型：0/不传=全部；1=精装修；2=半包施工；3=自装采购；4=软装设计
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
    params[@"order_type"] = @(self.parameIndex);// 排序类型
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.mCollectionView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDIYModel class] json:object[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.mCollectionView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDIYModel class] json:object[@"data"][@"list"]];
                if (models.count < CODRequstPageSize) [self.mCollectionView noMoreData];
                [self.dataArray addObjectsFromArray:models];
            }
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.mCollectionView noMoreData];
            }
            self.mCollectionView.mj_footer.hidden = (self.dataArray.count == 0);
            [self.mCollectionView reloadData];
        } else {
            if (isHeader) {
                [self.mCollectionView endHeaderRefreshWithChangePageIndex:NO];
            } else  {
                [self.mCollectionView endFooterRefreshWithChangePageIndex:NO];
            }
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            self.mCollectionView.mj_footer.hidden = YES;
        }
    } failed:^(NSError *error) {
        if (isHeader) {
            [self.mCollectionView endHeaderRefreshWithChangePageIndex:NO];
        }else
        {
            [self.mCollectionView endFooterRefreshWithChangePageIndex:NO];
        }
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
        self.mCollectionView.mj_footer.hidden = YES;
    }];
}

#pragma mark - View
- (ConditionPopView *)popVW
{
    if (!_popVW) {
        _popVW = [[ConditionPopView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.conditionTitleView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetHeight(self.conditionTitleView.frame)) supView:self.view];
//        @weakify(self);
//        [_popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
//            @strongify(self);
//            [self.popVW dismiss];
//            UIButton *btn = self.conditionTitleView.itmeBtnOne;
//            [btn setTitle:tle forState:0];
//            self.parameIndex = idx + 1;
//            [self refreshData];
//        }];
    }return _popVW;
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CODDIYCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCODCateCollectionViewCell forIndexPath:indexPath];
    cell.viewModel = (CODDIYModel*)self.dataArray[indexPath.item];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma mark - EmptyDataSet
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return kGetImage(@"icon_data_no");
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据，去别处逛逛吧" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
