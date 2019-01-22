//
//  MeasureDocView.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/19.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureDocView : UIView
@property (nonatomic, assign) NSInteger type;

/** 图片数据 */
@property (nonatomic, copy) NSArray *imgArr;

@end


@interface DocImageCollectCell : UICollectionViewCell

/** 图片信息 */
@property (nonatomic, copy) id imgData;

@end
