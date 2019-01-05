//
//  CODAllDecorateViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/2.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODAllDecorateViewController.h"
#import "DecorateConditionView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CODDecorateTableViewCell.h"
#import "MJRefresh.h"
#import "CODCompanyDetailViewController.h"
#import "ImageBrowserViewController.h"
#import "XWXStoreDetailsItemVw.h"  // 条件选择框
#import "ConditionPopView.h"

static NSString * const kCODDecorateTableViewCell = @"CODDecorateTableViewCell";

@interface CODAllDecorateViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

/** 条件帅选框*/
@property (nonatomic, strong) DecorateConditionView *conditionTitleView;
/** 下拉视图 */
@property (nonatomic,strong) ConditionPopView *popVW;
/** 下拉选项数据*/
@property (nonatomic,strong) NSMutableArray *choseArr;


/** 个人信息数据 */
@property (nonatomic, copy) NSDictionary *imfoDic;
@property(nonatomic,strong) NSMutableArray *FenLeiTitleArr;
@property(nonatomic,strong) NSMutableArray *FenLeiIdArr;
/** 空视图*/
@property (nonatomic,strong) UIView *nullVW;
/** 页数 */
@property(nonatomic,assign) NSInteger page;
/** 请求参数*/
@property(nonatomic,strong) NSMutableDictionary *parDic;

@end

@implementation CODAllDecorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全装";
    self.choseArr = [[NSMutableArray alloc]initWithObjects:
                     @[@"综合",@"案例"],
                     @[],
                     @[],
                     nil];
    self.conditionTitleView = [[DecorateConditionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    [self.view addSubview:self.conditionTitleView];
    kWeakSelf(self)
    [self.conditionTitleView setBtnSelectItemBlock:^(ConditionType condition) {
         // 综合
        if (condition == ConditionTypeNormal) {
            if (self.popVW.isShow == YES) {
                [weakself.popVW dismiss];
            } else {
                [weakself.popVW showWithData:weakself.choseArr[0] opitionKey:@"分类"];
            }
        } else if (condition == ConditionTypePraise) {
            if (self.popVW.isShow == YES) [weakself.popVW dismiss];
            weakself.parDic[@"cat_id"] = @"";
            [weakself loadData];
        } else {
            if (self.popVW.isShow == YES) [weakself.popVW dismiss];
            weakself.parDic[@"cat_id"] = @"";
            [weakself loadData];
        }
    }];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CODDecorateTableViewCell class] forCellReuseIdentifier:kCODDecorateTableViewCell];
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    // data
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy load
-(ConditionPopView *)popVW
{
    if (!_popVW) {
        _popVW = [[ConditionPopView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.conditionTitleView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetHeight(self.conditionTitleView.frame)) supView:self.view];
        kWeakSelf(self)
        [_popVW setSelectBlock:^(NSString *key, NSInteger idx,NSString *tle) {
            [weakself.popVW dismiss];
//            UIButton *btn = weakself.conditionTitleView.recodeChoseDic[@"select"];
            UIButton *btn = weakself.conditionTitleView.itmeBtnOne;

            [btn setTitle:tle forState:0];
           
            weakself.parDic[@"cat_id"] = weakself.FenLeiIdArr[idx];
            [weakself loadData];
        }];
        
    }return _popVW;
}
#pragma mark - Net load
- (void)loadData
{
    self.dataArray = @[@""];
    [self.tableView.mj_header endRefreshing];
}

- (void)LoadMoreData
{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODDecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODDecorateTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithModel:self.dataArray[indexPath.row]];
    NSArray *arr = @[@"",@"",@""];
//    __weak CODImageLayoutView *weakImageLayoutView = cell.corverImageView;
    cell.corverImageView.singleTap = ^(NSUInteger index) {
        if ([UIViewController getCurrentVC]) {
            [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
                return arr;
            }];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CODDecorateTableViewCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODCompanyDetailViewController *detailVC = [[CODCompanyDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
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
