//
//  CODMineViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODMineViewController.h"
#import "CODLoginViewController.h"
#import "CODMainNavController.h"
#import "UINavigationBar+COD.h"
#import "UIButton+COD.h"
#import "UIView+BlockGesture.h"
#import "UIViewController+COD.h"
#import "XWXShareView.h"
#import "CODMessageViewController.h"
#import "CODMineOrderViewController.h"
#import "CODMineMeasureViewController.h"
#import "CODOwnerViewController.h"
#import "CODAuthenViewController.h"
#import "CODAuthenStatusViewController.h"
#import "CODSettingViewController.h"
#import "CODHistoryViewController.h"
#import "CODCollectViewController.h"
#import "CODFeedViewController.h"
#import "CODPersonInfoViewController.h"

static NSString * const kMineTicketCell = @"MineTicketCell";
static NSString * const kBaseCell = @"BaseCell";

static CGFloat const kCoverHeaderViewHeight = 208;
static CGFloat const kWhiteBackViewHeight = 124;

@interface CODMineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UILabel *navLabel;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *backHeaderImgaeView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *authenLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CODMineViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    
    // configure view
    [self configureView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageButton];
    
    // data
    self.dataSource = @[
                      @{@"title":@"我的收藏",@"icon":@"my_collection"},
                      @{@"title":@"消息中心",@"icon":@"my_message"},
                      @{@"title":@"我的足迹",@"icon":@"my_footprint"},
                      @{@"title":@"意见反馈",@"icon":@"my_opinion"},
                      @{@"title":@"客服中心",@"icon":@"my_service"},
                      @{@"title":@"推荐给好友",@"icon":@"my_reference"},
                      ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    [self wr_setNavBarShadowImageHidden:YES];
//    [self wr_setNavBarBackgroundAlpha:0.0];
//    if (@available(iOS 11.0, *)) {
//        // tableView 偏移20/64适配
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    self.navigationController.navigationBar.translucent = YES;
//
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

#pragma mark - View
- (void)configureView {
    [self configureTableView];
    [self configureHeaderView];
    [self configureThreeItemView];
}

- (void)configureTableView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 解决状态栏20高度问题
    adjustsScrollViewInsets(self.tableView);
}

- (void)configureHeaderView {
    self.topView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kCoverHeaderViewHeight+kWhiteBackViewHeight-30)];
        view;
    });
    self.backHeaderImgaeView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"my_head_bg"];
        imageView.frame = CGRectMake(0, 0, SCREENWIDTH, kCoverHeaderViewHeight);
        imageView.userInteractionEnabled = YES;
        [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self gotoPersonInfo];
        }];
        imageView;
    });
    [self.topView addSubview:self.backHeaderImgaeView];
    
    self.tableView.tableHeaderView = self.topView;
    
    self.navLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = kFont(18);
        label.textColor = [UIColor whiteColor];
        label.text = @"我的";
        label.textAlignment = 1;
        label;
    });
    [self.backHeaderImgaeView addSubview:self.navLabel];

    self.messageButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button setImage:[UIImage imageNamed:@"my_owner"] forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self gotoSetting];
        }];
        button;
    });
    [self.backHeaderImgaeView addSubview:self.messageButton];

    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 35;
        imageView;
    });
    [self.backHeaderImgaeView addSubview:self.avatarImageView];
    
    self.nicknameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CODColorWhite;
        label.font = [UIFont systemFontOfSize:17];
        label;
    });
    [self.backHeaderImgaeView addSubview:self.nicknameLabel];
    
    self.authenLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = CODColorWhite;
        label.font = [UIFont systemFontOfSize:11];
        label.text = @"未实名认证>";
        label.backgroundColor = CODRgbColor(25, 143, 202);
        label.layer.cornerRadius = 12;
        label.layer.masksToBounds = YES;
        label.textAlignment = 1;
        label.userInteractionEnabled = YES;
        [label addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self authenAction];
        }];
        label;
    });
    [self.backHeaderImgaeView addSubview:self.authenLabel];
    
    self.arrowImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"my_home_bg_arrow"];
        imageView;
    });
    [self.backHeaderImgaeView addSubview:self.arrowImageView];
    // 约束
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backHeaderImgaeView).offset(30);
        make.centerX.offset(0);
        make.width.equalTo(@100);
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.backHeaderImgaeView).offset(30);
        make.right.equalTo(self.backHeaderImgaeView).offset(-15);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@70);
        make.centerY.equalTo(self.backHeaderImgaeView.mas_centerY);
        make.left.equalTo(self.backHeaderImgaeView).offset(20);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(self.avatarImageView.mas_top).offset(10);
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
    }];
    [self.authenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
        make.width.equalTo(@80);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backHeaderImgaeView.mas_right).offset(-20);
        make.centerY.equalTo(self.backHeaderImgaeView.mas_centerY);
    }];
    
    [self updateTableHeaderViewInfo];
}

