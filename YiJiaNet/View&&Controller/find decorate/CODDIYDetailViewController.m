//
//  CODDIYDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYDetailViewController.h"
#import "UIButton+COD.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CODCompanyDetailModel.h"
#import "JXMapNavigationView.h"
#import "CODShopInfoViewController.h"
#import "CODDIYGridTableViewCell.h"
#import "CODGoodsDetailViewController.h"

static NSString * const kCODDIYGridTableViewCell = @"CODDIYGridTableViewCell";

static CGFloat const kTopViewHeight = 188;// 顶部图高度
#define kOffsety 200.f  // 导航栏渐变的判定值

@interface CODDIYDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, CustomCollectionDelegate>
/** 导航栏 */
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic,strong) UIButton *returnBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *scrollImgNumLabel;

@property (nonatomic, strong) JXMapNavigationView *mapNavigationView;
@property (nonatomic,strong) CODCompanyDetailModel *MModel;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CODDIYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self SetNav];
    // view
    [self configureView];
    // data
    [self loadMerchantData];
    
    [self loadTODO];
    
    @weakify(self);
    [[RACObserve(self, MModel) distinctUntilChanged] subscribeNext:^(CODCompanyDetailModel *mod) {
        @strongify(self);
        self.navTitleLabel.text = mod.name;
        self.bannerView.imageURLStringsGroup = mod.images;  
        self.scrollImgNumLabel.hidden = (mod.images.count == 0);
        [self.scrollImgNumLabel setText:kFORMAT(@"%@/%@",@(1), @(self.MModel.images.count))];
    }];
    //    [[RACObserve(self, exampleArray) distinctUntilChanged] subscribeNext:^(NSArray *arr) {
    //        @strongify(self);
    //        self.examCollectionView.dataArray = arr;
    //        [self.tableView reloadData];
    //    }];
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
    params[@"id"] = self.companyId;
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
    
    
    // TODO
    
}

