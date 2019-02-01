//
//  CODGoodsDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODGoodsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "UIButton+COD.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CODCompanyDetailModel.h"
#import "JXMapNavigationView.h"
#import "CODDIYDetailViewController.h"

static CGFloat const kTopViewHeight = 375;// 顶部图高度
#define kOffsety 200.f  // 导航栏渐变的判定值

@interface CODGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, WKNavigationDelegate>
/** 导航栏 */
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic,strong) UIButton *returnBtn;
@property (nonatomic,strong) UIButton *homeBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *scrollImgNumLabel;

@property (nonatomic, strong) JXMapNavigationView *mapNavigationView;
@property (nonatomic,strong) CODCompanyDetailModel *MModel;

//图文页
//@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewHeight;

@end

@implementation CODGoodsDetailViewController

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetNav];
    // view
    [self configureView];
    // data
    [self loadMerchantData];
    
    @weakify(self);
    [[RACObserve(self, MModel) distinctUntilChanged] subscribeNext:^(CODCompanyDetailModel *mod) {
        @strongify(self);
        self.navTitleLabel.text = mod.name;
        self.bannerView.imageURLStringsGroup = mod.images;
        self.scrollImgNumLabel.hidden = (mod.images.count == 0);
        [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(1), @(self.MModel.images.count))];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        // tableView 偏移20/64适配
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = YES;
    self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
- (void)loadMerchantData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.goodsId;
    params[@"user_id"] = COD_USERID;
    [SVProgressHUD cod_showStatu];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=merchant" andParameters:params Sucess:^(id object) {
        [self.tableView.mj_header endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            CODCompanyDetailModel *model = [CODCompanyDetailModel modelWithJSON:object[@"data"][@"info"]];
            self.MModel = model;
            [self.tableView reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - View
- (void)configureView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableHeaderView = self.topView;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMerchantData)];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight)];
    
    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
        bannerView.delegate = self;
        bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        bannerView;
    });
    [self.topView addSubview:self.bannerView];
    
    self.scrollImgNumLabel = [UILabel GetLabWithFont:kFont(12) andTitleColor:[UIColor whiteColor] andTextAligment:1 andBgColor:CODHexaColor(0x000000, 0.3) andlabTitle:nil];
    [self.scrollImgNumLabel setLayWithCor:9 andLayerWidth:0 andLayerColor:nil];
    [self.topView addSubview:self.scrollImgNumLabel];
    [self.scrollImgNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom).offset(-10);
        make.right.equalTo(self.topView.mas_right).offset(-5);
        make.height.equalTo(@20);
        make.width.equalTo(@35);
    }];
    
    self.tableView.tableHeaderView = self.topView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        wkWebConfig.userContentController = wkUController;
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        // 添加js调用
        [wkUController addUserScript:wkUserScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) configuration:wkWebConfig];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.userInteractionEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
        [_webView sizeToFit];
        // 添加kvo监听网页内容高度
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }return _webView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        [self.scrollView addSubview:self.webView];
    } return _scrollView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * kCompanyCellID = @"companyCellID";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCompanyCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            UILabel *titleLabe = [[UILabel alloc] init];
            titleLabe.textColor = CODColor333333;
            titleLabe.font = kFont(15);
            titleLabe.tag = 1;
            titleLabe.numberOfLines = 2;
            [cell.contentView addSubview:titleLabe];
            
            UILabel *currentPriceLabel = [[UILabel alloc] init];
            currentPriceLabel.textColor = CODHexColor(0xFB5B1C);
            currentPriceLabel.font = kFont(16);
            currentPriceLabel.tag = 2;
            [cell.contentView addSubview:currentPriceLabel];
        
            UILabel *originalPriceLabel = [[UILabel alloc] init];
            originalPriceLabel.textColor = CODColor999999;
            originalPriceLabel.font = kFont(12);
            originalPriceLabel.tag = 3;
            [cell.contentView addSubview:originalPriceLabel];
            
            [titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(20);
                make.left.offset(10);
                make.right.offset(-10);
            }];
            [currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
                make.left.equalTo(cell.contentView.mas_left).offset(10);
            }];
            [originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@15);
                make.bottom.equalTo(currentPriceLabel.mas_bottom);
                make.left.equalTo(currentPriceLabel.mas_right).offset(15);
            }];
        }
        UILabel *titleLabe = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *currentPriceLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *originalPriceLabel = (UILabel *)[cell.contentView viewWithTag:3];
        titleLabe.text = @"布艺 沙发现代简约经济型沙发客厅整装小户型免洗布沙发组合家具";
        NSString *price = @"￥888.00";
        if ([price containsString:@"."]) {
            NSRange range = [price rangeOfString:@"."];
            NSString *floStr = [price substringFromIndex:range.location];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:price];
            [attrString setFont:kFont(13) range:[price rangeOfString:floStr]];
            currentPriceLabel.attributedText = attrString;
        } else {
            currentPriceLabel.text = price;
        }
        
        [originalPriceLabel setLabelMiddleLineWithLab:@"￥8888.00" andMiddleLineColor:CODColor999999];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString * kAdressCellID = @"adresxxsCellID";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdressCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAdressCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            iconImageView.layer.cornerRadius = 20;
            iconImageView.layer.masksToBounds = YES;
            iconImageView.tag = 1;
            [cell.contentView addSubview:iconImageView];
            
            UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREENWIDTH-80, 20)];
            shopNameLabel.textColor = CODColor333333;
            shopNameLabel.tag = 2;
            shopNameLabel.font = kFont(15);
            [cell.contentView addSubview:shopNameLabel];
            
            UIImageView *addreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60, 35, 10, 12)];
            addreIcon.image = kGetImage(@"amount_location");
            [cell.contentView addSubview:addreIcon];
            
            UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(75 , 35, SCREENWIDTH-105, 12)];
            addressLab.textColor = CODColor666666;
            addressLab.tag = 3;
            addressLab.font = kFont(11);
            [cell.contentView addSubview:addressLab];
            
            UIButton *clickshopBtn = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:kFont(11) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(gotoShop) andAddVC:self andTitle:@"进入店铺"];
            clickshopBtn.frame = CGRectMake(SCREENWIDTH-75, 19, 60, 22);
            [cell.contentView addSubview:clickshopBtn];
            [clickshopBtn SetLayWithCor:10 andLayerWidth:0 andLayerColor:nil];
            
        }
        UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *shopNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *addressLab = (UILabel *)[cell.contentView viewWithTag:3];

        [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.MModel.logo] placeholderImage:kGetImage(@"place_default_avatar")];
        shopNameLabel.text = @"日记家具";
        addressLab.text = @"南昌市西湖区子安路银田大厦1楼";

        return cell;
    }
    else {
        if (indexPath.row == 0) {
            static NSString * kOneLabelID = @"oneLabelID";
            CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOneLabelID];
            if (!cell) {
                cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOneLabelID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView *jianjuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
                jianjuView.backgroundColor = CODColorBackground;
                [cell.contentView addSubview:jianjuView];
                
                UILabel *largeTitleLable = [UILabel GetLabWithFont:[UIFont fontWithName:@"Helvetica-Bold"size:18] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"装修效果图"];
                largeTitleLable.text = @"商品详情";
                [cell.contentView addSubview:largeTitleLable];
                
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = CODColorButtonHighlighted;
                lineView.layer.cornerRadius = 3;
                lineView.layer.masksToBounds = YES;
                [largeTitleLable addSubview:lineView];
                
                [largeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView.mas_top).offset(30);
                    make.centerX.equalTo(cell.contentView);
                    make.height.equalTo(@20);
                }];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@90);
                    make.centerX.equalTo(cell.contentView);
                    make.height.equalTo(@5);
                    make.top.equalTo(largeTitleLable.mas_bottom).offset(-5);
                }];
            }
            return cell;
        }
        else {
            static NSString * kWebCellId = @"zhuangxiuxiaoguotu";
            CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWebCellId];
            if (!cell) {
                cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWebCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];

                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://yjw.0791jr.com/app.php?m=App&c=Articlew&a=good_info&id=5" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
                [cell addSubview:self.scrollView];
            }
            
            return cell;
        }
       
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 60;
    } else {
        
        return indexPath.row == 0 ? 60 : self.webViewHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (void)gotoShop {
    CODDIYDetailViewController *compVC = [[CODDIYDetailViewController alloc] init];
    compVC.companyId = @"97";
    [self.navigationController pushViewController:compVC animated:YES];
}
- (void)gotoHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 轮播图的代理实现
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(index+1), @(self.MModel.images.count))];
    CGFloat width = kGetTextSize(self.scrollImgNumLabel.text, 200, 20, 12).width;
    if (width>35) {
        [self.scrollImgNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width+20));
        }];
    }
}
// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([UIViewController getCurrentVC]) {
        //        [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
        //            return self.MModel.images;
        //        }];
    }
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 拦截可恶的广告  域名51zhanzhuang.cn ！！！
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"51zhanzhuang"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
// 监听webView高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat height = [result doubleValue] + 20;
            self.webViewHeight = height;
            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
            self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
            self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
            //         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - 导航栏设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= kOffsety) {
        _alphaMemory = offsetY/kOffsety >= 1 ? 1 : offsetY/kOffsety;
        [self wr_setNavBarBackgroundAlpha:_alphaMemory];
        self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:_alphaMemory];
    }else if (offsetY>kOffsety){
        _alphaMemory = 1;
        [self wr_setNavBarBackgroundAlpha:_alphaMemory];
        self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:_alphaMemory];
    }
    if (_alphaMemory < .8) {
        [self.returnBtn setImage:kGetImage(@"decorate_incon_return") forState:0];
        [self.homeBtn setImage:kGetImage(@"mall_details_home") forState:0];

    } else {
        [self.returnBtn setImage:kGetImage(@"nav_app_return") forState:0];
        [self.homeBtn setImage:kGetImage(@"mall_details_home_sliding") forState:0];
    }
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    } return _navTitleLabel;
}

- (void)SetNav {
    // 一行代码搞定导航栏底部分割线是否隐藏
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:0.0];
    
    self.navigationItem.titleView = self.navTitleLabel;
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:kGetImage(@"decorate_incon_return") forState:0];
    self.returnBtn.size = self.returnBtn.currentImage.size;
    [self.returnBtn addTarget:self action:@selector(cod_returnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:self.returnBtn];
    self.navigationItem.leftBarButtonItems = @[returnBtnItem];
    
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.homeBtn setImage:kGetImage(@"mall_details_home") forState:0];
    self.homeBtn.size = self.homeBtn.currentImage.size;
    [self.homeBtn addTarget:self action:@selector(gotoHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:self.homeBtn];
    self.navigationItem.rightBarButtonItem = homeBtnItem;
}

@end
