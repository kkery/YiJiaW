//
//  CODImageLineView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CODImageLineViewDirection) {// 方向
    CODImageLineViewDirectionHorizontal = 0,// 水平
    CODImageLineViewDirectionVertical// 垂直
};


// 多图片直线布局
@interface CODImageLineView : UIView

@property (nonatomic, assign) CODImageLineViewDirection direction;// 方向
@property (nonatomic, strong) NSArray *images;// 图片
@property (nonatomic, strong) NSArray *netImages;// 网络图片

@property (nonatomic, copy) void(^singleTap)(NSUInteger index);// 单点

@end
