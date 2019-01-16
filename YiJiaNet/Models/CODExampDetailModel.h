//
//  CODExampDetailModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/14.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODExampDetailModel : CODBaseModel

/** 案例详情id */
@property (nonatomic,copy) NSString *caseId;
/** 商户id */
@property (nonatomic,copy) NSString *merchant_id;
/** 轮播图 */
@property (nonatomic,copy) NSArray *imgs;
/** 案例标题 */
@property (nonatomic,copy) NSString *title;
/** 主图 */
@property (nonatomic,copy) NSString *img;
/** 类型：1=全装；2=半包 */
@property (nonatomic,copy) NSString *type;
/** 小区名称 */
@property (nonatomic,copy) NSString *house_areas;
/** 装修费用 */
@property (nonatomic,copy) NSString *decorate_fare;
/** 风格 */
@property (nonatomic,copy) NSString *style;
/** 户型 */
@property (nonatomic,strong) NSString *house_type;
/** 面积 */
@property (nonatomic,copy) NSString *acreage;
/** 图文详情链接 */
@property (nonatomic,copy) NSString *info_url;

- (NSString *)typeName;// 类型名称

@end
