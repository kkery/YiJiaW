//
//  CODAllSortViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODAllSortViewController.h"
#import "CODSortCollectionViewCell.h"
#import "CODDIYCateViewController.h"

static NSString * const kCODSortCollectionViewCell = @"CODSortCollectionViewCell";

@interface CODAllSortViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MJRefreshEXDelegate>

@property (nonatomic, strong) UICollectionView *sortCollectView;
@property (nonatomic, strong) NSArray *sortArray;


@end

@implementation CODAllSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarShadowImageHidden:NO];
    
    self.title = @"全部分类";
    
    self.sortCollectView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(SCREENWIDTH/3, 130);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[CODSortCollectionViewCell class] forCellWithReuseIdentifier:kCODSortCollectionViewCell];
        collectionView;
    });
    [self.view addSubview:self.sortCollectView];
    
    [self.sortCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // data
    [self loadSort];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)loadSort {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    
//    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=index" andParameters:params Sucess:^(id object) {
//        if ([object[@"code"] integerValue] == 200) {
//            self.sortArray = object[@"data"][@"lsit"];
//            [self.sortCollectView reloadData];
//        } else {
//            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
//        }
//    } failed:^(NSError *error) {
//        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
//    }];
    
    self.sortArray = @[
                       @{@"title":@"生活电器",@"icon":kGetImage(@"mall_categorize3")},
                       @{@"title":@"全部分类",@"icon":kGetImage(@"mall_categorize4")},
                       @{@"title":@"生活电器",@"icon":kGetImage(@"mall_categorize3")},
                       @{@"title":@"全部分类",@"icon":kGetImage(@"mall_categorize4")},
                       @{@"title":@"智能家具",@"icon":kGetImage(@"mall_categorize1")},
                       @{@"title":@"智能安防",@"icon":kGetImage(@"mall_categorize2")},
                       @{@"title":@"生活电器",@"icon":kGetImage(@"mall_categorize3")},
                       @{@"title":@"全部分类",@"icon":kGetImage(@"mall_categorize4")},
                       ];
    [self.sortCollectView reloadData];
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sortArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CODSortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCODSortCollectionViewCell forIndexPath:indexPath];
    cell.sort = self.sortArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CODDIYCateViewController *cateVC = [[CODDIYCateViewController alloc] init];
    cateVC.diyCategory = (indexPath.item + 1);
    [self.navigationController pushViewController:cateVC animated:YES];

}


@end
