//
//  CODNewHorseViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/25.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODNewHorseViewController.h"
#import "CODNewHorseTableViewCell.h"
#import "CODIntrinsicTitleView.h"
#import "CODSearchViewController.h"
#import "CODMessageViewController.h"
#import "MJRefresh.h"
#import "UIViewController+COD.h"
#import "CODNewHsDetailViewController.h"

static NSString * const kCell = @"CODNewHorseTableViewCell";

@interface CODNewHorseViewController () <UITableViewDataSource, UITableViewDelegate, MJRefreshEXDelegate>
// 顶部导航栏组件
@property (nonatomic, strong) CODIntrinsicTitleView *titleView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UILabel *searchTextLable;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *callBtn;
// 条件筛选视图
@property (nonatomic, strong) UIView *conditionView;
// 列表
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CODNewHorseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    // configure view
    [self configureNavgationView];
    
    self.conditionView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        view.backgroundColor = CODColorBackground;
        view;
    });
    [self.view addSubview:self.conditionView];

    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[CODNewHorseTableViewCell class] forCellReuseIdentifier:kCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
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

#pragma mark - View
- (void)configureNavgationView {
    self.titleView = [[CODIntrinsicTitleView alloc] init];
    self.titleView.frame = CGRectMake(0, 0, SCREENWIDTH, CODNavigationBarHeight);
    self.navigationItem.titleView = self.titleView;
    
    self.searchView = ({
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = YES;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 14;
        view.backgroundColor = CODColorBackground;
        [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self searchAction];
        }];
        view;
    });
    [self.titleView addSubview:self.searchView];
    
    UIImageView *imag = [[UIImageView alloc] init];
    imag.image = kGetImage(@"search_icon_search");
    [self.searchView addSubview:imag];
    
    [imag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 14));
        make.centerY.equalTo(self.titleView);
        make.left.equalTo(@10);
    }];
    
    self.searchTextLable = ({
        UILabel *label = [UILabel GetLabWithFont:XFONT_SIZE(13) andTitleColor:[UIColor lightGrayColor] andTextAligment:0 andBgColor:nil andlabTitle:@"请输入商品名称"];
        label.backgroundColor = CODColorBackground;
        label;
    });
    [self.searchView addSubview:self.searchTextLable];
    
    self.callBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"home_top_service"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.titleView addSubview:self.callBtn];
    
    self.msgBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"home_top_message"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.titleView addSubview:self.msgBtn];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.left.equalTo(self.titleView.mas_left).offset(10);
        make.right.offset(-60);
        make.height.equalTo(@30);
    }];
    
    [self.searchTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.left.equalTo(self.searchView.mas_left).offset(30);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@(CODNavigationBarHeight));
        make.left.equalTo(self.searchView.mas_right).offset(10);
    }];
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@(CODNavigationBarHeight));
        make.left.equalTo(self.callBtn.mas_right).offset(10);
    }];
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
                NSArray *models = [NSArray modelArrayWithClass:[CODNewHorseModel class] json:object[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:models];
            } else {
                [self.tableView endFooterRefreshWithChangePageIndex:YES];
                NSArray *models = [NSArray modelArrayWithClass:[CODNewHorseModel class] json:object[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:models];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.dataArray.count == 0);
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CODNewHorseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
    [cell configureWithModel:(CODNewHorseModel *)self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CODNewHorseTableViewCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CODNewHorseModel *hot = self.dataArray[indexPath.row];
    CODNewHsDetailViewController *detailVC = [[CODNewHsDetailViewController alloc] init];
    detailVC.hourseId = @"97";
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Action
- (void)searchAction {
    CODSearchViewController *searchVC = [[CODSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)callAction {
    [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", get(CODServiceTelKey)) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                kCall(kFORMAT(@"%@",get(CODServiceTelKey)));
            } else {
                // Fallback on earlier versions
            }
        });
    }];
}
- (void)msgAction {
    if (COD_LOGGED) {
        CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else {
        CODLoginViewController *loginViewController = [[CODLoginViewController alloc] init];
        loginViewController.loginBlock = ^{
            CODMessageViewController *messageVC = [[CODMessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        };
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

@end
