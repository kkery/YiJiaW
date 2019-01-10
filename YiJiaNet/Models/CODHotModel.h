//
//  CODHotModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/9.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODHotModel : CODBaseModel

/** 新闻id */
@property (nonatomic,copy) NSString *hotId;
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 图片 */
@property (nonatomic,copy) NSString *img;
/** 时间 */
@property (nonatomic,copy) NSString *add_time;
/** url */
@property (nonatomic,copy) NSString *url;

@end
