//
//  CODCommentViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/2.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCommentViewController.h"
#import "StoreGoodsCommentCell.h"
#import "GoodsDetailCommentGradeVW.h"
#import "MyCommentImfoMode.h"
#import "MJRefresh.h"

@interface CODCommentViewController ()

/** 评论数据 */
@property (nonatomic,strong)NSMutableArray *dataArr;
/** 评论分类视图 */
@property (nonatomic,strong)GoodsDetailCommentGradeVW *kindVW;
/** 空视图*/
@property (nonatomic,strong)UIView *nullVW;
/** 页数 */
@property(nonatomic,assign) NSInteger page;
/** 请求参数*/
@property (nonatomic,strong)NSMutableDictionary *parDic;
@property (nonatomic,strong)NSMutableDictionary *Dic;

@end

@implementation CODCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    // Do any additional setup after loading the view.
    self.dataArr = [[NSMutableArray alloc] init];
    self.parDic = [NSMutableDictionary dictionary];
    self.parDic[@"type"] = @"";
    
    [self initVariable];
    
    [self setUI];
    
    [self loadGoodsData];
}

#pragma mark - Init
-(void)initVariable
{
    self.kindVW = [[GoodsDetailCommentGradeVW alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    self.kindVW.height = self.kindVW.bounds.size.height;
    self.kindVW.kinArr = @[@"全部(0)",@"好评(0)",@"中评(0)",@"差评(0)"];
    @weakify(self);
    // 根据数据去计算高度立马返回过来
    [self.kindVW setReloadHeightBlock:^{
        @strongify(self);
        self.kindVW.height = self.kindVW.bounds.size.height;
        [self.baseTabeleviewGrouped setTableHeaderView:self.kindVW];
    }];
    
    [self.kindVW setSelectIteamBlock:^(NSInteger indexCount) {
        // 点击iteam的选中回调
        @strongify(self);
        if (indexCount == 0) {
            // 全部
            self.parDic[@"type"] = @"0";
        } else if(indexCount == 1) {
            // 好评
            self.parDic[@"type"] = @"1";
        } else if(indexCount == 2) {
            // 中评
            self.parDic[@"type"] = @"2";
        } else if(indexCount == 3) {
            // 差评
            self.parDic[@"type"] = @"3";
        }
        [self loadGoodsData];
    }];
    
}

#pragma mark - Net load
-(void)loadGoodsData
{
    [self.baseTabeleviewGrouped resetNoMoreData];
    self.page = 1;
    self.parDic[@"page"] = @1;
    self.parDic[@"id"] = self.shop_id;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=comment" andParameters:self.parDic Sucess:^(id object) {
        [self.baseTabeleviewGrouped.mj_header endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[NSArray modelArrayWithClass:[MyCommentImfoMode class] json:object[@"data"][@"list"]]];

            if (self.dataArr.count >0) {
                self.baseTabeleviewGrouped.backgroundView = nil;
            } else {
                self.baseTabeleviewGrouped.backgroundView = self.nullVW;
            }
            
            self.Dic = [NSDictionary getValuesForKeysWithDictionary:object[@"data"]];
            self.kindVW.kinArr = @[kFORMAT(@"全部(%ld)",[self.Dic[@"all_number"] integerValue]),kFORMAT(@"好评(%ld)",[self.Dic[@"good_number"] integerValue]),kFORMAT(@"中评(%ld)",[self.Dic[@"mid_number"] integerValue]),kFORMAT(@"差评(%ld)",[self.Dic[@"bad_number"] integerValue])];
        
            self.baseTabeleviewGrouped.mj_footer.hidden = (self.dataArr.count == 0);
            if (self.dataArr.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.baseTabeleviewGrouped noMoreData];
            }
            [self.baseTabeleviewGrouped reloadData];
            
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];

            self.baseTabeleviewGrouped.mj_footer.hidden = YES;
        }
    } failed:^(NSError *error) {
        [self.baseTabeleviewGrouped.mj_header endRefreshing];
        self.baseTabeleviewGrouped.mj_footer.hidden = YES;
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

- (void)LoadMoreData
{
    self.page ++;
    self.parDic[@"page"] = @(self.page);
    self.parDic[@"item_id"] = self.shop_id;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=comment" andParameters:self.parDic Sucess:^(id object) {
        [self.self.baseTabeleviewGrouped.mj_footer endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            [self.dataArr addObjectsFromArray:[NSArray modelArrayWithClass:[MyCommentImfoMode class] json:object[@"data"][@"list"]]];
            if (self.dataArr.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.baseTabeleviewGrouped noMoreData];
            }
            [self.baseTabeleviewGrouped reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [self.baseTabeleviewGrouped.mj_footer endRefreshing];
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - UI
-(void)setUI
{
    [self.baseTabeleviewGrouped setTableHeaderView:self.kindVW];
    kNoneSepLine(self.baseTabeleviewGrouped);
    self.baseTabeleviewGrouped.bounces = NO;
    self.baseTabeleviewGrouped.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
    [self.view addSubview:self.baseTabeleviewGrouped];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArr.count >0) {
        self.baseTabeleviewGrouped.backgroundView = nil;
    } else {
        self.baseTabeleviewGrouped.backgroundView = self.nullVW;
    }
    self.baseTabeleviewGrouped.mj_footer.hidden = (self.dataArr.count == 0);
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ((MyCommentImfoMode *)(self.dataArr[indexPath.section])).rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreGoodsCommentCell *cell = [StoreGoodsCommentCell cellWithTableView:tableView reuseIdentifier:kFORMAT(@"%@",indexPath)];
    cell.add_timeStr = @"1";
    cell.imfo_mode = self.dataArr[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


#pragma mark - Click Event

#pragma mark - Lazy load
-(UIView *)nullVW{
    if (!_nullVW) {
        _nullVW = [UIView getAViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.baseTabeleviewGrouped.frame)) andBgColor:[UIColor whiteColor]];
        
        UILabel *alert_lab = [UILabel GetLabWithFont:kFont(14) andTitleColor:[UIColor lightGrayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"亲,还没有数据哦~"];
        [_nullVW addSubview:alert_lab];
        [alert_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_nullVW.mas_centerX);
            make.centerY.equalTo(_nullVW.mas_centerY).offset(50);
        }];
        
        UIImageView *icon = [[UIImageView alloc]initWithImage:kGetImage(@"icon_data_no")];
        [_nullVW addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_nullVW.mas_centerX);
            make.bottom.equalTo(alert_lab.mas_top).offset(-20);
        }];
    }return _nullVW;
}


@end
