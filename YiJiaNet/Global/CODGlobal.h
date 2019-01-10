//
//  CODGlobal.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//
#import "CODConstants.h"
#import "CODMacros.h"

#define COD_LOGGED ([CODGlobal logged])  // 已登录
#define COD_USERID get(CODLoginTokenKey)  // 用户登录秘钥

@interface CODGlobal : NSObject

+ (instancetype)sharedGlobal;// 单例对象

+ (BOOL)logged;// 登录状态，userid不为0

@property (nonatomic, copy) NSString *currentCityName;// 当前城市名称
@property (nonatomic, copy) NSString *longitude;// 经度
@property (nonatomic, copy) NSString *latitude;// 纬度

@end
