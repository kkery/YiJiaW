//
//  NSString+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (COD)

- (NSString *)cod_md5;

- (NSString *)cod_urlEncoded;
- (NSString *)cod_urlDecoded;

- (BOOL)cod_isPhone;// 手机
- (BOOL)cod_isEmail;// 邮箱
- (BOOL)cod_isIdCardNumber;// 身份证
- (BOOL)cod_isVerificationCode;// 验证码

- (CGFloat)cod_heightWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)cod_widthWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSInteger)cod_wordCount;

- (NSString *)cod_htmlEntityDecode;

@end
