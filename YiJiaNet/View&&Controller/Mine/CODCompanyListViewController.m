//
//  CODCompanyListViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/5.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCompanyListViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "CODBaseWebViewController.h"
#import "CODDecorateTableViewCell.h"
#import "ImageBrowserViewController.h"
#import "CODCompanyDetailViewController.h"

static NSString * const kCODDecorateTableViewCell = @"CODDecorateTableViewCell";

@interface CODCompanyListViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CODCompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[CODDecorateTableViewCell class] forCellReuseIdentifier:kCODDecorateTableViewCell];
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
    [self loadDataWithPage:1 andIsHeader:YES];
    [self.tableView addHeaderWithHeaderClass:nil beginRefresh:NO delegate:self animation:YES];
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

#pragma mark - Data
-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"type"] = @(1);//1装修公司 2新房 3二手房 4长租房
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=collect&a=indexs" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"result"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODDectateListModel class] json:object[@"data"][@"result"]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODDectateListModel *model = self.dataArray[indexPath.row];
    
    if (model.images.count > 0) {
        return [CODDecorateTableViewCell heightForRow];
    } else {
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODCompanyDetailViewController *detailVC = [[CODCompanyDetailViewController alloc] init];
    detailVC.companyId = [(CODDectateListModel *)self.dataArray[indexPath.row] compId];
    [self.navigationController pushViewController:detailVC animated:YES];
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
