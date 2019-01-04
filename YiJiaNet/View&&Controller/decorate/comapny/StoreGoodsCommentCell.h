//
//  StoreGoodsCommentCell.h
//  WGC
//
//  Created by Tang on 2018/4/12.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCommentImfoMode;
@interface StoreGoodsCommentCell : UITableViewCell

+ (StoreGoodsCommentCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier;

/** 数据 */
@property (nonatomic,strong)MyCommentImfoMode *imfo_mode;

@property(nonatomic,copy) NSString *add_timeStr;

@end
