//
//  CODExamDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODExamDetailViewController.h"
#import "UINavigationBar+COD.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+COD.h"
#import "UIViewController+COD.h"
#import "CODExampDetailModel.h"
#import "CODMerchantModel.h"
#import "CODOrderPopView.h"
#import "CODShopInfoViewController.h"
#import "MBProgressHUD+COD.h"
#import "CODCompanyDetailViewController.h"
#import "ImageBrowserViewController.h"
#import <WebKit/WebKit.h>

static CGFloat const kTopViewHeight = 188;// 顶部图高度
#define kOffsety 200.f  // 导航栏渐变的判定值

@interface CODExamDetailViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIWebViewDelegate>
/** 导航栏 */
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic,strong) UIButton *returnBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CODExampDetailModel *exampModel;
@property (nonatomic, strong) CODMerchantModel *merchantModel;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *scrollImgNumLabel;

//图文页
//@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CODExamDetailViewController

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetNav];
    [self configureView];
    [self loadExampData];
    @weakify(self);
    [[RACObserve(self, exampModel) distinctUntilChanged] subscribeNext:^(CODExampDetailModel *mod) {
        @strongify(self);
        self.bannerView.imageURLStringsGroup = mod.imgs;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[mod.info_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        // tableView 偏移20/64适配
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
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
- (void)loadExampData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.exampId;
    params[@"user_id"] = COD_USERID;
    [SVProgressHUD cod_showStatu];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=case_detail" andParameters:params Sucess:^(id object) {
        [self.tableView.mj_header endRefreshing];
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            self.exampModel = [CODExampDetailModel modelWithJSON:object[@"data"][@"info"]];
            self.merchantModel = [CODMerchantModel modelWithJSON:object[@"data"][@"merchant"]];
            self.scrollImgNumLabel.hidden = (self.exampModel.imgs.count == 0);
            [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(1), @(self.exampModel.imgs.count))];
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
        //(CGRect){0,- KTabBarNavgationHeight,SCREENWIDTH,SCREENHEIGHT-50}
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadExampData)];
        tableView.tableHeaderView = self.topView;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight)];

    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
        bannerView.delegate = self;
        bannerView.showPageControl = NO;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView.currentPageDotImage = [UIImage cod_imageWithColor:[UIColor whiteColor] size:CGSizeMake(25, 3)];
        bannerView.pageDotImage = [UIImage cod_imageWithColor:CODHexaColor(0xffffff, 0.3) size:CGSizeMake(25, 3)];
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    self.bottomView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-50);
            make.left.right.offset(0);
            make.height.equalTo(@50);
        }];
        UIButton *callBtn = [[UIButton alloc] init];
        [callBtn SetBtnTitle:@"电话" andTitleColor:CODColor666666 andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:kGetImage(@"decorate_call") andClickEvent:@selector(callAction) andAddVC:self];
        [callBtn cod_alignImageUpAndTitleDown];
        [view addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.offset(10);
            make.top.offset(0);
            make.width.equalTo(@70);
        }];
        
        UIButton *orderBtn = [[UIButton alloc] init];
        [orderBtn SetBtnTitle:@"免费预约" andTitleColor:[UIColor whiteColor] andFont:kFont(12) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(orderAction) andAddVC:self];
        [orderBtn SetLayWithCor:18 andLayerWidth:0 andLayerColor:0];
        [view addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.offset(100);
            make.right.offset(-10);
            make.height.equalTo(@40);
        }];
        
        view;
    });
}

