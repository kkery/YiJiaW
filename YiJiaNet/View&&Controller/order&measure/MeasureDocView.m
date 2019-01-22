//
//  MeasureDocView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/19.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

//#define itemWidth ((SCREENWIDTH - (3 * kPadding) - (2 * kLeftRightInsert)) / 4)

#import "MeasureDocView.h"

#import "ImageBrowserViewController.h"
#import "CODBaseWebViewController.h"

static CGFloat const kLeftRightInsert = 15;
static CGFloat const kPadding = 5;
static NSString *const itemID = @"DocImageCollectCell";

@interface MeasureDocView() <UICollectionViewDataSource,UICollectionViewDelegate>

/** 图片集合视图 */
@property (nonatomic,strong) UICollectionView *imgCollect;

@property (nonatomic,assign) CGFloat itemWidth;

@end

@implementation MeasureDocView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.itemWidth = (frame.size.width - kLeftRightInsert - 4                                                                     *kPadding)/4;
        
        [self addSubview:self.imgCollect];
        
        [self.imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        [self getCurentContentHeight];
        
    }return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocImageCollectCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    if ([self.imgArr[indexPath.item] isKindOfClass:[NSString class]]) {
        
        item.imgData = self.imgArr[indexPath.item];
    }
    
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        if ([UIViewController getCurrentVC]) {
            [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:indexPath.item imagesBlock:^NSArray *{
                return self.imgArr;
            }];
        }
    } else {
        UIViewController *selfvc = [UIViewController presentingVC];
        CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:self.imgArr[0]];
        webVC.webTitleString = @"量房报告";
        [selfvc.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - Private Func
-(void)getCurentContentHeight
{
    if (self.imgArr.count > 0) {
        //        NSInteger count = self.imgArr.count / 3;
        //        if (self.imgArr.count % 3 > 0) {
        //            count += 1;
        //        }
        //        CGFloat totalHeight = count * itemWidth;
        //        totalHeight += 15;
        //        totalHeight += (count > 0 ? ((count - 1)*5) : 0);
        //        self.height = totalHeight;
        self.height = self.itemWidth;
    } else {
        self.height = 0;
    }
    
}


#pragma mark - setter
-(void)setImgArr:(NSArray *)imgArr
{
    if (![_imgArr isEqual:imgArr]) {
        _imgArr = imgArr;
        [self.imgCollect reloadData];
        [self getCurentContentHeight];
    }
}

#pragma mark - getter
-(UICollectionView *)imgCollect{
    if (!_imgCollect) {
        _imgCollect = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:[UIColor whiteColor] andFlowLayout:[UICollectionView getCollectFlowLayoutWithMinLineSpace:kPadding andMinInteritemSpacing:5 andItemSize:CGSizeMake(_itemWidth, _itemWidth) andSectionInsert:UIEdgeInsetsMake(0, kLeftRightInsert, 0, kLeftRightInsert) andscrollDirection:UICollectionViewScrollDirectionHorizontal] andItemClass:[DocImageCollectCell class] andReuseID:itemID];
    }return _imgCollect;
}

@end


@interface DocImageCollectCell ()

/** 图片*/
@property (nonatomic,strong)UIImageView *imgVW;

@end


@implementation DocImageCollectCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imgVW = [UIImageView getImageViewWithFrame:CGRectZero andImage:kGetImage(@"place_list") andBgColor:nil];
        [self.contentView addSubview:self.imgVW];
        [self.imgVW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
    }return self;
}

-(void)setImgData:(id)imgData
{
    _imgData = imgData;
    if ([imgData isKindOfClass:[NSString class]])
    {
        if (((NSString *)(imgData)).length > 0)
        {
            NSString *imgImfo = (NSString *)imgData;
            if ([imgImfo hasSuffix:@"png"] || [imgImfo hasSuffix:@"jpg"]) {
                [self.imgVW sd_setImageWithURL:[NSURL URLWithString:kFORMAT(@"%@",imgData)] placeholderImage:kGetImage(@"place_list")];
            }else{
                [self.imgVW setImage:kGetImage(@"room_pdf")];
            }
        }
    } else if ([imgData isKindOfClass:[UIImage class]]){
        [self.imgVW setImage:(UIImage *)imgData];
    }
}

@end
