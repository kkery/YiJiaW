//
//  HPSearchViewController.m
//  JinFengGou
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HPSearchViewController.h"
#import "CODSearchCollectionViewCell.h"
#import "CODSearchCollectionReusableView.h"
#import "StoreSearchCollectLayout.h"
#import "UIViewController+COD.h"
#import "CODSearchModel.h"
#import "CODSearchResultViewController.h"
//#import "HPSearchListViewController.h"

@interface HPSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) UITextField* keyTextField;

@property(nonatomic,strong) UICollectionView *itemCollectionView;
@property(nonatomic,strong) NSMutableArray* titleHeadArr;
@property(nonatomic,strong) NSMutableArray* titleArr;

@property(nonatomic,strong) NSMutableArray* searcheArr;
@property(nonatomic,strong) NSMutableArray* hotSearcheArr;
@property(nonatomic,strong) NSMutableDictionary* dic;
@property(nonatomic,strong) NSString* jiLuString;

@end

@implementation HPSearchViewController

static NSString *const MyWalletHeadVwID = @"MyWalletHeadVwIdentifier";

-(NSMutableDictionary *)dic {
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc] init];
    }return _dic;
}

-(NSMutableArray *)hotSearcheArr {
    if (!_hotSearcheArr) {
        _hotSearcheArr = [[NSMutableArray alloc] init];
        _hotSearcheArr = @[@"热门搜索",@"热门搜索",@"热门搜索",@"热门搜",@"搜索"];
    }return _hotSearcheArr;
}

-(NSMutableArray *)searcheArr {
    if (!_searcheArr) {
        _searcheArr = [[NSMutableArray alloc] init];
    }return _searcheArr;
}

-(UITextField *)keyTextField
{
    if (!_keyTextField) {
        _keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(15*proportionW, 5, 220*proportionW, 20)];
        [_keyTextField SetTfTitle:nil andTitleColor:[UIColor lightGrayColor] andFont:XFONT_SIZE(13) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入关键词搜索"];
        [_keyTextField modifyPlaceholdFont:XFONT_SIZE(13) andColor:nil];
        _keyTextField.tintColor = ThemeColor;
        _keyTextField.clearButtonMode=UITextFieldViewModeAlways;
        _keyTextField.delegate = self;
        _keyTextField.backgroundColor = [UIColor clearColor];
//        [_keyTextField addTarget:self action:@selector(texfChange:) forControlEvents:UIControlEventEditingChanged];
    }return _keyTextField;
}

-(UICollectionView *)itemCollectionView {
    if (!_itemCollectionView) {
        StoreSearchCollectLayout *flowLayout = [[StoreSearchCollectLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _itemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _itemCollectionView.delegate = self;
        _itemCollectionView.dataSource = self;
//        _itemCollectionView.bounces = NO;
        _itemCollectionView.showsVerticalScrollIndicator = NO;
        _itemCollectionView.alwaysBounceVertical = YES;
        _itemCollectionView.backgroundColor = [UIColor whiteColor];
        [_itemCollectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_itemCollectionView registerClass:[CODSearchCollectionViewCell class] forCellWithReuseIdentifier:@"newsThressCollectionCell"];
        // 注册头视图
        [_itemCollectionView registerClass:[CODSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyWalletHeadVwID];
    }return _itemCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self SetNav];
    
    
    [self userCenterArr];
    
    [self.view addSubview:self.itemCollectionView];
    [self.itemCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
    
    @weakify(self);
    [[RACObserve(self, searcheArr) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self.itemCollectionView reloadData];
    }];
    
    
}

-(void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
//    [self showLoading];
//    [[HJNetWorkQuery shareManger] AFrequestData:@"App,Store,keywordlist" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
//        // NSLog(@"----==== %@",result);
//        if ([result[@"code"] integerValue] == 200) {
//            [self dismissLoading];
//
//            self.dic = result[@"data"][@"history"];
//
//            [self.searcheArr removeAllObjects];
//            if (![result[@"data"][@"history"] isKindOfClass:[NSNull class]]) {
//                [result[@"data"][@"history"] enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [self.searcheArr addObject:obj[@"keyword"]];
//                }];
//            }
//
//
//            [self.hotSearcheArr removeAllObjects];
//            [result[@"data"][@"hotsearch"] enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self.hotSearcheArr addObject:obj[@"keyword"] ];
//            }];
//
//
//            [self userCenterArr];
//            [self.itemCollectionView reloadData];
//        } else {
//            [self showErrorText:result[@"message"]];
//        }
//
//    } AndError:^(NSError *error) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
}


//根据数据改变
-(void)userCenterArr {
    self.searcheArr = [CODSearchModel getSearchHistory];
    if (self.searcheArr.count > 0) {
        self.titleHeadArr = @[@"历史记录",@"热门搜索"].mutableCopy;
        self.titleArr = @[self.searcheArr,self.hotSearcheArr].mutableCopy;
    } else {
        self.titleHeadArr = @[@"热门搜索"].mutableCopy;
        self.titleArr = @[self.hotSearcheArr].mutableCopy;
    }
    
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10*proportionH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section; {
    
    return 10*proportionW;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 13*proportionW, 0, 13*proportionW);//分别为上、左、下、右
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
    
    //根据行号获得行对象,没有就创建新的
    CODSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newsThressCollectionCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.titleArr[indexPath.section][indexPath.item];
    
    
    return cell;
    
}

//设置CollectionView头部视图的高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREENWIDTH, 60*proportionH);
}
//// 创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CODSearchCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyWalletHeadVwID forIndexPath:indexPath];
        headerView.titleLab.text = self.titleHeadArr[indexPath.section];
        
        if ([headerView.titleLab.text isEqualToString:@"历史记录"]) {
            [headerView.deleBtn addTarget:self action:@selector(deleteHAction) forControlEvents:UIControlEventTouchUpInside];
            headerView.deleBtn.hidden = NO;
        } else {
            if (indexPath.section == 1) {
                headerView.deleBtn.hidden = YES;
            }
            
        }
        
        
        return headerView;
    }
    return nil;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",indexPath.row);
    
    [self.keyTextField resignFirstResponder];
