//
//  CODGlobal.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//
#import "CODConstants.h"
#import "CODMacros.h"
@interface CODGlobal : NSObject

+ (instancetype)sharedGlobal;// 单例对象

@property (nonatomic, assign) NSInteger currentCityId;// 当前城市id
@property (nonatomic, copy) NSString *currentCityName;// 当前城市名称

@end
