//
//  NSObject+Method.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "NSObject+Method.h"

@implementation NSObject (Method)

#pragma mark .处理空字典(判断是否为空)
+(NSMutableDictionary *)getValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:keyedValues];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [dic setObject:@"" forKey:key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            [self getValuesForKeysWithDictionary:obj];
        }else if ([obj isKindOfClass:[NSArray class]]){
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull Arrobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([Arrobj isKindOfClass:[NSDictionary class]]) {
                    [self getValuesForKeysWithDictionary:Arrobj];
                }
                
            }];
        }
    }];
    return dic;
}

#pragma mark - 快速生成属性
-(void)getpropertyFormDic:(NSDictionary *)dataDic{
    
    // 属性跟字典的key一一对应
    NSMutableString *codes = [NSMutableString string];
    // 遍历字典中所有key取出来
    [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // key:属性名
        NSString *code;
        if ([obj isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"/** %@ */ \n @property (nonatomic, copy) NSString *%@;",key,key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"/** %@ */ \n @property (nonatomic, assign) BOOL %@;",key,key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"/** %@ */ \n @property (nonatomic, assign) NSInteger %@;",key,key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            code = [NSString stringWithFormat:@"/** %@ */ \n @property (nonatomic, strong) NSArray *%@;",key,key];
            NSLog(@"----%@列表", key);
            for (NSDictionary *dict in obj) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [self getpropertyFormDic:dict];
                }
            }NSLog(@"----%@列表", key);
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            code = [NSString stringWithFormat:@"/** %@ */ \n @property (nonatomic, strong) NSDictionary *%@;",key,key];
            [self getpropertyFormDic:(NSDictionary *)obj];
        }
        [codes appendFormat:@"%@\n",code];
        
    }];
    NSLog(@"%@", codes);
}

#pragma mark -dictionary转json字符
+(NSString *)convertDictionaryToJsonData:(NSDictionary *)dict{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark -json字符转dictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark -NSArray转json字符
+ (NSString *)arrayToJSONString:(NSArray *)array{
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return jsonResult;
}


+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

+(UIViewController *)getPresentedViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}



@end

#pragma mark - NSString
@implementation NSString (CategoryMethods)

#pragma mark -判断类
//是否全为数字
- (BOOL)isAlphaNum {
    //    NSString *kAN = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *cs = [NSCharacterSet alphanumericCharacterSet];
    return [self rangeOfCharacterFromSet:cs].location != NSNotFound;
}

+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//是否为中文
- (BOOL)isChinese {
    for(int i=0; i< [self length];i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}
//邮箱
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//iOS判断一个字符串中是否都是数字
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

// 正则判断手机号码格式
+(BOOL)isMobileNumber:(NSString *)mobileNum {
    if (mobileNum.length < 1) {
        return NO;
    }else{
        /**
         废弃正则表达式
         
         ^1(3[0-9]|4[579]|5[0-35-9]|8[0-9]|7[0135678])\\d{8}$
         
         2018-05-15
         */
        
        //^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$
        NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|66|7[0135678]|8[0-9]|9[89])\\d{8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        return [regextestmobile evaluateWithObject:mobileNum];
    }
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
+ (BOOL)urlValidation:(NSString *)string{
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                              options:NSRegularExpressionCaseInsensitive
                                                                error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:match.range];
        if (substringForMatch) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark .验证密码格式
+(BOOL )ValidPassword:(NSString *)pwStr{
    NSString *passStr = @"^[a-zA-Z0-9_]{6,16}$";
    NSPredicate *pass = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",passStr];
    return [pass evaluateWithObject:pwStr];
}

#pragma mark -时间处理
#pragma mark .时间戳转换成日期
+(NSString *)getDateStringWithTimeInterval:(NSString *)timeInterval DataFormatterString:(NSString *)dataFormatterString{
    NSString *dateString;
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    
    dataFormatter.dateFormat = dataFormatterString;
    
    NSTimeInterval _interval=[timeInterval doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    dateString = [dataFormatter stringFromDate:date];
    
    return dateString;
}

+(double)getTimeIntervalWithDateString:(NSString *)dateString DataFormatterString:(NSString *)dataFormatterString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:dataFormatterString];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:dateString];
    //将日期转换成时间戳
    double timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] doubleValue];
    
    return timeSp;
    
}

+(NSString *)GetTimeIntervalWithDate:(NSDate *)date{
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeString ;
}

#pragma mark .string转date
+(NSDate*)getDateFromString:(NSString*)uiDate withFormateStr:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formatString];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

#pragma mark .获取星期几
+(NSString *)getNowWeekdayWithDate:(NSDate *)date
{
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps=[[NSDateComponents alloc]init];
    NSInteger unitFlags=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //    NSDate *now=[NSDate date];
    calendar.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    comps=[calendar components:unitFlags fromDate:date];
    NSInteger week=[comps weekday];
    NSString *strWeek=[[[NSString alloc]init] getweek:week];
    return strWeek;
}

