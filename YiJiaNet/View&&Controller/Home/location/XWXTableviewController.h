//
//  XWXTableviewController.h
//  BaiYeMallShop
//
//  Created by XWXMac on 2018/8/6.
//  Copyright © 2018年 许得诺言. All rights reserved.
//

#import "CODBaseViewController.h"

@interface CODBaseTableviewController : CODBaseViewController<UITableViewDelegate,UITableViewDataSource>

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

