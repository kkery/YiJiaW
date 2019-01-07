//
//  CODConstants.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#ifndef CODConstants_h
#define CODConstants_h

// ==========!!!上线步骤!!!========== //
/*
 1、修改服务器地址
 2、修改后台接口版本
 3、检查应用版本号
 4、检查代码警告
 5、测试增量升级
 */
// ==========↓↓↓↓↓↓↓↓↓↓========== //

// !!!服务器地址!!!
static NSString * const CODServerDomain = @"http://yjw.0791jr.com/app.php?";// 嘉瑞生产环境
//static NSString * const CODServerDomain = @"http://yijia.test/app.php?";// 本地测试环境

// !!!平台!!!
static NSString * const CODServerPlatform = @"api/app";// 应用
static NSString * const CODWebPlatform = @"web/app";// 网页
// !!!签名key!!!
static NSString * const CODServerSignKey = @"2fa7b1d74a82e202cdedd153fcc91249";
// !!!后台接口版本!!!
static CGFloat const CODServerInterfaceVersion = 4;

// 单例归档和缓存目录
static NSString * const CODArchiveDirectory = @"CODArchives";
static NSString * const CODCacheDirectory = @"CODCaches";

// 引导
static NSString * const CODGuideKey = @"CODGuide3.3";// 需要引导的加上当前版本号

// ==========↑↑↑↑↑↑↑↑↑↑========== //

// 应用
static NSString * const CODAppSchema = @"cutorderuser";// app schema
static NSString * const CODAppVersionKey = @"CODAppVersion";// 版本
static NSString * const CODUmengAppKey = @"543b44d0fd98c52dc1001d36";// 友盟
static NSString * const CODCustomerServicePhone = @"400-833-8892";// 客服电话

// 请求参数key
static NSString * const CODUseridParameterKey = @"userid";// 用户id
static NSString * const CODTokenParameterKey = @"token";// 访问令牌
static NSString * const CODSignParameterKey = @"sign";// 签名
static NSString * const CODKeyParameterKey = @"key";// 密钥
static NSString * const CODAppVersionParameterKey = @"appVersion";// 应用版本

// 城市
static NSInteger const CODCityDefaultId = 1;// 城市id
static NSString * const CODCityDefaultName = @"南昌";// 城市名称
static NSString * const CODCityDefaultIdKey = @"CODCityDefaultId";
static NSString * const CODCityDefaultNameKey = @"CODCityDefaultName";

// 本地存储key
static NSString * const CODLoginTokenKey = @"CODDeviceToken";// 设备令牌
static NSString * const CODUserInfoKey = @"CODUserInfoKey";// 用户信息key

// 推送通知
static NSString * const CODLoginNotificationName = @"CODLoginNotification";// 登录通知
static NSString * const CODMessageUnreadCountNotificationName = @"CODMessageUnreadCountNotification";// 消息未读个数通知
static NSString * const CODAlixpayNotificationName = @"CODAlixpayNotification";// 阿里无线支付通知
static NSString * const CODWxpayNotificationName = @"CODWxpayNotification";// 微信支付通知
static NSString * const CODSwitchCityNotificationName = @"CODSwitchCityNotification";// 切换城市通知
static NSString * const CODLoginCompletionNotificationName = @"CODLoginCompletionNotification";// 登录完成通知

// UI
static CGFloat const CODStatusBarHeight = 20;
static CGFloat const CODNavigationBarHeight = 44;
static CGFloat const CODToolBarHeight = 44;
static CGFloat const CODTabBarHeight = 49;

static NSString * const CODDetaultWebUrl = @"https://www.0791jr.com";// 嘉瑞网页

#endif /* CODConstants_h */