-(WKWebView *)webView{
    if (!_webView) {
//        _webView = [[UIWebView alloc]init];
//        _webView.delegate = self;
//        _webView.scalesPageToFit = YES;
//        _webView.backgroundColor = [UIColor clearColor];
//        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
//        _webView.scrollView.scrollEnabled = NO;
//        _webView.opaque = NO;
        
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
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView sizeToFit];
        // http://yjw.0791jr.com/app.php?m=App&c=Articlew&a=good_info&id=3
        // https://www.baidu.com
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//        NSURL *url = [NSURL URLWithString:@"http://yjw.0791jr.com/app.php?m=App&c=Articlew&a=good_info&id=3"];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        [self.webView loadRequest:urlRequest];
        
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
    return 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * kCompanyCellID = @"companyCellID";
        
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCompanyCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            iconImageView.tag = 1;
            [cell.contentView addSubview:iconImageView];
            
            UILabel *compNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, SCREENWIDTH-80, 20)];
            compNameLabel.textColor = CODColor333333;
            compNameLabel.tag = 2;
            compNameLabel.font = kFont(16);
            [cell.contentView addSubview:compNameLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, SCREENWIDTH-80, 20)];
            subTitleLabel.textColor = CODHexColor(0x666666);
            subTitleLabel.tag = 3;
            subTitleLabel.font = kFont(12);
            [cell.contentView addSubview:subTitleLabel];
            
            UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREENWIDTH, 1)];
            linView.backgroundColor = CODColorBackground;
            [cell.contentView addSubview:linView];
        }
        UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *compNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *subTitleLabel = (UILabel *)[cell.contentView viewWithTag:3];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.merchantModel.logo] placeholderImage:kGetImage(@"place_default_avatar")];
        compNameLabel.text = self.merchantModel.name;
        subTitleLabel.text = [NSString stringWithFormat:@"案例：%@  |  好评度：%@", self.merchantModel.cases_number, self.merchantModel.score];
        
        return cell;
        
    }
    
    else if (indexPath.section == 1) {
        static NSString * kHourseCellID = @"hourseCellID";
        
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHourseCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHourseCellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *horseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREENWIDTH-20, 20)];
            horseNameLabel.textColor = CODColor333333;
            horseNameLabel.tag = 1;
            horseNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
            [cell.contentView addSubview:horseNameLabel];
            
            UILabel *xiaoquLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, (SCREENWIDTH-30)/2, 20)];
            xiaoquLab.textColor = CODColor333333;
            xiaoquLab.tag = 2;
            xiaoquLab.font = kFont(14);
            [cell.contentView addSubview:xiaoquLab];
            
            UILabel *feiyonLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, (SCREENWIDTH-30)/2, 20)];
            feiyonLab.textColor = CODColor333333;
            feiyonLab.tag = 3;
            feiyonLab.font = kFont(14);
            [cell.contentView addSubview:feiyonLab];
            
            UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, (SCREENWIDTH-30)/2, 20)];
            sizeLab.textColor = CODColor333333;
            sizeLab.tag = 4;
            sizeLab.font = kFont(14);
            [cell.contentView addSubview:sizeLab];
            
            UILabel *fengeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xiaoquLab.frame)+10, 50, (SCREENWIDTH-30)/2, 20)];
            fengeLab.textColor = CODColor333333;
            fengeLab.tag = 5;
            fengeLab.font = kFont(14);
            [cell.contentView addSubview:fengeLab];
            
            UILabel *huxinLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xiaoquLab.frame)+10, 80, (SCREENWIDTH-30)/2, 20)];
            huxinLab.textColor = CODColor333333;
            huxinLab.tag = 6;
            huxinLab.font = kFont(14);
            [cell.contentView addSubview:huxinLab];
            
            UILabel *fangshiLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xiaoquLab.frame)+10, 110, (SCREENWIDTH-30)/2, 20)];
            fangshiLab.textColor = CODColor333333;
            fangshiLab.tag = 7;
            fangshiLab.font = kFont(14);
            [cell.contentView addSubview:fangshiLab];
        }
        
        UILabel *horseNameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *xiaoquLab = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *feiyonLab = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *sizeLab = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *fengeLab = (UILabel *)[cell.contentView viewWithTag:5];
        UILabel *huxinLab = (UILabel *)[cell.contentView viewWithTag:6];
        UILabel *fangshiLab = (UILabel *)[cell.contentView viewWithTag:7];
        
        CODExampDetailModel *model = self.exampModel;
        horseNameLabel.text = model.title;
        xiaoquLab.text = kFORMAT(@"所在小区：%@",model.house_areas);
        feiyonLab.text = kFORMAT(@"装修费用：%@",model.decorate_fare);
        sizeLab.text = kFORMAT(@"使用面积：%@",model.acreage);
        fengeLab.text = kFORMAT(@"风格：%@",model.style);
        huxinLab.text = kFORMAT(@"户型：%@",model.house_type);
        fangshiLab.text = kFORMAT(@"装修方式：%@",[model typeName]);
        
        return cell;
        
    }
    else if (indexPath.section == 2) {
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
            largeTitleLable.text = @"装修效果图";
            [cell.contentView addSubview:largeTitleLable];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = CODColorTheme;
            lineView.layer.cornerRadius = 3;
            lineView.layer.masksToBounds = YES;
            [largeTitleLable addSubview:lineView];
            
            [largeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(30);
                make.centerX.equalTo(cell.contentView);
                make.height.equalTo(@20);
            }];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(largeTitleLable);
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
            [cell addSubview:self.scrollView];
//            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.offset(0);
//            }];
        }

        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 140;
    } else if (indexPath.section == 2) {
        return 60;
    } else {
        return self.webViewHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CODCompanyDetailViewController *comDetailVC = [[CODCompanyDetailViewController alloc] init];
        comDetailVC.companyId = self.merchantModel.id;
        [self.navigationController pushViewController:comDetailVC animated:YES];
    } else if (indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        
    } else {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Action
- (void)callAction {
    [self alertVcTitle:nil message:kFORMAT(@"是否拨打%@", self.merchantModel.contact_number) leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                kCall(kFORMAT(@"%@",self.merchantModel.contact_number));
            } else {
                // Fallback on earlier versions
            }
        });
    }];
}

