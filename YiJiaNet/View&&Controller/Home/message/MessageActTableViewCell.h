//
//  MessageActTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/21.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "CODMessageModel.h"

@interface MessageActTableViewCell : CODBaseTableViewCell

@property (nonatomic, strong, readonly) UIButton *actButton;

- (void)configureWithModel:(CODMessageModel *)model;

@end
