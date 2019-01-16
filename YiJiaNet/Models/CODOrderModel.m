//
//  CODOrderModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODOrderModel.h"

@implementation CODOrderModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"orderId" : @"id",
             };
}
@end
