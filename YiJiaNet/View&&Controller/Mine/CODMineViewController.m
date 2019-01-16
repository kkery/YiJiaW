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
#import "CODAuthenInfoViewController.h"
#import "CODAuthenStatusViewController.h"
#import "CODSettingViewController.h"
#import "CODHistoryViewController.h"
#import "CODCollectViewController.h"
#import "CODFeedViewController.h"
#import "CODPersonInfoViewController.h"
#import "CODUserModel.h"

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CODRefeshMineNotificationName object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kNotiCenter addObserver:self selector:@selector(refeshMineNotification) name:CODRefeshMineNotificationName object:nil];

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
    
//    if (COD_LOGGED) {
//        [self loadUserInfo];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (COD_LOGGED) {
        [self loadUserInfo];
    }
    [self updateTableHeaderViewInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)refeshMineNotification {
    [self loadUserInfo];
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

#pragma mark - Data
- (void)loadUserInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;

    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=user_info" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            save(object[@"data"][@"info"], CODUserInfoKey);
            [self updateTableHeaderViewInfo];
            
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - Update Data
- (void)updateTableHeaderViewInfo {
    NSDictionary *user = get(CODUserInfoKey);
    if (COD_LOGGED) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"place_default_avatar"]];
        self.nicknameLabel.text = user[@"nickname"] ?: @"还没有昵称哦";
        self.authenLabel.text = ([user[@"approve_status"] integerValue] == 1) ? @"已实名认证" : @"未实名认证";

    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"place_default_avatar"];
        self.nicknameLabel.text = @"您还没有登录哦";
        self.authenLabel.text = @"未实名认证>";
    }
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
        [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", get(CODServiceTelKey)) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
        } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:get(CODServiceTelKey)] options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:get(CODServiceTelKey)]];
                }
            });
        }];
    } else if ([self.dataSource[indexPath.row][@"title"] isEqualToString:@"推荐给好友"]) {
        XWXShareView *shareView = [[XWXShareView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"分享标题", @"share_title",
                             @"分享内容", @"share_content",
                             nil ];
        shareView.dic = dic;

        shareView.navSelf = self;
        [shareView show];
    }
}

#pragma mark - Action
- (void)gotoSetting {
    if (COD_LOGGED) {
        CODSettingViewController *setVC = [[CODSettingViewController alloc] init];
        [self.navigationController pushViewController:setVC animated:YES];
    } else {
        [SVProgressHUD cod_showWithErrorInfo:@"未登录,请先登录"];
    }
}
- (void)gotoPersonInfo {
    if (!COD_LOGGED) {
        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        CODPersonInfoViewController *infoVC = [[CODPersonInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}
- (void)authenAction {
    if (!COD_LOGGED) {
        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        //0认证中 1成功 2失败 3未认证
        NSInteger AuthenStatus = [get(CODUserInfoKey)[@"approve_status"] integerValue];
        if (AuthenStatus == 3) {
            CODAuthenViewController *authenVC = [[CODAuthenViewController alloc] init];
            [self.navigationController pushViewController:authenVC animated:YES];
        } else if (AuthenStatus == 1) {
            CODAuthenInfoViewController *authenInfoVC = [[CODAuthenInfoViewController alloc] init];
            [self.navigationController pushViewController:authenInfoVC animated:YES];
        } else {
            CODAuthenStatusViewController *authenVC = [[CODAuthenStatusViewController alloc] init];
            authenVC.status = AuthenStatus;
            [self.navigationController pushViewController:authenVC animated:YES];
        }
    }
}

@end
