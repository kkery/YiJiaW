//
//  CODAnnouncementCell.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGAdvertScrollView;
@interface CODAnnouncementCell : CODBaseTableViewCell

+ (CODAnnouncementCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier;

@property(nonatomic,strong) NSArray *newstitles;
@property(nonatomic,strong) NSArray *newstitlesIcons;
//@property(nonatomic,strong) NSMutableArray *topTitles;
//@property(nonatomic,strong) NSMutableArray *bottomTitles;

//- (void)cofigureWithNews:(NSDictionary *)dic;

/** 点击回调 */
@property (nonatomic, copy) void(^NoticeScrollBlock)(SGAdvertScrollView *view,NSInteger idx);

@end
