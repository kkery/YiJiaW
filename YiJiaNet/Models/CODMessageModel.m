//
//  CODMessageModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODMessageModel.h"

@implementation CODMessageModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"msgId" : @"id",
             };
}
@end
