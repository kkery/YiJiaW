//
//  CODSearchModel.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"
#import "TMCache.h"

@interface CODSearchModel : CODBaseModel

+ (NSArray *)getSearchHistory;
+ (void)addSearchHistory:(NSString *)searchString;
+ (void)cleanAllSearchHistory;

@end

@interface TMCache (Extension)

+ (instancetype)TemporaryCache;
+ (instancetype)PermanentCache;

@end
