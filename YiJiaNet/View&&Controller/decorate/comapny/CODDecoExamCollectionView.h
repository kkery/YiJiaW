//
//  CODDecoExamCollectionView.h
//  CutOrder
//
//  Created by yhw on 15/5/14.
//  Copyright (c) 2015年 YuQian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CODDectateExampleModel.h"

@interface CODDecoExamCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void(^itemActionBlock)(CODDectateExampleModel *model);

@end
