//
//  CODCompanyDetailModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CODDectateExampleModel.h"

@class CODSpecialModel,MyCommentImfoMode;

@interface CODCompanyDetailModel : CODBaseModel

/** id */
@property (nonatomic,copy) NSString *companyId;
/** 商户id */
@property (nonatomic,copy) NSString *merchant_id;
/** 公司名称 */
@property (nonatomic,copy) NSString *name;
/** 公司logo */
@property (nonatomic,copy) NSString *logo;
/** 联系电话 */
@property (nonatomic,copy) NSString *contact_number;
/** 地址 */
@property (nonatomic,copy) NSString *address;
/** 经度 */
@property (nonatomic,copy) NSString *longitude;
/** 纬度 */
@property (nonatomic,copy) NSString *latitude;
/** 列头部-店招轮播图 */
@property (nonatomic,strong) NSArray *images;
/** 好评度 */
@property (nonatomic,copy) NSString *score;
/** 案例数量 */
@property (nonatomic,copy) NSString *case_number;
/** 评论数量 */
@property (nonatomic,copy) NSString *comment_number;
/** 是否收藏：0=否；1=是 */
@property (nonatomic,copy) NSString *is_collect;
/** 承接类型 */
@property (nonatomic,copy) NSString *accept_type;
/** 承接价格 */
@property (nonatomic,copy) NSString *accept_price;
/** 服务区域 */
@property (nonatomic,copy) NSString *service_area;
/** 装修案例 */
@property (nonatomic,strong) NSArray <CODDectateExampleModel *> *cases;
/** 特色服务 */
@property (nonatomic,strong) NSArray <CODSpecialModel *> *attr_list;
/**评论 */
@property (nonatomic,strong) NSArray <MyCommentImfoMode*> *comment;
/**商家信息cell高度 */
@property (nonatomic,assign) CGFloat shopRowHeight;

@end


@interface CODSpecialModel : CODBaseModel
/** 特色服务标题 */
@property (nonatomic,copy) NSString *name;
/** 特色服务内容 */
@property (nonatomic,copy) NSString *content;

@end
