//
//  CODCommentModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCommentModel.h"

@implementation CODCommentModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"commentId":@"id"};
}
@end
