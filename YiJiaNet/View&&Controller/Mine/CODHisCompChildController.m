//
//  CODHisCompChildController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODHisCompChildController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "CODBaseWebViewController.h"
#import "CODHisCompTableViewCell.h"
#import "ImageBrowserViewController.h"
#import "CODCompanyDetailViewController.h"
#import "CODDateSectionHeaderView.h"

static NSString * const kCODHisCompTableViewCell = @"CODHisCompTableViewCell";

@interface CODHisCompChildController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSMutableArray *companyArray;

@end

@implementation CODHisCompChildController

- (void)dealloc {
    [kNotiCenter removeObserver:self name:CODDeleteHistotyNotificationName object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotiCenter addObserver:self selector:@selector(deleteNotification) name:CODDeleteHistotyNotificationName object:nil];

    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];

    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[CODHisCompTableViewCell class] forCellReuseIdentifier:kCODHisCompTableViewCell];
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // data
    [self.tableView addHeaderWithHeaderClass:nil beginRefresh:YES delegate:self animation:YES];
    [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
    
    [self.view addSubview:self.tableView];
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

- (void)deleteNotification {
    [self loadDataWithPage:1 andIsHeader:YES];
}

#pragma mark - Data
-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"type"] = @(1);//1装修公司 2新房 3二手房 4长租房
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=Setting&a=browseList" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODHistroyModel class] json:object[@"data"][@"result"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODHistroyModel class] json:object[@"data"][@"result"]];
                [self.dataArray addObjectsFromArray:models];
            }
            
            for (CODHistroyModel *history in self.dataArray) {
                [self.companyArray addObject:history.browse];
            }

            if (self.companyArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
            }
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CODHistroyModel *history = self.dataArray[section];
    return history.browse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODHisCompTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODHisCompTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CODHistroyModel *history = self.dataArray[indexPath.section];
    CODDectateListModel *model = history.browse[indexPath.row];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODHistroyModel *history = self.dataArray[indexPath.section];
    CODDectateListModel *model = history.browse[indexPath.row];
    CODCompanyDetailViewController *detailVC = [[CODCompanyDetailViewController alloc] init];
    detailVC.companyId = model.compId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODHistroyModel *history = self.dataArray[indexPath.section];
    CODDectateListModel *model = history.browse[indexPath.row];
    if (model.images.count > 0) {
        return [CODHisCompTableViewCell heightForRow];
    } else {
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString * const kSectionHeaderViewID = @"sectionHeaderViewID";
    CODDateSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewID];
    if (!headerView) {
        headerView = [[CODDateSectionHeaderView alloc] initWithReuseIdentifier:kSectionHeaderViewID];
    }
    headerView.model = (CODHistroyModel*)self.dataArray[section];
    return headerView;
}

#pragma mark - EmptyDataSet
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return kGetImage(@"icon_data_no");
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"数据空空如也，快去逛一逛吧~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end
