//
//  CODMessageModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODMessageModel : CODBaseModel

/** 消息id */
@property (nonatomic,copy) NSString *msgId;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 消息状态，0=未读；1=已读 */
@property (nonatomic,copy) NSString *status;
/** 发送时间 */
@property (nonatomic,copy) NSString *send_time;
/** 消息附加数据 */
@property (nonatomic,copy) NSString *data;
/** 对应数据id */
@property (nonatomic,copy) NSString *data_id;//若为预约消息/活动消息，这根据data_id跳转到对应的页面
/** 活动图片 */
@property (nonatomic,copy) NSString *img;
/** 活动地址 */
@property (nonatomic,copy) NSString *url;

@end