- (void)orderAction {
    CODOrderPopView *popView = [[CODOrderPopView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    popView.commitBlock = ^(NSString *fulladdress, NSString *province, NSString *city, NSString *area, NSString *hourse, NSString *phone) {
        //地理编码
//        static NSString *longitude;
//        static NSString *latitude;
//        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//        [geocoder geocodeAddressString:fulladdress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error!=nil || placemarks.count==0) {
//                CODLogObject(error);
//            }
//            //创建placemark对象
//            CLPlacemark *placemark = [placemarks firstObject];
//            //经度
//            longitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
//            //纬度
//            latitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
//            
//            NSLog(@"经度：%@，纬度：%@",longitude,latitude);
//        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"user_id"] = COD_USERID;
            params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
            params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
            params[@"province"] = province;
            params[@"city"] = city;
            params[@"area"] = area;
            params[@"house_name"] = hourse;
            params[@"mobile"] = phone;
            params[@"house_acreage"] = @"";
            params[@"house_type"] = @"";
            params[@"type"] = @(0);//0或不传 预约, 1报价
            [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=ordered" andParameters:params Sucess:^(id object) {
                if ([object[@"code"] integerValue] == 200) {
                    [MBProgressHUD cod_showSuccessWithTitle:@"提交成功" detail:@"我们将尽快为您回电" toView:self.view];
                } else {
                    [SVProgressHUD cod_showWithInfo:object[@"message"]];
                }
            } failed:^(NSError *error) {
                [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
            }];
        });
    };
    
    [popView show];
}

#pragma mark - 轮播图的代理实现
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(index+1), @(self.exampModel.imgs.count))];
    
//    self.scrollImgNumLabel.size = kGetTextSize(self.scrollImgNumLabel.text, 100, 20, 12);
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([UIViewController getCurrentVC]) {
        [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:index imagesBlock:^NSArray *{
            return self.exampModel.imgs;
        }];
    }
}
#pragma mark - WebView delegate
#pragma mark - KVO 监听webView高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
//        UIScrollView *scrollView = (UIScrollView *)object;
//        CGFloat height = scrollView.contentSize.height;
//        self.webViewHeight = height + 20;;
//        self.webView.frame = CGRectMake(0, 0, SCREENWIDTH, self.webViewHeight);
//
//        [self.tableView reloadData];
//        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
//        self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:3], nil] withRowAnimation:UITableViewRowAnimationNone];
//
        
         // 方法二
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
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
////        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
////        // 高度的缩放
////        CGRect frame = webView.frame;
////        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
////        frame.size = fittingSize;
////        webView.frame = frame;
////        self.webViewHeight = height * ((SCREENWIDTH)/(SCREENHEIGHT)) + 20;
//
////     如果是加载的URL,可以通过WebView的在webViewDidFinishLoad的加载完成的代理方法中,
////     通过stringByEvaluatingJavaScriptFromString方法来动态添加js代码：
////     标签里的scale 值就是页面的初始化页面大小< initial-scale >和可伸缩放大最大< maximum-scale >和最小< minimum-scale >的的倍数。如果还有别的需求可自行设置,如果都为1表示初始化的时候显示为原来大小,可缩放的大小都为原来的大小<即不可缩放>。
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
//
//    CGRect frame = webView.frame;
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    webView.frame = frame;
//
//    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:
//                         @"document.body.offsetHeight"] integerValue];
//    self.webViewHeight = height * ((SCREENWIDTH)/(SCREENHEIGHT))+10;
//
//}
#pragma mark - 导航栏设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {\
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
    } else {
        [self.returnBtn setImage:kGetImage(@"nav_app_return") forState:0];
    }
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.text = @"案例详情";
    } return _navTitleLabel;
}

#pragma mark - 导航栏
- (void)SetNav {
    // 一行代码搞定导航栏底部分割线是否隐藏
    [self wr_setNavBarShadowImageHidden:YES];
    [self wr_setNavBarBackgroundAlpha:0.0];
    
    self.navigationItem.titleView = self.navTitleLabel;
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnBtn setImage:kGetImage(@"decorate_incon_return") forState:0];
    self.returnBtn.size = self.returnBtn.currentImage.size;
    [self.returnBtn addTarget:self action:@selector(cod_returnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *faqBtnItem =  [[UIBarButtonItem alloc]initWithCustomView:self.returnBtn];
    self.navigationItem.leftBarButtonItems = @[faqBtnItem];
}
    
@end
