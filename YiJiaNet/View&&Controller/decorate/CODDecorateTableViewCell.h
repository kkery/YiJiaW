//
//  CODDecorateTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "CODImageLineView.h"
// 找装修 cell
@interface CODDecorateTableViewCell : CODBaseTableViewCell

@property (nonatomic, strong, readonly) CODImageLineView *corverImageView;

- (void)configureWithModel:(NSDictionary *)model;

@end
