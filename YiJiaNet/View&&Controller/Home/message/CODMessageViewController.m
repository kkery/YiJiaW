//
//  CODMessageViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODMessageViewController.h"
#import "MessageTypeTableViewCell.h"
#import "MJRefresh.h"
#import "CODBaseWebViewController.h"
#import "MessageSysViewController.h"
#import "MessageOrderViewController.h"
#import "UIView+YeeBadge.h"
#import "UIView+COD.h"

static NSString * const kCell = @"MessageTypeTableViewCell";

@interface CODMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger system_number;
@property (nonatomic, assign) NSInteger ordered_number;
@property (nonatomic, assign) NSInteger active_number;

@end

@implementation CODMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    
    self.dataArray = @[@{@"title":@"系统消息",@"icon":@"message_system"},
                       @{@"title":@"预约消息",@"icon":@"message_appointment"},
                       @{@"title":@"活动消息",@"icon":@"message_activity"}];
    
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MessageTypeTableViewCell class] forCellReuseIdentifier:kCell];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // data
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=message&a=index" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = object[@"data"][@"result"];
            self.system_number = [[dataDic objectForKey:@"system_number"] integerValue];
            self.ordered_number = [[dataDic objectForKey:@"ordered_number"] integerValue];
            self.active_number = [[dataDic objectForKey:@"active_number"] integerValue];
            [self.tableView reloadData];
            
        } else {
            
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.type = MessageTypeSystem;
            cell.unreadCount = self.system_number;
            break;
        case 1:
            cell.type = MessageTypeOrder;
            cell.unreadCount = self.ordered_number;
            break;
        default:
            cell.type = MessageTypeActivity;
            cell.unreadCount = self.active_number;
            break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageTypeTableViewCell heightForRow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MessageSysViewController *msgVC = [[MessageSysViewController alloc] init];
        msgVC.type = 1;
        [self.navigationController pushViewController:msgVC animated:YES];
    } else if (indexPath.section == 1) {
        MessageSysViewController *msgVC = [[MessageSysViewController alloc] init];
        msgVC.type = 2;
        [self.navigationController pushViewController:msgVC animated:YES];
    } else {
        MessageSysViewController *msgVC = [[MessageSysViewController alloc] init];
        msgVC.type = 3;
        [self.navigationController pushViewController:msgVC animated:YES];
    }
}

@end
