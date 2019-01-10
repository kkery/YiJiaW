//
//  NSString+COD.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "NSString+COD.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (COD)

- (NSString *)cod_md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);// This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)cod_urlEncoded {
	if (![self length])
		return @"";

	CFStringRef static const charsToEscape = CFSTR(".:/");
	CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
	                                                                    (__bridge CFStringRef)self,
	                                                                    NULL,
	                                                                    charsToEscape,
	                                                                    kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)cod_urlDecoded {
	if (![self length])
		return @"";

	CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
	                                                                                      (__bridge CFStringRef)self,
	                                                                                      CFSTR(""),
	                                                                                      kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)unescapedString;
}

- (BOOL)cod_isPhone {
    NSString *regex = @"^1[0-9][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isIdCardNumber
{
    NSString *IDCardNumber = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([IDCardNumber length] != 18)
    {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:IDCardNumber])
    {
        return NO;
    }
    int summary = ([IDCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([IDCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([IDCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([IDCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([IDCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([IDCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([IDCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [IDCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [IDCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6
    + [IDCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];
    return [checkBit isEqualToString:[[IDCardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

- (BOOL)cod_isVerificationCode {
    NSString *regex = @"^[0-9]{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (CGFloat)cod_heightWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return size.height;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineBreakMode];
        return size.height;
#pragma clang diagnostic pop
    }
}

- (CGFloat)cod_widthWithWidth:(CGFloat)width height:(CGFloat)height font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        return size.width;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:lineBreakMode];
        return size.width;
#pragma clang diagnostic pop
    }
}

- (NSInteger)cod_wordCount {
    NSUInteger i, n = [self length], l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0;i < n;i++){
        c = [self characterAtIndex:i];
        if(isblank(c)) {
            b++;
        } else if(isascii(c)){
            a++;
        } else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(NSUInteger)ceilf((CGFloat)(a+b)/2.0);
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName: style}
                                    context:nil].size;
    resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    return resultSize;
}

- (NSString *)cod_htmlEntityDecode {
    NSString *decodeString;
    decodeString = [self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    decodeString = [self stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    decodeString = [self stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    decodeString = [self stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    decodeString = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @“<"
    // 上述操作是将后台返回的字符转译html字符
    // 这段代码是css布局，这里css与js互用的话不兼容会出现缩小情况最好单一使用
    decodeString = [NSString stringWithFormat:@"<html> \n"
              "<head> \n"
              "<style type=\"text/css\"> \n"
              "</style> \n"
              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">"
              
              "</head> \n"
              "<body>"
              "<script type='text/javascript'>"
              "window.onload = function(){\n"
              "var $img = document.getElementsByTagName('img');\n"
              "for(var p in  $img){\n"
              " $img[p].style.width = '100%%';\n"
              "$img[p].style.height ='auto'\n"
              "}\n"
              "}"
              "</script>%@"
              "</body>"
              "</html>",decodeString];
    
    return decodeString;
}
@end
