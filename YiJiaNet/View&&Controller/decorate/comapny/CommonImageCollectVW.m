//
//  CommonImageCollectVW.m
//  WGC
//
//  Created by Tang on 2018/4/8.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#define itemWidth ((SCREENWIDTH - (2 * 10) - (2 * 15)) / 3)

#import "CommonImageCollectVW.h"

#import "ImageBrowserViewController.h"

@interface CommonImageCollectVW()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 图片集合视图 */
@property (nonatomic,strong)UICollectionView *imgCollect;

@end

@implementation CommonImageCollectVW
static NSString *const itemID = @"imgCollectItemIdentifer";

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // TODO 假的三种图
//        self.imgArr = @[@"",@"",@""];
        
        [self addSubview:self.imgCollect];
        [self.imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        [self getCurentContentHeight];
        
    }return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count > 3 ? 3 : self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonImageCollectItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    if ([self.imgArr[indexPath.item] isKindOfClass:[NSString class]]) {
        
        //TODO截取前三个图片数组
        NSArray *showImageArr;
        if (self.imgArr.count > 3) {
            showImageArr = [self.imgArr subarrayWithRange:NSMakeRange(0, 3)];
        } else {
            showImageArr = self.imgArr;
        }
        item.imgData = showImageArr[indexPath.item];
        
        if (indexPath.item == 2 && self.imgArr.count > 3) {
            UILabel *contLabel = [UILabel GetLabWithFont:kFont(36) andTitleColor:[UIColor whiteColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"+0"];
            contLabel.text = kFORMAT(@"+%@", @(self.imgArr.count-3));
            [item.contentView addSubview:contLabel];
            [contLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(item.contentView);
                make.width.equalTo(@100);
                make.height.equalTo(@40);
            }];
        }
    }
    
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIViewController getCurrentVC]) {
        [ImageBrowserViewController show:[UIViewController getCurrentVC] type:PhotoBroswerVCTypeModal index:indexPath.item imagesBlock:^NSArray *{
            return self.imgArr;
        }];
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
        self.height = itemWidth;
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
        self.imgCollect = [UICollectionView getCollectionviewWithFrame:CGRectZero andVC:self andBgColor:[UIColor whiteColor] andFlowLayout:[UICollectionView getCollectFlowLayoutWithMinLineSpace:5 andMinInteritemSpacing:10 andItemSize:CGSizeMake(itemWidth, itemWidth) andSectionInsert:UIEdgeInsetsMake(0, 15, 0, 15) andscrollDirection:UICollectionViewScrollDirectionVertical] andItemClass:[CommonImageCollectItem class] andReuseID:itemID];
    }return _imgCollect;
}

@end


@interface CommonImageCollectItem ()

/** 图片*/
@property (nonatomic,strong)UIImageView *imgVW;

@end


@implementation CommonImageCollectItem


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
            if ([imgImfo hasPrefix:@"http"] || [imgImfo hasPrefix:@"https"]) {
                [self.imgVW sd_setImageWithURL:[NSURL URLWithString:kFORMAT(@"%@",imgData)] placeholderImage:kGetImage(@"place_list")];
            }else{
                [self.imgVW setImage:kGetImage(@"place_list")];
            }
        }
    } else if ([imgData isKindOfClass:[UIImage class]]){
        [self.imgVW setImage:(UIImage *)imgData];
    }
}

@end



