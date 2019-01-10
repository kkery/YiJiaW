//
//  CODCompanyDetailModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCompanyDetailModel.h"
#import "MyCommentImfoMode.h"

@implementation CODCompanyDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"companyId":@"id",
             };
}
// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"cases" : [CODDectateExampleModel class],
             @"comment" : [MyCommentImfoMode class],
             @"attr_list" : [CODSpecialModel class],
             };
}

@end

@implementation CODSpecialModel

@end
