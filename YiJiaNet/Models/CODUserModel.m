//
//  CODUserModel.m
//  CutOrder
//
//  Created by yhw on 14/10/28.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import "CODUserModel.h"

@implementation CODUserModel

+ (BOOL)logged {
    return [COD_USERID integerValue] != 0;
}

+ (BOOL)logoutCompletely {
    return [UICKeyChainStore removeItemForKey:CODUserPasswordKey] && [CODUserModel removeArchive];
}

+ (BOOL)logoutUserid {
    CODUserModel *user = [CODUserModel unarchive];
    user.userid = 0;
    // 退出登录需要清空refresh token和token(已解决)
    user.refreshToken = nil;
    user.token = nil;
    return [user archive];
}

+ (BOOL)logoutUseridAndPassword {
    CODUserModel *user = [CODUserModel unarchive];
    user.userid = 0;
    // 退出登录需要清空refresh token和token(已解决)
    user.refreshToken = nil;
    user.token = nil;
    return [user archive] && [UICKeyChainStore removeItemForKey:CODUserPasswordKey];
}

+ (NSString *)genderName {
    switch ([CODUserModel unarchive].gender) {
        case 1:
            return @"男";
            break;
        case 2:
            return @"女";
            break;
        default:
            return @"女";
            break;
    }
}

+ (NSString *)nameByGender:(NSInteger)gender {
    switch (gender) {
        case 1:
            return @"男";
            break;
        case 2:
            return @"女";
            break;
        default:
            return @"女";
            break;
    }
}

+ (BOOL)refreshIntegral:(NSInteger)integral {
    CODUserModel *user = [CODUserModel unarchive];
    user.integral = integral;
    return [user archive];
}

// !!!1.字段不变2.关联对象改变3.之前关联对象源文件删除，脏数据无法解析导致增量升级打开应用奔溃
+ (NSUInteger)archiveVersion {
    return 0;
}

@end