- (void)configureThreeItemView {
    UIImageView *whiteBackImgaeView = [[UIImageView alloc] init];
    whiteBackImgaeView.userInteractionEnabled = YES;
    whiteBackImgaeView.image = kGetImage(@"my_projection_bg");
    [self.topView addSubview:whiteBackImgaeView];
    [whiteBackImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.top.equalTo(self.backHeaderImgaeView.mas_bottom).offset(-30);
        make.height.equalTo(@(kWhiteBackViewHeight));
    }];
    NSArray *items = @[@{@"title":@"我的预约",@"icon":@"my_amount"}, @{@"title":@"我的量房",@"icon":@"my_appointment"},@{@"title":@"我是业主",@"icon":@"my_owner-1"}];
    CGFloat item_width = (SCREENWIDTH-24) / items.count;
    for (NSInteger i = 0; i<items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn SetBtnTitle:items[i][@"title"] andTitleColor:CODColor333333 andFont:kFont(14) andBgColor:nil andBgImg:nil andImg:kGetImage(items[i][@"icon"]) andClickEvent:@selector(itemBtnAction:) andAddVC:self];
        btn.tag = i+100;
        [whiteBackImgaeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteBackImgaeView.mas_left).offset(i * item_width);
            make.width.mas_equalTo(item_width);
            make.centerY.equalTo(whiteBackImgaeView.mas_centerY);
        }];
        [btn cod_alignImageUpAndTitleDownWithPadding:25];
    }
}

- (void)itemBtnAction:(UIButton *)btn {
    if (btn.tag == 100) {
        CODMineOrderViewController *VC = [[CODMineOrderViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (btn.tag == 101) {
        CODMineMeasureViewController *VC = [[CODMineMeasureViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (btn.tag == 102) {
        CODOwnerViewController *VC = [[CODOwnerViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark - Update
- (void)updateTableHeaderViewInfo {
//    if (COD_LOGGED) {
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CODUserModel unarchive].logo] placeholderImage:[UIImage imageNamed:@"moren_touxiang"]];
//        self.nicknameLabel.text = [CODUserModel unarchive].name ?: @"还没有昵称哦";
//        self.authenLabel.text = [NSString stringWithFormat:@"积分: %@", @([CODUserModel unarchive].integral)];
//    } else {
//        self.avatarImageView.image = [UIImage imageNamed:@"moren_touxiang"];
//        self.nicknameLabel.text = @"您还没有登录哦";
//        self.authenLabel.text = @"立即登录";
//    }
    self.avatarImageView.image = [UIImage imageNamed:@"place_default_avatar"];
    self.nicknameLabel.text = @"您还没有登录哦";
    self.authenLabel.text = @"未实名认证>";
}

#pragma mark - Accessors

#pragma mark - Notification

#pragma mark - Data
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = CODColor333333;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#9D9D9D"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.imageView.image = kGetImage(self.dataSource[indexPath.row][@"icon"]);
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"我的收藏"]) {
        CODCollectViewController *collectVC = [[CODCollectViewController alloc] init];
        [self.navigationController pushViewController:collectVC animated:YES];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"消息中心"]) {
        CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"我的足迹"]) {
        CODHistoryViewController *historyVC = [[CODHistoryViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"意见反馈"]) {
        CODFeedViewController *feedVC = [[CODFeedViewController alloc] init];
        [self.navigationController pushViewController:feedVC animated:YES];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"客服中心"]) {
        [self alertVcTitle:nil message:@"拨打10086" leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
        } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
            dispatch_async(dispatch_get_main_queue(), ^{;
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",@"10086"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            });
        }];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"推荐给好友"]) {
        XWXShareView *ShareView = [[XWXShareView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [ShareView show];
    }
}

#pragma mark - Action
- (void)gotoLogin {
    CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
    UINavigationController *navigationController = [[CODMainNavController alloc] initWithRootViewController:loginViewController];
//    loginViewController.loginBlock = ^(void) {
//        if (COD_LOGGED) {
//            NSLog(@"login success");
//        } else {
//            NSLog(@"login fail");
//        }
//        [self updateTableHeaderViewInfo];
//        [self fetchMessageUnreadCount];
//    };
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)gotoSetting {
    CODSettingViewController *setVC = [[CODSettingViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)gotoPersonInfo {
    CODPersonInfoViewController *infoVC = [[CODPersonInfoViewController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}
- (void)authenAction {
    //（1审核中、2审核失败、3审核成功、4未认证）
    NSInteger status = 4;
    if (status == 4) {
        CODAuthenViewController *authenVC = [[CODAuthenViewController alloc] init];
        [self.navigationController pushViewController:authenVC animated:YES];
    } else if (status == 3) {
        CODAuthenStatusViewController *authenVC = [[CODAuthenStatusViewController alloc] init];
        authenVC.status = status;
        [self.navigationController pushViewController:authenVC animated:YES];
    } else {
        CODBaseWebViewController *webView = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
        webView.webTitleString = @"实名认证";
        [self.navigationController pushViewController:webView animated:YES];

    }
}

@end
