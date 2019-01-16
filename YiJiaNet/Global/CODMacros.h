//
//  CODMacros.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#ifndef CODMacros_h
#define CODMacros_h
// UI
#define CODScreenBounds [UIScreen mainScreen].bounds
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define KUIScreenWidthScale (SCREENWIDTH / 320.0)
#define KNavtationHeight 44
#define KStatusBarHeight CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
#define KTabBarNavgationHeight (IS_IPhoneX ? 88 : 64)
#define KTabBarHeight (IS_IPhoneX ? 83 : 49)
#define KTabBarBottomH (IS_IPhoneX ? 34 : 0)
#define SafeAreaBottomHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34 : 0)

//屏幕比例 320x568  375x667 1920 * 1080
#define proportionW  [UIScreen mainScreen].bounds.size.width/320.0
#define proportionH  [UIScreen mainScreen].bounds.size.height/568.0   

//判断设备
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define KPad [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_X ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )812 ) < DBL_EPSILON )
/**
 iOS11适配
 */
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


// 是否是iPhoneX
#define k_iOS_11 @available(iOS 11.0, *)

// QQ WeChat
#define klogin_QQ @"Login_QQ"
#define klogin_WeChat @"Login_WeChat"

//Usedefault
#define kUserCenter [NSUserDefaults standardUserDefaults]
#define kNotiCenter [NSNotificationCenter defaultCenter]

// Log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define CODLogDebug() NSLog(@"%@, %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:@"%i", __LINE__])
#define CODLogObject(object) NSLog(@"%@", object)
//强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type; // weak
//弱引用
#define kStrongSelf(type)  __strong typeof(type) type = weak##type; // strong

// 颜色
#define CODRgbColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define CODRgbaColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CODHexColor(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define CODHexaColor(hex, a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:(a)]

// 主色，蓝
#define ThemeColor CODHexColor(0x00A0E9)

#define CODColorTheme CODHexColor(0x00A0E9)
// 背景
#define CODColorBackground CODHexColor(0xF5F5F5)
// 线
#define CODColorLine CODHexColor(0xF5F5F5)

//分割线颜色
#define kSepLineColor CODRgbColor(221, 221, 221)

// 按钮
#define CODColorButtonNormal CODHexColor(0x00A0E9)
#define CODColorButtonHighlighted CODHexaColor(0x00A0E9, 0.6)
#define CODColorButtonDisabled CODHexaColor(0x00A0E9, 0.6)
// 常用
#define CODColor333333 CODHexColor(0x333333)
#define CODColor666666 CODHexColor(0x666666)
#define CODColor999999 CODHexColor(0x999999)
#define CODColorWhite CODHexColor(0xffffff)
//分割线颜色
#define SepLineColor CODRgbColor(235, 235, 235)
//灰色背景
#define kLightGrayBgColor CODRgbColor(245, 245, 245)

//去除分割线
#define kNoneSepLine(tab) tab.separatorStyle = UITableViewCellSeparatorStyleNone
//cell无选中
#define kCellNoneSelct(cell) cell.selectionStyle = UITableViewCellSelectionStyleNone

//获取图片
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//获取字体大小
#define kFont(fontsize) [UIFont systemFontOfSize:fontsize]
#define XFONT_SIZE(size) [UIFont systemFontOfSize:FontSize(size)]
//获取文本大小
#define kGetTextSize(text,width,height,font) [text boundingRectWithSize:CGSizeMake(width,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0 ? YES : NO )
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 ? YES : NO )
//字符串初始化
#define kFORMAT(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]
//打电话
#define kCall(PhNumStr) NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];\
if (compare == NSOrderedDescending || compare == NSOrderedSame) {\
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFORMAT(@"telprompt://%@",PhNumStr)] options:@{} completionHandler:nil];\
} else {\
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFORMAT(@"telprompt://%@",PhNumStr)]];\
}

#define kBadgeTipStr @"waimianbian"

/**
 *  字体适配 我在PCH文件定义了一个方法
 */
static inline CGFloat FontSize(CGFloat fontSize){
    if (SCREENWIDTH==320) {
        return fontSize-2;
    }else if (SCREENWIDTH==375){
        return fontSize;
    }else{
        return fontSize+1;
    }
}

#endif /* CODMacros_h */
