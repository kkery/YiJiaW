//
//  CODUserModel.h
//  CutOrder
//
//  Created by yhw on 14/10/28.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import "CODBaseModel.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

static NSString * const CODUserPasswordKey = @"CODUserPassword";

//#define COD_PASSWORD ([UICKeyChainStore stringForKey:CODUserPasswordKey])
//
//#define COD_TOKEN ([[CODUserModel unarchive] token] ?: @"")
//#define COD_EXPIRESIN ([[CODUserModel unarchive] expiresIn])
//#define COD_LOGINTIME ([[CODUserModel unarchive] loginTime])
//#define COD_REFRESHTOKEN ([[CODUserModel unarchive] refreshToken] ?: @"")
//
//#define COD_LOGGED ([CODUserModel logged])
//
//#define COD_USERNAME ([[CODUserModel unarchive] username] ?: @"")

@interface CODUserModel : CODBaseModel

@property (nonatomic, copy) NSString *token;// 访问令牌
@property (nonatomic, copy) NSString *refreshToken;// 刷新令牌
@property (nonatomic, assign) NSInteger expiresIn;// 过期，单位秒
@property (nonatomic, assign) long long loginTime;// 登录时间，单位毫秒

@property (nonatomic, copy) NSString *nickname;// 账号，目前是手机号码
@property (nonatomic, copy) NSString *password;// 密码，md5
@property (nonatomic, assign) NSInteger userid;// 用户id
@property (nonatomic, copy) NSString *name;// 昵称
@property (nonatomic, assign) NSInteger gender;// 性别，1男，2女
@property (nonatomic, copy) NSString *logo;// 头像
@property (nonatomic, copy) NSString *maxLogo;// 大图头像

@property (nonatomic, assign) CGFloat balance;// 余额
@property (nonatomic, assign) NSInteger integral;// 积分

//@property (nonatomic, copy) NSString *couponCode;// 优惠码
//@property (nonatomic, assign) CGFloat couponAmount;// 抵金券金额

+ (BOOL)logged;// 登录状态，userid不为0
+ (BOOL)logoutCompletely;// 完全登出，删除用户数据和密码
+ (BOOL)logoutUserid;// 删除userid，保留用户数据和密码
+ (BOOL)logoutUseridAndPassword;// 删除userid和密码，保留用户数据和密码

+ (NSString *)genderName;// 性别名字
+ (NSString *)nameByGender:(NSInteger)gender;// 性别名字

+ (BOOL)refreshIntegral:(NSInteger)integral;// 更新积分

@end
