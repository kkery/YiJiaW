//
//  CommonImageCollectVW.h
//  WGC
//
//  Created by Tang on 2018/4/8.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonImageCollectVW : UIView

/** 图片数据 */
@property (nonatomic, copy) NSArray *imgArr;

@end



@interface CommonImageCollectItem : UICollectionViewCell

/** 图片信息 */
@property (nonatomic, copy) id imgData;

@end