//    HPSearchListViewController* searchVC = [[HPSearchListViewController alloc] init];
//    searchVC.keyString = self.titleArr[indexPath.section][indexPath.item];
//    self.jiLuString = self.titleArr[indexPath.section][indexPath.item];
//    [self.navigationController pushViewController:searchVC animated:YES];
    NSString *searchKey = self.titleArr[indexPath.section][indexPath.item];
    // 缓存搜索记录
    [CODSearchModel addSearchHistory:searchKey];
    [self userCenterArr];
    CODSearchResultViewController *searchResultVC = [[CODSearchResultViewController alloc] init];
    //        searchVC.keyString = self.keyTextField.text;
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5"];
    searchResultVC.dataArray = (indexPath.section == 0) ? nil : arr;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}


#pragma mark - Action
- (void)SetNav {
    // 导航栏title
//    [self setNavWithBtnTitle:nil andBackAction:@selector(NavAllBackClicked)];
    
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260*proportionW, 30)];
    titleView.backgroundColor = CODColorBackground;
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 14;
    self.navigationItem.titleView = titleView;
    [titleView addSubview:self.keyTextField];
    
    // 导航栏右侧
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itmWithTitle:@"搜索" SelectTitle:@"搜索" Font:XFONT_SIZE(14) textColor:ThemeColor selectedTextColor:ThemeColor target:self action:@selector(rightAction)];
    
}


-(void)rightAction {
    
    if (self.keyTextField.text.length > 0) {
        [self.keyTextField resignFirstResponder];
        // 缓存搜索记录
        [CODSearchModel addSearchHistory:self.keyTextField.text];
        
        [self userCenterArr];
        
//        [self.itemCollectionView reloadData];

        CODSearchResultViewController *searchResultVC = [[CODSearchResultViewController alloc] init];
//        searchVC.keyString = self.keyTextField.text;
        
        [self.navigationController pushViewController:searchResultVC animated:YES];
    } else {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入搜索内容"];
    }
    
    
}

-(void)deleteHAction {
    
    [self showAlertWithTitle:@"确定清除历史记录吗？" andMesage:nil andCancel:^(id cancel) {
        
    } Determine:^(id determine) {
        [CODSearchModel cleanAllSearchHistory];
        [self userCenterArr];
//        [self.itemCollectionView reloadData];
        
        //        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //        [self showLoading];
        //        params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
        //        [[HJNetWorkQuery shareManger] AFrequestData:@"App,Store,delhistory" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
        //            // NSLog(@"----==== %@",result);
        //            if ([result[@"code"] integerValue] == 200) {
        //
        //                [self loadData];
        //
        //            } else {
        //                [self showErrorText:result[@"message"]];
        //            }
        //        } AndError:^(NSError *error) {
        //            [self showErrorText:@"网络异常，请重试!"];
        //        }];
    }];
    
    
    
}
#pragma mark - 导航栏的返回按钮 Click Event
//-(void)NavAllBackClicked {
//
//    [self.navigationController popViewControllerAnimated:YES];
//
//}


-(void)dealloc{
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    self.keyTextField.text = self.jiLuString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
