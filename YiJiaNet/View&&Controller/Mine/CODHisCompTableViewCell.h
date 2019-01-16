//
//  CODHisCompTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "CODImageLineView.h"
#import "CODDectateListModel.h"
#import "CODHistroyModel.h"

@interface CODHisCompTableViewCell : CODBaseTableViewCell

@property (nonatomic, strong, readonly) CODImageLineView *corverImageView;

- (void)configureWithModel:(CODDectateListModel *)model;

@end
