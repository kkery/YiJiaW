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
- (NSString *)currentCityName {// 当前城市名称
    return [[NSUserDefaults standardUserDefaults] objectForKey:CODCityDefaultNameKey] ?: CODCityDefaultName;
}
- (NSString *)longitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CODCityDefaultLatitudeKey];
}
- (NSString *)latitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CODCityDefaultLongitudeKey];
}

+ (BOOL)logged {
    return get(CODLoginTokenKey) != nil;
}

@end
