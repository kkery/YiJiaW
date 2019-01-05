//
//  CODSettingViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/4.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODSettingViewController.h"
#import "CODForgetPwdViewController.h"
#import "UIViewController+COD.h"
#import "CODSetPwdViewController.h"

@interface CODSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) CGFloat cacheSize;

@end

@implementation CODSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        UIView *tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
            view;
        });
        UIButton *logoutButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 10, SCREENWIDTH, 50);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:CODColor333333 forState:UIControlStateNormal];
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self logout];
            }];
            button;
        });
        [tableFooterView addSubview:logoutButton];
        tableView.tableFooterView = tableFooterView;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    // data
    NSString *vers = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.version = [NSString stringWithFormat:@"V%.1f",  [vers floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCellID = @"cellID";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBaseCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = XFONT_SIZE(15);
        cell.textLabel.textColor = CODColor333333;
        cell.detailTextLabel.font = XFONT_SIZE(15);
        cell.detailTextLabel.textColor = CODColor666666;
    }
    cell.textLabel.text = @[@"登录密码", @"服务条款", @"隐私政策", @"关于我们", @"检查新版本", @"清空缓存"][indexPath.row];
    
    if (indexPath.row == 4) {
        cell.detailTextLabel.text = self.version;
    }
    if (indexPath.row == 5) {
        cell.detailTextLabel.text = kFORMAT(@"%.1fM", self.cacheSize);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CODSetPwdViewController *VC = [[CODSetPwdViewController alloc] init];
        VC.status = 2;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        CODBaseWebViewController *webView = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
        webView.webTitleString = @"服务条款";
        [self.navigationController pushViewController:webView animated:YES];
    } else if (indexPath.row == 2) {
        CODBaseWebViewController *webView = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
        webView.webTitleString = @"隐私政策";
        [self.navigationController pushViewController:webView animated:YES];
    } else if (indexPath.row == 3) {
        CODBaseWebViewController *webView = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
        webView.webTitleString = @"关于我们";
        [self.navigationController pushViewController:webView animated:YES];
    } else if (indexPath.row == 4) {
    } else if (indexPath.row == 5) {
        [self clearCache];
    }
    
}

- (void)logout {
    [self showAlertWithTitle:@"确定退出登录吗" andMesage:nil andCancel:^(id cancel) {
    } Determine:^(id determine) {
        
    }];
}

- (void)clearCache {
    [self showAlertWithTitle:@"确定清除缓存吗" andMesage:nil andCancel:^(id cancel) {
    } Determine:^(id determine) {
        [SVProgressHUD cod_showWithSuccessInfo:@"清除缓存成功"];
        [self.tableView reloadData];
    }];
}

@end
