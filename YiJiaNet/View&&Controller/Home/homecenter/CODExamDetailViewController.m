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
static CGFloat const kTopViewHeight = 188;// 顶部图高度
#define kOffsety 200.f  // 导航栏渐变的判定值

@interface CODExamDetailViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>
/** 导航栏 */
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic,strong) UIButton *returnBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *scrollImgNumLabel;


@property (nonatomic, strong) UIView *bottomView;


@end

@implementation CODExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"装修案例详情";
    [self SetNav];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"decorate_incon_return"] style:UIBarButtonItemStyleDone target:self action:@selector(cod_returnAction)];

    [self configureView];
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
//        [tableView registerClass:[CODHotTableViewCell class] forCellReuseIdentifier:kCell];
        tableView.tableHeaderView = self.topView;

        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight)];

    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
        bannerView.delegate = self;
        bannerView.showPageControl = NO;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView.currentPageDotColor = CODColorTheme;
        bannerView.localizationImageNamesGroup = @[@"icon_banner", @"icon_banner1", @"icon_banner2"];
        bannerView;
    });
    [self.topView addSubview:self.bannerView];
    
//    self.scrollImgNumLabel = [UILabel GetLabWithFont:kFont(16) andTitleColor:[UIColor whiteColor] andTextAligment:1 andBgColor:[UIColor darkGrayColor] andlabTitle:@"1/3"];
//    [self.scrollImgNumLabel setLayWithCor:3.0 andLayerWidth:0 andLayerColor:nil];
//    [self.topView addSubview:self.scrollImgNumLabel];
//    [self.scrollImgNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.topView.mas_bottom).offset(-10);
//        make.right.equalTo(self.topView.mas_right).offset(-5);
//        make.size.mas_equalTo(CGSizeMake(50, 20));
//    }];
    
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
        [callBtn SetBtnTitle:@"电话" andTitleColor:CODColor666666 andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(callAction) andAddVC:self];
        [callBtn cod_alignImageUpAndTitleDown];
        [view addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.offset(10);
            make.top.offset(0);
            make.width.equalTo(@70);
        }];
        
        UIButton *orderBtn = [[UIButton alloc] init];
        [orderBtn SetBtnTitle:@"免费预约" andTitleColor:[UIColor whiteColor] andFont:kFont(12) andBgColor:CODColorTheme andBgImg:nil andImg:nil andClickEvent:@selector(callAction) andAddVC:self];
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

- (void)callAction {
    [self alertVcTitle:nil message:@"是否拨打10086" leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
    } rightTitle:@"拨打" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
        dispatch_async(dispatch_get_main_queue(), ^{;
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",@"10086"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        });
    }];
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
        iconImageView.image = kGetImage(@"place_default_avatar");
        compNameLabel.text = @"牧野装饰";
        subTitleLabel.text = @"案例：452 好评度：99%";
        
        return cell;
        
    }
    
    else if (indexPath.section == 1) {
        static NSString * kHourseCellID = @"hourseCellID";
        
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHourseCellID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHourseCellID];
            cell.backgroundColor = [UIColor whiteColor];
            
            UILabel *horseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREENWIDTH-20, 20)];
            horseNameLabel.textColor = CODColor333333;
            horseNameLabel.tag = 1;
            horseNameLabel.font = kFont(17);
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
        UILabel *fangshiLab = (UILabel *)[cell.contentView viewWithTag:6];
        
        horseNameLabel.text = @"龙斗壹号周先生雅居";
        xiaoquLab.text = @"所在小区：新力银龙湾";
        feiyonLab.text = @"装修费用：15.5万";
        sizeLab.text = @"使用面积：130m";
        fengeLab.text = @"风格：简约";
        huxinLab.text = @"户型：三居";
        fangshiLab.text = @"装修方式：全包";
        
        return cell;
        
    }
    else if (indexPath.section == 2) {
        static NSString * kOneLabelID = @"oneLabelID";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOneLabelID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOneLabelID];
            cell.backgroundColor = [UIColor whiteColor];
            
            UIView *jianjuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
            jianjuView.backgroundColor = CODColorBackground;
            [cell.contentView addSubview:jianjuView];
            
            UILabel *largeTitleLable = [UILabel GetLabWithFont:[UIFont fontWithName:@"Helvetica-Bold"size:18] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"装修效果图"];
            //                largeTitleLable.frame = CGRectMake(10, 10, SCREENWIDTH-20, 20);
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
        // 效果图cell 图文详情 html
        static NSString * zhuangxiuxiaoguotuCELLID = @"zhuangxiuxiaoguotu";
        CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zhuangxiuxiaoguotuCELLID];
        if (!cell) {
            cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhuangxiuxiaoguotuCELLID];
            
            UIImageView *corverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 200)];
            corverImageView.tag = 1;
            [corverImageView setLayWithCor:5 andLayerWidth:0 andLayerColor:0];
            [cell.contentView addSubview:corverImageView];
            
            UILabel *showLable = [[UILabel alloc] init];
            showLable.textColor = CODColor333333;
            showLable.tag = 2;
            showLable.font = kFont(15);
            showLable.numberOfLines = 2;
            [cell.contentView addSubview:showLable];
            [showLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(corverImageView.mas_bottom).offset(10);
                make.left.equalTo(cell.contentView.mas_left).offset(10);
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
            }];
        }
        
        UIImageView *corverImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *showLable = (UILabel *)[cell.contentView viewWithTag:2];

        [corverImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.nczyzs.com/images/kt_699.jpg"] placeholderImage:kGetImage(@"place_zxal")];
        showLable.text = @"设计师恒久的，在经过很长一段岁月后仍然具有耐看的质感";

        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return 70;
//        } else {
//            return 140;
//        }
//    } else {
//        if (indexPath.row == 0) {
//            return 60;
//        } else {
//            return 140;
//        }
//    }
//
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 140;
    } else if (indexPath.section == 2) {
        return 60;
    } else {
        return 270;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CODBaseWebViewController *webView = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
        webView.webTitleString = @"商家信息";
        [self.navigationController pushViewController:webView animated:YES];
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

#pragma mark - 轮播图的代理实现
// 图片滚动回调实现
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    [self.scrollImgNumLabel setText:kFORMAT(@"%ld/3",index+1)];
}
// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}
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
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.text = @"商品详情";
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
