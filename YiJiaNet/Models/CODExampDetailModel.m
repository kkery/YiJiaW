//
//  CODExampDetailModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/14.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODExampDetailModel.h"

@implementation CODExampDetailModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"caseId":@"id"};
}

- (NSString *)typeName {
    if ([self.type isEqualToString:@"1"]) {
        return @"全装";
    } else if ([self.type isEqualToString:@"2"]) {
        return @"半包";
    } else {
        return nil;
    }
}

@end
