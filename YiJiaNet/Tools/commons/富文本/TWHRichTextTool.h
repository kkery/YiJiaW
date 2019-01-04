//
//  TWHRichTextTool.h
//  SchoolLife
//
//  Created by 汤文洪 on 2017/11/14.
//  Copyright © 2017年 汤文洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWHRichTextTool : NSObject
#pragma mark - 富文本操作
/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+(NSMutableAttributedString *)changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space;

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace;

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;

/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *  @param options  设置字符串的形式
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray AndOptions:(NSInteger)options;

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *  @param color 下划线颜色
 *  @param NSUnderlineStyle  下划线的状态
 *  @param TextColor 设置文字颜色
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray lineColor:(UIColor *)color LineStyle:(NSInteger)NSUnderlineStyle AndTextColor:(UIColor *)TextColor AndOptions:(NSInteger)options;


/**
 *  添加删除线
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *  @param color 下划线颜色
 *  @param style  下划线的状态
 *  @return 生成的富文本
 */
+(NSMutableAttributedString *)addDelectLineTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray DelectLineColor:(UIColor *)color DelectLineStyle:(NSInteger)style AndTextColor:(UIColor *)TextColor AndOptions:(NSInteger)options;

/*
 NSCaseInsensitiveSearch = 1
 NSLiteralSearch = 2,精确逐字符等价
 NSBackwardsSearch = 4,搜索从源字符串的结束
 NSAnchoredSearch = 8,搜索是有限的开始(或结束,如果NSBackwardsSearch)的源字符串
 NSNumericSearch = 64,中添加10.2;数字字符串内使用数字值相比,Foo2。txt < Foo7。txt < Foo25。txt;只适用于比较方法,找不到
 NSDiacriticInsensitiveSearch NS_ENUM_AVAILABLE(10_5, 2_0) = 128
 NSWidthInsensitiveSearch
 */

+ (NSMutableArray *)getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString;


/**
 同时更改文字 颜色 段落间距
 */
+ (NSMutableAttributedString *)changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray AndOptions:(NSInteger)options andchangeLineSpaceWithLineSpace:(CGFloat)lineSpace;

/**
 部分内容更改单一属性
 */
+(NSMutableAttributedString *)changePartFontOrColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString FontStringArray:(NSArray *)FontArray ColorStringArray:(NSArray *)ColorArray AndOptions:(NSInteger)options;
@end
