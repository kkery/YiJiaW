//
//  CODBaseModel.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CODBaseModel : NSObject

#pragma mark - Singleton archive
- (BOOL)archive;// 序列化
+ (instancetype)unarchive;// 反序列化
+ (BOOL)removeArchive;// 删除
+ (NSUInteger)archiveVersion;// 归档版本

@end
