//
//  NSObject+Method.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSObject (Method)

/** 处理空字典,判断是否为空 */
+(NSMutableDictionary *)getValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
/** 打印属性 */
-(void)getpropertyFormDic:(NSDictionary *)dataDic;
/** 字典转json数据 */
+(NSString *)convertDictionaryToJsonData:(NSDictionary *)dict;
/** json转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/** 数组转json数据 */
+ (NSString *)arrayToJSONString:(NSArray *)array;
/** 获取当前屏幕显示的控制器 */
+(UIViewController *)getCurrentVC;
/** 获取当前屏幕中present出来的viewcontroller */
+(UIViewController *)getPresentedViewController;

@end


@interface NSString (CategoryMethods)
- (NSString *)base64;
-(NSString *)urlCode;
/** 是否全为数字 */
- (BOOL)isAlphaNum;
+(BOOL)isPureFloat:(NSString *)string;
/** 是否为中文 */
- (BOOL)isChinese;
/** 是否为邮箱 */
+(BOOL)isValidateEmail:(NSString *)email;
/** 判断是否为整形 */
+ (BOOL)isPureInt:(NSString*)string;
/** iOS判断一个字符串中是否都是数字 */
+ (BOOL)isPureNumandCharacters:(NSString *)string;
/** 是否是手机号 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum ;
/** 判断密码格式(6-16位数字字母) */
+(BOOL )ValidPassword:(NSString *)pwStr;
/** 判断url链接有效性 */
+ (BOOL)urlValidation:(NSString *)string;
/** 时间戳转日期 */
+(NSString *)getDateStringWithTimeInterval:(NSString *)timeInterval DataFormatterString:(NSString *)dataFormatterString;
/** 日期转时间戳 */
+(double)getTimeIntervalWithDateString:(NSString *)dateString DataFormatterString:(NSString *)dataFormatterString;
/** 将date转成时间戳 */
+(NSString *)GetTimeIntervalWithDate:(NSDate *)date;
/** 字符串转日期 */
+(NSDate*)getDateFromString:(NSString*)uiDate withFormateStr:(NSString *)formatString;
/** NSDate转NSString */
+(NSString *)GetDateStrStrinWithDate:(NSDate *)date andFormatStr:(NSString *)formatStr;
/** 获取星期数 */
+(NSString *)getNowWeekdayWithDate:(NSDate *)date;

/*
  在一串字符串指定位置用*代替
  telestr：内容 StarPath：起始位置 Count：替换的个数
 （NSMakeRange(StarPath,Count)：为加密的起始位置和几位数字）
*/
+(NSString*)changeStr:(NSString*)teleStr WithStartpath:(NSInteger)StarPath WithCount:(NSInteger)Count;

/** 阿拉伯数字转中文数字 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;
/** 处理HTML字符 */
+(NSString *)htmlEntityDecode:(NSString *)string;

-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;

@end


@interface UIImage (ImageMethod)

/** 缩放图片 */
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

/** 通过颜色获取图片 */
+ (UIImage *) getImageWithColor:(UIColor*)color andHeight:(CGSize )size;

+ (UIImage *)imageResizableNamed:(NSString *)name;

+ (UIImage *)imageWatermarkNamed:(NSString *)watermarkName named:(NSString *)name scale:(CGFloat)scale;

+ (UIImage *)imageRoundNamed:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)imageCaptureWithView:(UIView *)view;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIColor *)pixelColorAtLocation:(CGPoint)point;

@end


@interface UIColor (Hex)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *)colorWithSETPRICE:(NSString *)SETPRICE price:(NSString*)PRICE;
+ (UIColor *)colorWithRAISELOSE:(NSString *)RAISELOSE;

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;

@end


@interface UIViewController(VCMethod)

/** 设置状态栏背景色 */
- (void)setStatusBarBackgroundColor:(UIColor *)color;

- (void)showAlertOnlyConfirmStyleWithTitle:(NSString *)tle Mesage:(NSString *)mesage Determine:(void(^)(id determine))determine;

- (void)showAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andCancel:(void(^)(id cancel))canCel Determine:(void(^)(id determine))determine;

- (void)showSheetAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andActions:(NSArray *)actions;

/** 网络异常空视图 */
- (UIView *)netErrorNullVWWithFrame:(CGFloat )height Target:(id)target ClickEvent:(SEL)click;

/** 无数据空视图 */
- (UIView *)noneDataUIWithHeight:(CGFloat )height title:(NSString *)tle icon:(UIImage *)image;

-(void)removeSelfFromNav;

@end