-(NSString *)getweek:(NSInteger)week
{
    NSString *weekStr=nil;
    if (week==1) {
        weekStr=@"周日";
    }else if (week==2){
        weekStr=@"周一";
    }else if (week==3){
        weekStr=@"周二";
    }else if (week==4){
        weekStr=@"周三";
    }else if (week==5){
        weekStr=@"周四";
    }else if (week==6){
        weekStr=@"周五";
    }else if (week==7){
        weekStr=@"周六";
    }
    return weekStr;
}

#pragma mark .在一串字符串指定位置用*代替
/*
 (NSString*)telestr       电话号码:12344556667
 string                    string:123****6667
 NSMakeRange(3,4)          为加密的起始位置和几位数字
 */
+(NSString*)changeStr:(NSString*)teleStr WithStartpath:(NSInteger)StarPath WithCount:(NSInteger)Count
{
    NSString *string = [teleStr stringByReplacingOccurrencesOfString:[teleStr substringWithRange:NSMakeRange(StarPath,Count)] withString:@"*********"];
    return string;
}

#pragma mark .date转string
+(NSString *)GetDateStrStrinWithDate:(NSDate *)date andFormatStr:(NSString *)formatStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:date];
}



#pragma mark -工具类
//base64加密
-(NSString *)base64 {
    NSData *data = [NSData dataWithBytes:[self UTF8String] length:[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (NSString *)urlCode {
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL, kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

/**
 * 处理HTML字符串
 */
+(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return string;
}

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      最大显示宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end


@implementation UIImage (ImageMethod)

#pragma mark .缩放图片
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    
    UIImage *newimage;
    
    if (nil == image)
        
    {
        
        newimage = nil;
        
    } else {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}

#pragma mark .通过颜色获取图片
+ (UIImage *) getImageWithColor:(UIColor*)color andHeight:(CGSize )size
{
    CGRect r= CGRectMake(0.0f, 0.0f,size.width,size.height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)imageResizableNamed:(NSString *)name {
    
    UIImage * image = [UIImage imageNamed:name];
    CGFloat width = image.size.width * 0.5f;
    CGFloat height = image.size.height * 0.5f;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width)];
}

+ (UIImage *)imageWatermarkNamed:(NSString *)watermarkName named:(NSString *)name scale:(CGFloat)scale {
    
    UIImage * background = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(background.size, NO, 0.0f);
    [background drawInRect:CGRectMake(0, 0, background.size.width, background.size.height)];
    
    UIImage * watermark = [UIImage imageNamed:watermarkName];
    CGFloat watermarkW = watermark.size.width * scale;
    CGFloat watermarkH = watermark.size.height * scale;
    CGFloat watermarkX = background.size.width - watermarkW - 8;
    CGFloat watermarkY = background.size.height - watermarkH - 8;
    [watermark drawInRect:CGRectMake(watermarkX, watermarkY, watermarkW, watermarkH)];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageRoundNamed:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    UIImage * original = [UIImage imageNamed:name];
    CGFloat originalW = original.size.width + 2 * borderWidth;
    CGFloat originalH = original.size.height + 2 * borderWidth;
    CGSize originalSize = CGSizeMake(originalW, originalH);
    UIGraphicsBeginImageContextWithOptions(originalSize, NO, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext(); [borderColor set];
    CGFloat ex_radius = originalW * 0.5f;
    CGFloat centerX = ex_radius;
    CGFloat centerY = ex_radius;
    CGContextAddArc(context, centerX, centerY, ex_radius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat in_radius = ex_radius - borderWidth;
    CGContextAddArc(context, centerX, centerY, in_radius, 0, M_PI * 2, 0);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageCaptureWithView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIColor *)pixelColorAtLocation:(CGPoint)point {
    
    UIColor *color         = nil;
    CGImageRef inImage     = self.CGImage;
    CGContextRef contexRef = [self ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(contexRef, rect, inImage);
    
    unsigned char * data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        
        int offset = 4 * ((w * round(point.y))+round(point.x));
        int alpha  = data[offset];
        int red    = data[offset+1];
        int green  = data[offset+2];
        int blue   = data[offset+3];
        color      = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(contexRef);
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef)ARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    size_t          bitmapByteCount;
    size_t          bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease(colorSpace);
    
    return context;
}


@end


#define WHITE_HEX_COLOR @"c1c1c1"
#define RED_HEX_COLOR @"#ff4746"
#define YELLOW_HEX_COLOR @"ffff00"
#define GREEN_HEX_COLOR @"77d850"
#define SELECT_HEX_COLOR @"0f2439"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithSETPRICE:(NSString *)SETPRICE price:(NSString*)PRICE
{
    UIColor *color = [UIColor colorWithHexString:WHITE_HEX_COLOR];
    UIColor *red = [UIColor colorWithHexString:RED_HEX_COLOR];
    UIColor *green = [UIColor colorWithHexString:GREEN_HEX_COLOR];
    
    if ([PRICE isEqual:@"--"]||[PRICE isEqual:@"0"]) {
        return color;
    }
    
    if (PRICE.floatValue > SETPRICE.floatValue) {
        color = red;
    }
    else if (PRICE.floatValue < SETPRICE.floatValue)
    {
        color = green;
    }
    return color;
}

+ (UIColor *)colorWithRAISELOSE:(NSString *)RAISELOSE
{
    UIColor *color = [UIColor colorWithHexString:WHITE_HEX_COLOR];
    UIColor *red = [UIColor colorWithHexString:RED_HEX_COLOR];
    UIColor *green = [UIColor colorWithHexString:GREEN_HEX_COLOR];
    
    if ([RAISELOSE isEqual:@"--"]||[RAISELOSE isEqual:@"0"]) {
        return color;
    }
    if (RAISELOSE.floatValue > 0) {
        color = red;
    }
    else if (RAISELOSE.floatValue < 0)
    {
        color = green;
    }
    return color;
}

+ (UIColor *)colorWithHex:(long)hexColor {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation UIViewController(VCMethod)

#pragma mark -设置状态栏背景色
- (void)setStatusBarBackgroundColor:(UIColor *)color{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = color;
        
    }
}

#pragma mark -Alert弹窗
-(void)showAlertOnlyConfirmStyleWithTitle:(NSString *)tle Mesage:(NSString *)mesage Determine:(void(^)(id determine))determine{
    UIAlertController *alert=[UIAlertController  alertControllerWithTitle:tle message:mesage preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (determine) {
            determine(action);
        }
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)showAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andCancel:(void(^)(id cancel))canCel Determine:(void(^)(id determine))determine{
    UIAlertController *alert=[UIAlertController  alertControllerWithTitle:tle message:mesage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *CanCel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        canCel(action);
    }];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        determine(action);
    }];
    
    [CanCel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [action setValue:ThemeColor forKey:@"titleTextColor"];
    
    [alert addAction:CanCel];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)showSheetAlertWithTitle:(NSString *)tle andMesage:(NSString *)mesage andActions:(NSArray *)actions{
    UIAlertController *alert=[UIAlertController  alertControllerWithTitle:tle message:mesage preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [self presentViewController:alert animated:YES completion:^{}];
}


#pragma mark -网络异常视图
-(UIView *)netErrorNullVWWithFrame:(CGFloat )height Target:(id)target ClickEvent:(SEL)click{
    UIView *bgVW = [UIView getAViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, height == 0 ? KTabBarNavgationHeight - 64 : height) andBgColor:kLightGrayBgColor];
    
    UILabel *alert_lab = [UILabel GetLabWithFont:kFont(14) andTitleColor:[UIColor lightGrayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:@"加载出错"];
    [bgVW addSubview:alert_lab];
    [alert_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgVW.mas_centerX);
        make.bottom.equalTo(bgVW.mas_centerY).offset(-20);
    }];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:kGetImage(@"net_load_error")];
    [bgVW addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgVW.mas_centerX);
        make.bottom.equalTo(alert_lab.mas_top).offset(-13);
    }];
    
    UIButton *refreshBtn = [UIButton GetBtnWithTitleColor:[UIColor whiteColor] andFont:kFont(16) andBgColor:CODRgbColor(223, 187, 127) andBgImg:nil andImg:nil andClickEvent:click andAddVC:target andTitle:@"刷新"];
    [refreshBtn setLayWithCor:5.0 andLayerWidth:0 andLayerColor:nil];
    [bgVW addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgVW.mas_centerY);
        make.centerX.equalTo(bgVW.mas_centerX);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    return bgVW;
}

#pragma mark -空数据视图
- (UIView *)noneDataUIWithHeight:(CGFloat )height title:(NSString *)tle icon:(UIImage *)image
{
    UIView *bgVW = [UIView getAViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, height) andBgColor:kLightGrayBgColor];
    
    UILabel *alert_lab = [UILabel GetLabWithFont:kFont(14) andTitleColor:[UIColor lightGrayColor] andTextAligment:NSTextAlignmentCenter andBgColor:nil andlabTitle:tle];
    [bgVW addSubview:alert_lab];
    [alert_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgVW.mas_centerX);
        make.bottom.equalTo(bgVW.mas_centerY).offset(-20);
    }];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:image];
    [bgVW addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgVW.mas_centerX);
        make.bottom.equalTo(alert_lab.mas_top).offset(-15);
    }];
    
    return bgVW;
}

-(void)removeSelfFromNav
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [arr removeObject:self];
    self.navigationController.viewControllers = arr;
}

@end