- (void)loadTODO {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"cate_id"] = @(0);//装修类型：0/不传=全部；1=精装修；2=半包施工；3=自装采购；4=软装设计
    params[@"latitude"] = [CODGlobal sharedGlobal].latitude;
    params[@"longitude"] = [CODGlobal sharedGlobal].longitude;
    //    params[@"order_type"] = @(self.orderType);// 排序类型
    params[@"page"] = @(1);
    params[@"pagesize"] = @(CODRequstPageSize);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            NSArray *models = [NSArray modelArrayWithClass:[CODDIYModel class] json:object[@"data"][@"list"]];
            self.dataArray = models;
            
            if (self.dataArray.count == [object[@"data"][@"pageCount"] integerValue]) {
                [self.tableView noMoreData];
            }
            [self.tableView reloadData];
        }
        else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];

        }
    } failed:^(NSError *error) {
        
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
        [tableView registerClass:[CODDIYGridTableViewCell class] forCellReuseIdentifier:kCODDIYGridTableViewCell];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMerchantData)];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight)];
    
    self.bannerView = ({
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTopViewHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
        bannerView.delegate = self;
        bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
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
  
}

- (JXMapNavigationView *)mapNavigationView{
    if (_mapNavigationView == nil) {
        _mapNavigationView = [[JXMapNavigationView alloc]init];
        _mapNavigationView.selfClass = self;
    }
    return _mapNavigationView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * kCompanyCellID = @"companyCellID";
            CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyCellID];
            if (!cell) {
                cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCompanyCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
                iconImageView.layer.cornerRadius = 20;
                iconImageView.layer.masksToBounds = YES;
                iconImageView.tag = 1;
                [cell.contentView addSubview:iconImageView];
                
                UILabel *compNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, SCREENWIDTH-80, 20)];
                compNameLabel.textColor = CODColor333333;
                compNameLabel.tag = 2;
                compNameLabel.font = kFont(16);
                [cell.contentView addSubview:compNameLabel];
                
                UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREENWIDTH, 1)];
                linView.backgroundColor = CODColorBackground;
                [cell.contentView addSubview:linView];
            }
            UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:1];
            UILabel *compNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.MModel.logo] placeholderImage:kGetImage(@"place_default_avatar")];
            compNameLabel.text = self.MModel.name;
            
            return cell;
        }
        
        else if (indexPath.row == 1) {
            static NSString * kAdressCellID = @"adressCellID";
            CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdressCellID];
            if (!cell) {
                cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAdressCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 24, 10, 12)];
                iconImageView.image = kGetImage(@"amount_location");
                [cell.contentView addSubview:iconImageView];
                
                UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, SCREENWIDTH-105, 20)];
                addressLab.textColor = CODColor333333;
                addressLab.tag = 1;
                addressLab.font = kFont(14);
                [cell.contentView addSubview:addressLab];
                
                UIButton *adreBtn = [[UIButton alloc] init];
                [adreBtn SetBtnTitle:@"查看路线" andTitleColor:CODHexColor(0x7496DF) andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:kGetImage(@"commodity_navigation_location") andClickEvent:nil andAddVC:self];
                [adreBtn cod_alignImageUpAndTitleDown];
                adreBtn.frame = CGRectMake(CGRectGetMaxX(addressLab.frame)+10, 0, 50, 60);
                adreBtn.userInteractionEnabled = NO;
                [cell.contentView addSubview:adreBtn];
                
                UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREENWIDTH, 1)];
                linView.backgroundColor = CODColorBackground;
                [cell.contentView addSubview:linView];
            }
            UILabel *addreLab = (UILabel *)[cell.contentView viewWithTag:1];
            addreLab.text = self.MModel.address;
            
            return cell;
        }
        
        else  {
            static NSString * kAdressCellID = @"adresxxsCellID";
            CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdressCellID];
            if (!cell) {
                cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAdressCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 50, 20)];
                timeLab.textColor = CODColor999999;
                timeLab.font = kFont(12);
                timeLab.text = @"营业时间";
                [cell.contentView addSubview:timeLab];
                
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, SCREENWIDTH-90, 20)];
                timeLabel.textColor = CODColor333333;
                timeLabel.tag = 1;
                timeLabel.font = kFont(12);
                [cell.contentView addSubview:timeLabel];
            }
            
            UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:1];
            timeLabel.text = @"周一至周六 每天09:00-18:00";

            return cell;
        }
        
    }
    
    else {
        
        CODDIYGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCODDIYGridTableViewCell forIndexPath:indexPath];
        cell.delegate = self;
        cell.dataArray = self.dataArray;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        return 60;
    } else {
        
        return  [self collectionViewCount:self.dataArray.count];
//        return SCREENWIDTH - 60;
    }
}

- (CGFloat)collectionViewCount:(NSInteger)collectionViewCount{
    if (collectionViewCount == 0) {
        return 0;
    } else {
        return ((SCREENWIDTH-30)/2+80) * ((collectionViewCount%2)+1) + 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row ==1) {
            [self.mapNavigationView showMapNavigationViewWithtargetLatitude:[self.MModel.latitude doubleValue] targetLongitute:[self.MModel.longitude doubleValue] toName:self.MModel.address];
        } else {
            CODShopInfoViewController *shopInfoVC = [[CODShopInfoViewController alloc] init];
            shopInfoVC.companyId = self.companyId;
            [self.navigationController pushViewController:shopInfoVC animated:YES];
        }
    } else {
        
    }
}
#pragma mark - Collection Deletate
- (void)CustomCollection:(UICollectionView *)collectionView didSelectCollectionItem:(NSInteger)itme {
    CODGoodsDetailViewController *diyDetailVC = [[CODGoodsDetailViewController alloc] init];
    diyDetailVC.goodsId = @"97";
    [self.navigationController pushViewController:diyDetailVC animated:YES];
}

#pragma mark - Action

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
#pragma mark - 导航栏设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= kOffsety) {
        _alphaMemory = offsetY/kOffsety >= 1 ? 1 : offsetY/kOffsety;
        [self wr_setNavBarBackgroundAlpha:_alphaMemory];
        self.navTitleLabel.textColor = [UIColor colorWithWhite:0.0 alpha:_alphaMemory];
    } else if (offsetY>kOffsety){
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
    UIBarButtonItem *faqBtnItem =  [[UIBarButtonItem alloc]initWithCustomView:self.returnBtn];
    self.navigationItem.leftBarButtonItems = @[faqBtnItem];
}

@end
