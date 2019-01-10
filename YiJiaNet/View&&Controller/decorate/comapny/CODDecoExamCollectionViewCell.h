//
//  CODDecoExamCollectionViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseCollectionViewCell.h"
#import "CODDectateExampleModel.h"

@interface CODDecoExamCollectionViewCell : CODBaseCollectionViewCell

@property (nonatomic, strong, readonly) UIView *rightLineView;

- (void)configureWithModel:(CODDectateExampleModel *)model;

@end
