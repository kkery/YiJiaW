//
//  CODHistroyModel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODHistroyModel.h"

@implementation CODHistroyModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"browse" : [CODDectateListModel class],
             };
}

@end
