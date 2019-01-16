//
//  CODOrderModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODOrderModel : CODBaseModel

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString *merchant_id;

@property (nonatomic,copy) NSString *user_id;

@property (nonatomic,copy) NSString *start_time;

@property (nonatomic,copy) NSString *end_time;

@property (nonatomic,copy) NSString *logo;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *address;

@end
