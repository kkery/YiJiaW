//
//  CODLouPanInfoViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "CODNewHorseModel.h"
@interface CODLouPanInfoViewCell : CODBaseTableViewCell
@property (nonatomic, strong, readonly) UIButton *moreButton;

- (void)configureWithModel:(CODNewHorseModel *)model;

@end
