//
//  SwitchCityViewController.m
//  JinFengGou
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SwitchCityViewController.h"
#import "SwitchCityCollectionViewCell.h"
#import "LocationCityCollectionViewCell.h"
#import "SwitchCityCollecHeadView.h"
#import "StoreSearchCollectLayout.h"
#import "CODLayoutButton.h"
#import <CoreLocation/CoreLocation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UIViewController+COD.h"

#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.
static NSString * const kSectionTwoCell = @"SwitchCityCollectionViewCell";
static NSString * const kSectionOneCell = @"LocationCityCollectionViewCell";

@interface SwitchCityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AMapLocationManagerDelegate>

@property(nonatomic,strong) UICollectionView *itemCollectionView;
@property(nonatomic,strong) NSMutableArray* titleHeadArr;
@property(nonatomic,strong) NSMutableArray* titleArr;
@property(nonatomic,strong) NSMutableArray* allMessageArr;

@property(nonatomic,strong) NSString *currentSelectCity;

@property (nonatomic, copy) NSDictionary *imfoDic;

@property(nonatomic,strong) AMapLocationManager* locationManager;// 定位

@property(nonatomic,strong) NSString *locationCity;

@end

@implementation SwitchCityViewController

static NSString *const MyWalletHeadVwID = @"MyWalletHeadVwIdentifier";

-(NSMutableArray *)allMessageArr {
    if (!_allMessageArr) {
        _allMessageArr = [[NSMutableArray alloc] init];
    }return _allMessageArr;
}

-(UICollectionView *)itemCollectionView {
    if (!_itemCollectionView) {
        StoreSearchCollectLayout *flowLayout = [[StoreSearchCollectLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _itemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
        _itemCollectionView.bounces = NO;
        _itemCollectionView.showsVerticalScrollIndicator = NO;
        _itemCollectionView.backgroundColor = [UIColor whiteColor];
        [_itemCollectionView registerClass:[LocationCityCollectionViewCell class] forCellWithReuseIdentifier:kSectionOneCell];
        [_itemCollectionView registerClass:[SwitchCityCollectionViewCell class] forCellWithReuseIdentifier:kSectionTwoCell];
        // 注册头视图
        [_itemCollectionView registerClass:[SwitchCityCollecHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyWalletHeadVwID];
    }return _itemCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"选择城市";
    
    // 检测定位权限
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        // 开启定位
        [self.locationManager startUpdatingLocation];
    } else {
        [self alertVcTitle:@"定位服务未开启" message:@"请到设置->隐私->定位服务中开启定位服务，益家网需要知道您的位置才能提供更好的服务~" leftTitle:@"取消" leftTitleColor:CODColor666666 leftClick:^(id leftClick) {
        } rightTitle:@"去开启" righttextColor:CODColorTheme andRightClick:^(id rightClick) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingsURL])
            {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
    }
    
    self.titleHeadArr = @[@"当前定位城市",@"开通城市"].mutableCopy;
    self.titleArr = @[@[@"定位中"],@[]].mutableCopy;
    
    [self.view addSubview:self.itemCollectionView];
    [self.itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        [AMapServices sharedServices].apiKey = AMapApiKey;
        _locationManager = [[AMapLocationManager alloc] init];
        //高德地图注册
        _locationManager.delegate = self;
        //设置定位最小更新距离方法如下，单位米
//        _locationManager.distanceFilter ＝ 200;
        [_locationManager setLocatingWithReGeocode:YES];
    }return _locationManager;
}


#pragma mark - CLLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location error = %@", error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"高德定位location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode) {
        [kUserCenter setObject:kFORMAT(@"%f",location.coordinate.latitude)  forKey:CODLatitudeKey];
        [kUserCenter setObject:kFORMAT(@"%f",location.coordinate.longitude) forKey:CODLongitudeKey];
        if ([kUserCenter objectForKey:CODCityNameKey] == nil) {
            [kUserCenter setObject:kFORMAT(@"%@",reGeocode.city) forKey:CODCityNameKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"location address:%@", reGeocode.formattedAddress);
        
        self.locationCity = reGeocode.city;
        [self.itemCollectionView reloadData];
        
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - 加载数据
- (void)loadData
{
    [SVProgressHUD cod_showStatu];
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=open_citys" andParameters:nil Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_dismis];
            [self.allMessageArr removeAllObjects];
            
            if (![object[@"data"][@"list"] isKindOfClass:[NSNull class]]) {
                [self.allMessageArr addObjectsFromArray:object[@"data"][@"list"]];
            }
            
            NSMutableArray* arr = [NSMutableArray new];
            [self.allMessageArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:obj[@"area_name"]];
            }];
            
            [self.titleArr removeObjectAtIndex:1];
            [self.titleArr addObject:arr];
            
            [self.itemCollectionView reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15*proportionH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section; {
    
    return 10*proportionW;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 13*proportionW, 0, 13*proportionH);//分别为上、左、下、右
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* itemsTitle = self.titleArr[indexPath.section][indexPath.item];
    
    CGSize textSize = kGetTextSize(itemsTitle,MAXFLOAT,30*proportionH,IS_IPHONE_5?13:15);
    CGFloat itemWidth = textSize.width + 30*proportionW;

    return CGSizeMake(itemWidth, 30*proportionH);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.titleArr.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.titleArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cityName = self.titleArr[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        LocationCityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSectionOneCell forIndexPath:indexPath];
        NSString *loactionString;
        if (kStringIsEmpty(self.locationCity)) {
            loactionString = @"定位中";
        } else {
            loactionString = self.locationCity;
        }
        [cell.loacBtn setTitle:loactionString forState:UIControlStateNormal];
        return cell;
    } else {
        SwitchCityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSectionTwoCell forIndexPath:indexPath];
        if ([[CODGlobal sharedGlobal].currentCityName isEqualToString:cityName]) {
            cell.nameLabel.textColor = CODColorTheme;
            [cell.nameLabel setBackgroundColor:CODHexColor(0xE5F5FD)];
            [cell.nameLabel SetLabLayWithCor:5 andLayerWidth:0.5 andLayerColor:CODColorTheme];
        } else {
            cell.nameLabel.textColor = [UIColor darkGrayColor];
            [cell.nameLabel setBackgroundColor:[UIColor clearColor]];
            [cell.nameLabel SetLabLayWithCor:5 andLayerWidth:0.5 andLayerColor:CODColorLine];
        }
        cell.nameLabel.text = cityName;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREENWIDTH, 50*proportionH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        SwitchCityCollecHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyWalletHeadVwID forIndexPath:indexPath];
        headerView.titleLab.text = self.titleHeadArr[indexPath.section];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        self.currentSelectCity = self.locationCity;
    } else {
        self.currentSelectCity = self.titleArr[indexPath.section][indexPath.row];
    }
    
    [kUserCenter setObject:self.currentSelectCity forKey:CODCityNameKey];
    [kUserCenter synchronize];
    [kNotiCenter postNotificationName:CODSwitchCityNotificationName object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
