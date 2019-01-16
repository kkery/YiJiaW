//
//  MessageTypeTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "UIBadgeView.h"

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeSystem = 0,
    MessageTypeOrder,
    MessageTypeActivity,
};

@interface MessageTypeTableViewCell : CODBaseTableViewCell

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) NSInteger unreadCount;

- (void)configureWithModel:(NSDictionary *)model;

@end
