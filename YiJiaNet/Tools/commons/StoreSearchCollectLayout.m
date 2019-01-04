//
//  StoreSearchCollectLayout.m
//  XTX
//
//  Created by 汤文洪 on 2017/8/26.
//  Copyright © 2017年 TWH. All rights reserved.
//

#import "StoreSearchCollectLayout.h"

@implementation StoreSearchCollectLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *preAttr = attributes[i - 1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + 10*proportionW;//加上item间距
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
        
//        if (prevLayoutAttributes.indexPath.section == currentLayoutAttributes.indexPath.section) {
//            //我们想设置的最大间距，可根据需要改
//            NSInteger maximumSpacing = 14;
//            //前一个cell的最右边
//            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//            //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//            if((origin + maximumSpacing + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize.width) {
//                CGRect frame = currentLayoutAttributes.frame;
//                frame.origin.x = origin + maximumSpacing;
//                currentLayoutAttributes.frame = frame;
//            }
//        }
    }
    return attributes;
}

@end
