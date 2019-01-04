//
//  CODModifyQuantityView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const CODModifyQuantityViewContentHeight;
extern CGFloat const CODModifyQuantityViewContentWidth;

typedef void(^CODModifyQuantityViewQuantityChangeBlock)(NSUInteger quantity);

@interface CODModifyQuantityView : UIView

- (instancetype)initWithFrame:(CGRect)frame Unit:(NSString *)unit;

@property (nonatomic, copy) NSString *unit;// 单位

@property (nonatomic, assign) NSUInteger quantity;// 当前数量
@property (nonatomic, assign) NSUInteger maxQuantity;// 最大数量

@property (nonatomic, copy) CODModifyQuantityViewQuantityChangeBlock quantityChangeBlock;

@end
