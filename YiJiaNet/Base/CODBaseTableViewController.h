//
//  CODBaseTableViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseViewController.h"

@interface CODBaseTableViewController : CODBaseViewController<UITableViewDelegate,UITableViewDataSource>

/** baseTableViewPlain */
@property (nonatomic,strong)UITableView *baseTabeleviewPlain;
/** baseTableViewGroup */
@property (nonatomic,strong)UITableView *baseTabeleviewGrouped;
/** dataSourceList */
@property (nonatomic,strong)NSMutableArray *dataSourceList;

/** 记录输入数据 */
@property (nonatomic,strong)NSMutableDictionary *recode_input_dic;


@end


@interface SingleTitleTableHeadVW : UITableViewHeaderFooterView

+(instancetype )headrViewWithTableView:(UITableView *)tableView andReuseID:(NSString *)identifier;

/** 标题 */
@property (nonatomic, copy) NSString *tle;

/** 标题颜色 */
@property (nonatomic, copy) UIColor *tleColor;
/** 标题字体 */
@property (nonatomic, copy) UIFont *tleFont;


/** 左侧间距 */
//默认为15
@property (nonatomic,assign) CGFloat left_margin;

/** 是否隐藏底部分割线 */
@property (nonatomic,assign) BOOL isHiddenBotomLineVW;

@end

