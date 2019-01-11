//
//  GoodsDetailCommentGradeVW.m
//  WGC
//
//  Created by Tang on 2018/4/13.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import "GoodsDetailCommentGradeVW.h"

#import "StoreSearchCollectLayout.h"

@interface GoodsDetailCommentGradeVW()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 评价分类集合视图 */
@property (nonatomic,strong)UICollectionView *kindCollect;
/** 当前选中的下标 */
@property (nonatomic,assign) NSInteger curent_select_index;

@end

@implementation GoodsDetailCommentGradeVW
static NSString *const itemID = @"GoodsDetailCommentGradeItemIdentifer";

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMainUI];
        
    }return self;
}

-(void)setMainUI
{
    [self addSubview:self.kindCollect];
    [self.kindCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.top.equalTo(self.mas_top).offset(20);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.kinArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailCommentGradeItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    if ([self.kinArr[indexPath.item] isKindOfClass:[NSString class]]) {
         item.content = self.kinArr[indexPath.item];
    }
    
    item.isSelectStyle = indexPath.item == self.curent_select_index ? YES : NO;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //更新下标 刷新整个集合视图
    self.curent_select_index = indexPath.item;
    [self.kindCollect reloadData];
    if (self.SelectIteamBlock) {
        self.SelectIteamBlock(indexPath.item);
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.kinArr[indexPath.item] isKindOfClass:[NSString class]]) {
        CGSize TextSize = kGetTextSize(((NSString *)(self.kinArr[indexPath.item])), MAXFLOAT,40,15);
        TextSize.width += 35;
        return CGSizeMake(TextSize.width,35);
    }else{
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    self.height = 15 + 20 + 10 + self.kindCollect.contentSize.height + 8;
    if (self.ReloadHeightBlock) {
        self.ReloadHeightBlock();
    }
}

#pragma mark - setter
-(void)setKinArr:(NSArray *)kinArr{
    _kinArr = kinArr;
    [self.kindCollect reloadData];
    [super layoutIfNeeded];
}

#pragma mark - getter
-(UICollectionView *)kindCollect
{
    if (!_kindCollect) {
        _kindCollect = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:[UIColor whiteColor] andFlowLayout:[[StoreSearchCollectLayout alloc]init] andItemClass:[GoodsDetailCommentGradeItem class] andReuseID:itemID];
    }return _kindCollect;
}

@end



@interface GoodsDetailCommentGradeItem ()

/**  内容 */
@property (nonatomic,strong)UILabel *tleLab;

@end

@implementation GoodsDetailCommentGradeItem

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tleLab];
        [self.tleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
    }return self;
}

#pragma mark - setter
-(void)setContent:(NSString *)content{
    _content = content;
    [self.tleLab setText:content];
}

-(void)setIsSelectStyle:(BOOL)isSelectStyle{
    _isSelectStyle = isSelectStyle;
    if (isSelectStyle == YES) {
        [self.tleLab setTextColor:[UIColor whiteColor]];
        [self.tleLab setBackgroundColor:CODColorTheme];
    }else{
        [self.tleLab setTextColor:CODColor333333];
        [self.tleLab setBackgroundColor:CODHexColor(0xD7F2FF)];
    }
}


#pragma mark - getter
-(UILabel *)tleLab{
    if (!_tleLab) {
        _tleLab = [UILabel GetLabWithFont:kFont(15) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:nil];
        [_tleLab setLayWithCor:17 andLayerWidth:0 andLayerColor:nil];
    }return _tleLab;
}

@end






