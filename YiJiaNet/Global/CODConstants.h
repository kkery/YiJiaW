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

// !!!第三方平台!!!
static NSString * const CODJPushAppKey = @"47b3d73d20d15c7d43ca53fe";//极光推送

static NSString * const CODAMapApiKey = @"638fda40d439fb2c305ecce9cf2ab2e3";//高德地图

static NSString * const CODUMAPPKey = @"5c403991f1f55693c900151d";//友盟

static NSString * const CODQQAppKey = @"a941009835873148e016b37cab2c995b";//QQ
static NSString * const CODQQAppID = @"101545772";

static NSString * const CODWeChatID = @"wx6c1d14b201c7e196";//WeChat
static NSString * const CODWeChatSecret = @"ff3ce516dacb0d649a5bcba1cdb04f7d";

// 单例归档和缓存目录
static NSString * const CODArchiveDirectory = @"CODArchives";
static NSString * const CODCacheDirectory = @"CODCaches";

// 引导
static NSString * const CODGuideKey = @"CODGuide3.3";// 需要引导的加上当前版本号

// ==========↑↑↑↑↑↑↑↑↑↑========== //


// 请求参数value
static NSInteger const CODRequstPageSize = 10;// 默认每页数量

// 城市
static NSString * const CODCityDefaultName = @"南昌";// 默认城市
static NSString * const CODCityNameKey = @"CODCityName";
static NSString * const CODLocationAdressKey = @"CODLocationAdress";
static NSString * const CODLatitudeKey = @"CODLatitude";// 纬度，地球坐标
static NSString * const CODLongitudeKey = @"CODLongitude";// 经度，地球坐标

// 本地存储key
static NSString * const CODLoginTokenKey = @"CODDeviceToken";// 设备令牌
static NSString * const CODUserInfoKey = @"CODUserInfo";// 用户信息key
static NSString * const CODServiceTelKey = @"CODServiceTel";// 用户信息key

// 通知
static NSString * const CODLoginNotificationName = @"CODLoginNotification";// 登录通知
static NSString * const CODMsgUnreadNotificationName = @"CODMsgUnreadNotification";// 消息未读红点通知
static NSString * const CODAlixpayNotificationName = @"CODAlixpayNotification";// 阿里无线支付通知
static NSString * const CODWxpayNotificationName = @"CODWxpayNotification";// 微信支付通知
static NSString * const CODSwitchCityNotificationName = @"CODSwitchCityNotification";// 切换城市通知
static NSString * const CODLocationNotificationName = @"CODLocationNotification";// 定位通知（成功or失败）

static NSString * const CODLoginCompletionNotificationName = @"CODLoginCompletionNotification";// 登录完成通知
static NSString * const CODRefeshMineNotificationName = @"CODLoginCompletionNotification";// 个人信息刷新通知
static NSString * const CODDeleteHistotyNotificationName= @"CODDeleteHistotyNotification";// 删除足迹通知

// UI
static CGFloat const CODStatusBarHeight = 20;
static CGFloat const CODNavigationBarHeight = 44;
static CGFloat const CODToolBarHeight = 44;
static CGFloat const CODTabBarHeight = 49;

static NSString * const CODDetaultWebUrl = @"https://www.0791jr.com";// 嘉瑞网页

#endif /* CODConstants_h */
