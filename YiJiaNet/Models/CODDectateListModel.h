//
//  CODDectateListModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/9.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODDectateListModel : CODBaseModel

/** 公司id */
@property (nonatomic,copy) NSString *compId;
/** 公司名称 */
@property (nonatomic,copy) NSString *name;
/** 公司logo */
@property (nonatomic,copy) NSString *logo;
/** 好评度 */
@property (nonatomic,copy) NSString *score;
/** 距离 */
@property (nonatomic,copy) NSString *distance;
/** 案例数量 */
@property (nonatomic,copy) NSString *case_number;
/** 列表图片 */
@property (nonatomic,strong) NSArray *images;

@end
