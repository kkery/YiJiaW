//
//  CODIntrinsicTitleView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODIntrinsicTitleView.h"

@implementation CODIntrinsicTitleView
// 重写intrinsicContentSize 的Get 方法 适配iOS11 titleView
- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
