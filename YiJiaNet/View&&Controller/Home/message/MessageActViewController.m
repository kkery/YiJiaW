//
//  MessageActViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/21.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "MessageActViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MessageActTableViewCell.h"
#import "CODOrderDetailViewController.h"
#import "MJRefresh.h"
static NSString * const kMessageActTableViewCell = @"MessageActTableViewCell";

@interface MessageActViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MessageActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"活动消息";
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MessageActTableViewCell class] forCellReuseIdentifier:kMessageActTableViewCell];
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
    params[@"user_id"] = COD_USERID;
    params[@"type"] = @(3);//消息类型，1系统2预约3活动
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
            // 取消首页红点通知
            [kNotiCenter postNotificationName:CODMsgUnreadNotificationName object:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageActTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageActTableViewCell forIndexPath:indexPath];
    CODMessageModel *message = self.dataArray[indexPath.row];
//    @weakify(self);
//    [[cell.actButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:message.url];
//        [self.navigationController pushViewController:webVC animated:YES];
//    }];
    [cell configureWithModel:message];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageActTableViewCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODMessageModel *message = self.dataArray[indexPath.row];
    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:message.url];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - EmptyDataSet
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return kGetImage(@"footprint_icon_no");
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"还没有消息，到别处逛一逛吧~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: CODHexColor(0x555555)}];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
