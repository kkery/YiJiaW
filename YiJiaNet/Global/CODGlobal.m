//
//  CODGlobal.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODGlobal.h"


@interface CODGlobal ()

@end

@implementation CODGlobal

+ (instancetype)sharedGlobal {// 单例对象
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - City
- (NSInteger)currentCityId {// 当前城市id
    return [[NSUserDefaults standardUserDefaults] integerForKey:CODCityDefaultIdKey] ?: CODCityDefaultId;
}

- (NSString *)currentCityName {// 当前城市名称
    return [[NSUserDefaults standardUserDefaults] objectForKey:CODCityDefaultNameKey] ?: CODCityDefaultName;
}
@end
