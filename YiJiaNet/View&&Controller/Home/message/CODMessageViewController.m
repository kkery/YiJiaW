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

static NSString * const kCell = @"MessageTypeTableViewCell";

@interface CODMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CODMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    
    self.dataArray = @[@{@"title":@"系统消息",@"icon":@"message_system"},
                       @{@"title":@"预约消息",@"icon":@"message_appointment"},
                       @{@"title":@"活动消息",@"icon":@"message_appointment"}];
    
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MessageTypeTableViewCell class] forCellReuseIdentifier:kCell];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    [cell configureWithModel:self.dataArray[indexPath.row]];
    if (indexPath.row == 0) {
        cell.detailLable.hidden = YES;
        cell.badgeView.hidden = YES;
        cell.badgeView.badgeValue = @"1";
    } else {
        cell.detailLable.hidden = NO;
        cell.badgeView.hidden = YES;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MessageTypeTableViewCell heightForRow];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MessageSysViewController *sysVC = [[MessageSysViewController alloc] init];
        [self.navigationController pushViewController:sysVC animated:YES];
    } else if (indexPath.row == 1) {
        MessageOrderViewController *sysVC = [[MessageOrderViewController alloc] init];
        [self.navigationController pushViewController:sysVC animated:YES];
    } else {
        MessageOrderViewController *sysVC = [[MessageOrderViewController alloc] init];
        [self.navigationController pushViewController:sysVC animated:YES];
    }
}

@end
