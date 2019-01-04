//
//  MessageTypeTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "UIBadgeView.h"
@interface MessageTypeTableViewCell : CODBaseTableViewCell
@property (nonatomic, strong, readonly) UIBadgeView *badgeView;
@property (nonatomic, strong, readonly) UILabel *detailLable;

- (void)configureWithModel:(NSDictionary *)model;

@end
