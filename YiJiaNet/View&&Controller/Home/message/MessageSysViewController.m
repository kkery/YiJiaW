//
//  MessageSysViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "MessageSysViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "CODBaseWebViewController.h"
#import "CODMessageModel.h"

static NSString * const kCell = @"CODHotTableViewCell";

@interface MessageSysViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MessageSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"系统消息";
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = CODColorBackground;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
//        [tableView registerClass:[CODHotTableViewCell class] forCellReuseIdentifier:kCell];
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
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

#pragma mark - Data
-(void)loadDataWithPage:(NSInteger)pageNum andIsHeader:(BOOL)isHeader {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"type"] = @(self.type);//消息类型，1系统2预约3活动
    params[@"page"] = @(pageNum);
    params[@"pagesize"] = @(CODRequstPageSize);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=message&a=msg_list" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            if (isHeader) {
                [self.tableView endHeaderRefreshWithChangePageIndex:YES];
                self.dataArray = [NSArray modelArrayWithClass:[CODMessageModel class] json:object[@"data"][@"list"]];;
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODMessageModel class] json:object[@"data"][@"list"]];
                NSMutableArray *messages = [NSMutableArray arrayWithArray:self.dataArray];
                [messages addObjectsFromArray:models];
                self.dataArray = messages;
            }
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCellID = @"cellID";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBaseCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-30, 20)];
        titleLabel.textColor = CODColor333333;
        titleLabel.tag = 1;
        titleLabel.font = kFont(15);
        [cell.contentView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREENWIDTH-30, 20)];
        subTitleLabel.textColor = CODColor999999;
        subTitleLabel.tag = 2;
        subTitleLabel.font = kFont(12);
        [cell.contentView addSubview:subTitleLabel];
    }
    
    CODMessageModel *message = [self.dataArray objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *subTitleLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    titleLabel.text = message.title;
    subTitleLabel.text = message.send_time;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
//    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - EmptyDataSet
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return kGetImage(@"icon_message_no");
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"还没有消息，快去逛逛吧~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
