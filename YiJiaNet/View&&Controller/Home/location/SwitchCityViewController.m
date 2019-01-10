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
#import <MapKit/MapKit.h>

#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.
static NSString * const kSectionTwoCell = @"SwitchCityCollectionViewCell";
static NSString * const kSectionOneCell = @"LocationCityCollectionViewCell";

@interface SwitchCityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate>

@property(nonatomic,strong) UICollectionView *itemCollectionView;
@property(nonatomic,strong) NSMutableArray* titleHeadArr;
@property(nonatomic,strong) NSMutableArray* titleArr;
@property(nonatomic,strong) NSMutableArray* allMessageArr;


@property(nonatomic,strong) NSString *currentSelectCity;

@property (nonatomic, copy) NSDictionary *imfoDic;


@property(nonatomic,strong)CLLocationManager *locationManager;
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
    
    // 开启定位
    [self locationStart];
    
//    self.titleHeadArr = @[@"当前定位城市",@"开通城市"].mutableCopy;
//    NSMutableArray *arrTwo = [NSMutableArray arrayWithObjects:@"定位中", nil];
//    NSMutableArray *arrThree = [NSMutableArray arrayWithObjects:@"北京",@"高安",@"上饶",@"景德镇",@"宜春", nil];
//    self.titleArr = [[NSMutableArray alloc]initWithObjects:arrTwo,arrThree, nil];
    
    self.titleHeadArr = @[@"当前定位城市",@"开通城市"].mutableCopy;
    self.titleArr = @[@[@"定位中"],@[]].mutableCopy;
    
    [self.view addSubview:self.itemCollectionView];
    [self.itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
    
    // rac
//    @weakify(self);
//    [[RACObserve(self, locationCity) distinctUntilChanged] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.itemCollectionView reloadData];
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//设置CollectionView头部视图的高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREENWIDTH, 50*proportionH);
}
//// 创建头视图
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
        [kUserCenter setObject:kFORMAT(@"%@",self.allMessageArr[indexPath.row][@"latitude"]) forKey:CODCityDefaultLatitudeKey];
        [kUserCenter setObject:kFORMAT(@"%@",self.allMessageArr[indexPath.row][@"longitude"]) forKey:CODCityDefaultLongitudeKey];
    }
    
//    if (self.SelectCity) {
//
//        self.SelectCity(self.currentSelectCity);
//    }
    
    [kUserCenter setObject:self.currentSelectCity forKey:CODCityDefaultNameKey];
    [kUserCenter synchronize];
    
    [kNotiCenter postNotificationName:CODSwitchCityNotificationName object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 定位相关
//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        [SVProgressHUD cod_showWithErrorInfo:@"定位服务未开启，请检查手机设置"];
    }
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.horizontalAccuracy);
    [kUserCenter setObject:kFORMAT(@"%f",currentLocation.coordinate.latitude) forKey:CODCityDefaultLatitudeKey];
    [kUserCenter setObject:kFORMAT(@"%f",currentLocation.coordinate.longitude) forKey:CODCityDefaultLongitudeKey];

    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             
             self.locationCity = currCity;
             [self.itemCollectionView reloadData];
//             if (self.localCityData.count <= 0) {
//                 GYZCity *city = [[GYZCity alloc] init];
//                 city.cityName = currCity;
//                 city.shortName = currCity;
//                 [self.localCityData addObject:city];
//
//                 [self.tableView reloadData];
//             }
             
         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}
@end
