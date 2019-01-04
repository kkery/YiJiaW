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
    self.dataArr = [[NSMutableArray alloc]init];
    self.parDic = [NSMutableDictionary new];
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
            self.parDic[@"type"] = @"";
        } else if(indexCount == 1) {
            // 好评
            self.parDic[@"type"] = @"good";
        } else if(indexCount == 2) {
            // 中评
            self.parDic[@"type"] = @"normal";
        } else if(indexCount == 3) {
            // 差评
            self.parDic[@"type"] = @"bad";
        }
        [self loadGoodsData];
    }];
    
}

#pragma mark - Net load
-(void)loadGoodsData
{
    self.page = 1;
    self.parDic[@"page"] = @1;
    self.parDic[@"item_id"] = self.shop_id;
    self.parDic[@"param"] = self.Vc_Type;
    
//    [[TWHNetWorkQuery sharedManage] AFrequestData:mHome cPar:@"Comment" aPar:@"index" HttpMethod:kGet params:self.parDic completionHandle:^(id result) {
//        if (kMessage(result)) {
//            [self.dataArr removeAllObjects];
//            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MyCommentImfoMode class] json:result[@"data"][@"result"]]];
//
//            self.baseTabeleviewGrouped.mj_footer.hidden = (self.dataArr.count == 0);
//            if (self.dataArr.count >= [kFORMAT(@"%@",result[@"data"][@"pageCount"]) floatValue]) {
//                [self.baseTabeleviewGrouped.mj_footer endRefreshingWithNoMoreData];
//            }else
//            {
//                [self.baseTabeleviewGrouped.mj_footer endRefreshing];
//            }
//
//            if (self.dataArr.count >0) {
//                self.baseTabeleviewGrouped.backgroundView = nil;
//            } else {
//                self.baseTabeleviewGrouped.backgroundView = self.nullVW;
//            }
//
//            self.Dic = [NSDictionary getValuesForKeysWithDictionary:result[@"data"][@"comment_count"]];
//            self.kindVW.kinArr = @[kFORMAT(@"全部(%ld)",[self.Dic[@"all"] integerValue]),kFORMAT(@"好评(%ld)",[self.Dic[@"good"] integerValue]),kFORMAT(@"中评(%ld)",[self.Dic[@"normal"] integerValue]),kFORMAT(@"差评(%ld)",[self.Dic[@"bad"] integerValue])];
//
//            self.kindVW.countStr = kFORMAT(@"宝贝评价(%ld)",[self.Dic[@"all"] integerValue]);
//
//            [self.baseTabeleviewGrouped.mj_header endRefreshing];
//            [self.baseTabeleviewGrouped reloadData];
//
//        }else{
//            if ([[result allKeys] containsObject:@"message"] && ![result[@"message"] isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD TWH_showWithErrorInfo:result[@"message"]];
//            }else{
//                kGetFailError;
//            }
//            self.baseTabeleviewGrouped.mj_footer.hidden = YES;
//        }
//    } errorHandle:^(NSError *result) {
//        self.baseTabeleviewGrouped.mj_footer.hidden = YES;
//        kNetError;
//    }];
    
}

- (void)LoadMoreData
{
    self.page ++;
    self.parDic[@"page"] = @(self.page);
    self.parDic[@"item_id"] = self.shop_id;
    //    self.parDic[@"item_id"] = @"2441";
    self.parDic[@"param"] = self.Vc_Type;
//    [[TWHNetWorkQuery sharedManage] AFrequestData:mHome cPar:@"Comment" aPar:@"index" HttpMethod:kGet params:self.parDic completionHandle:^(id result) {
//        if (kMessage(result)) {
//            
//            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MyCommentImfoMode class] json:result[@"data"][@"reslut"]]];
//            
//            if (self.dataArr.count >= [kFORMAT(@"%@",result[@"data"][@"pageCount"]) floatValue]) {
//                [self.baseTabeleviewGrouped.mj_footer endRefreshingWithNoMoreData];
//            }else
//            {
//                [self.baseTabeleviewGrouped.mj_footer endRefreshing];
//            }
//            
//            [self.baseTabeleviewGrouped.mj_header endRefreshing];
//            [self.baseTabeleviewGrouped reloadData];
//            
//        }else{
//            if ([[result allKeys] containsObject:@"message"] && ![result[@"message"] isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD TWH_showWithErrorInfo:result[@"message"]];
//            }else{
//                kGetFailError;
//            }
//        }
//    } errorHandle:^(NSError *result) {
//        kNetError;
//    }];
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
