//
//  CODDIYGridTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/25.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYGridTableViewCell.h"
#import "CODDIYCollectionViewCell.h"

static NSString * const kCODDIYCollectionViewCell = @"CODDIYCollectionViewCell";

@interface CODDIYGridTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *gridCollectionView;

@end

@implementation CODDIYGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        
        self.gridCollectionView = ({
            UICollectionView *collectionView = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:CODColorBackground andFlowLayout:[UICollectionView getCollectFlowLayoutWithMinLineSpace:10 andMinInteritemSpacing:10 andItemSize:CGSizeMake((SCREENWIDTH-30)/2, (SCREENWIDTH-30)/2+80) andSectionInsert:UIEdgeInsetsMake(10, 10, 0, 10) andscrollDirection:UICollectionViewScrollDirectionVertical] andItemClass:[CODDIYCollectionViewCell class] andReuseID:kCODDIYCollectionViewCell];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView;
        });
        [self.contentView addSubview:self.gridCollectionView];
        
        [self.gridCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.gridCollectionView reloadData];
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CODDIYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCODDIYCollectionViewCell forIndexPath:indexPath];
    cell.viewModel = (CODDIYModel*)self.dataArray[indexPath.item];
    return cell;
}

#pragma mark - Collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(CustomCollection:didSelectCollectionItem:)]){
        [self.delegate CustomCollection:collectionView didSelectCollectionItem:indexPath.row];
    }
}
+ (CGFloat)heightForRow {
    return 200;
}

@end
