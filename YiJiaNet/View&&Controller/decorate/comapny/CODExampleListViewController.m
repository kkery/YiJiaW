//
//  CODExampleListViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/2.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODExampleListViewController.h"
#import "CODExampleTableViewCell.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CODExamDetailViewController.h"
#import "CQPlaceholderView.h"

static NSString * const kCODExampleTableViewCell = @"CODExampleTableViewCell";

@interface CODExampleListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property(nonatomic,strong) CQPlaceholderView *placeholderView;
@property(nonatomic,assign) NSInteger page;

@end

@implementation CODExampleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"装修案例";
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CODExampleTableViewCell class] forCellReuseIdentifier:kCODExampleTableViewCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
#pragma mark - Net load
- (void)loadData {
    [self.tableView resetNoMoreData];
    self.page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.companyId;
    params[@"page"] = @(1);
    params[@"pagesize"] = @(CODRequstPageSize);
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=cases" andParameters:params Sucess:^(id object) {
        [self.tableView.mj_header endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            NSArray *models = [NSArray modelArrayWithClass:[CODDectateExampleModel class] json:object[@"data"][@"list"]];
            if (models.count > 0) {
                self.page++;
                self.tableView.backgroundView = nil;
            } else {
                self.tableView.backgroundView = self.placeholderView;
            }
            self.dataArray = models;
            self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
            }
            [self.tableView reloadData];
            
        } else {
            self.tableView.mj_footer.hidden = YES;
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

- (void)LoadMoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.companyId;
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(CODRequstPageSize);
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=cases" andParameters:params Sucess:^(id object) {
        [self.tableView.mj_footer endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
            NSArray *models = [NSArray modelArrayWithClass:[CODDectateExampleModel class] json:object[@"data"][@"list"]];
            [array addObjectsFromArray:models];
            self.dataArray = array;
            self.page++;
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
            }
            [self.tableView reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODExampleTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithModel:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CODExampleTableViewCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODExamDetailViewController *detailVC = [[CODExamDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CQPlaceholderView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc] initWithFrame:self.tableView.bounds type:CQPlaceholderViewTypeNoGoods delegate:self];
        _placeholderView.backgroundColor = [UIColor whiteColor];
        _placeholderView.imageView.image = [UIImage imageNamed:@"icon_data_no"];
        _placeholderView.descLabel.text = @"还没有数据，快去逛逛吧~";
    }return _placeholderView;
}
@end
