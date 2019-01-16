//
//  CODHotViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODHotViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CODHotTableViewCell.h"
#import "MJRefresh.h"
#import "CODHotDetailViewController.h"

static NSString * const kCell = @"CODHotTableViewCell";

@interface CODHotViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CODHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"益家头条";
    self.dataArray = [NSMutableArray array];
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[CODHotTableViewCell class] forCellReuseIdentifier:kCell];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // data
    [self loadDataWithPage:1 andIsHeader:YES];
    [self.tableView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
    [self.tableView addFooterWithFooterClass:nil automaticallyRefresh:YES delegate:self];
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
-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=head_lines" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODHotModel class] json:object[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODHotModel class] json:object[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:models];
            }
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
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
        }
    } failed:^(NSError *error) {
        if (isHeader) {
            [self.tableView endHeaderRefreshWithChangePageIndex:NO];
        }else
        {
            [self.tableView endFooterRefreshWithChangePageIndex:NO];
        }
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    [cell configureWithModel:(CODHotModel *)self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CODHotTableViewCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODHotModel *hot = self.dataArray[indexPath.row];
    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:hot.url];
    [self.navigationController pushViewController:webVC animated:YES];
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

@end
