//
//  CODMineOrderTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODInsetTableViewCell.h"
#import "CODOrderModel.h"
@interface CODMineOrderTableViewCell : CODInsetTableViewCell
- (void)configureWithModel:(CODOrderModel *)model type:(NSString *)type;
+ (CGFloat)heightForRow;
@end
