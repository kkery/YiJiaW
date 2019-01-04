//
//  CODNetWorkManager.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODNetWorkManager.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CODNetWorkManager

+(instancetype)shareManager
{
    static CODNetWorkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CODNetWorkManager alloc] init];
    });
    
    return manager;
}

#pragma mark-请求数据
-(void)AFRequestData:(NSString *)hexfApi andParameters:(NSMutableDictionary *)parameters Sucess:(NetWorkSucess)Sucess failed:(NetWorkFailed)failed
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",CODServerDomain,hexfApi]);
    [manager POST:[NSString stringWithFormat:@"%@%@",CODServerDomain,hexfApi] parameters:[self GetDic:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Sucess ? Sucess(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed ? failed(error) : nil;
    }];
}

#pragma mark-上传数据
-(void)AFPostData:(NSString *)hexfApi Parameters:(NSMutableDictionary *)params ImageDatas:(NSMutableDictionary *)imageDatas AndSucess:(NetWorkSucess)Sucess failed:(NetWorkFailed)failed {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manger POST:[NSString stringWithFormat:@"%@%@",CODServerDomain,hexfApi] parameters:[self GetDic:params] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *keyName in imageDatas) {
            
            UIImage *image = imageDatas[keyName];
            NSData *data=UIImageJPEGRepresentation(image, .3);
            [formData appendPartWithFileData:data name:keyName fileName:@"test.jpg" mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Sucess ? Sucess(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed ? failed(error) : nil;
    }];
}

#pragma mark- 转为字典
-(NSMutableDictionary *)GetDic:(NSMutableDictionary *)parameters {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    dic[@"appId"] = @"ios";
    dic[@"timestamp"] = [self GetCurrentTime];
    dic[@"version"] = @"1.0";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CODTokenParameterKey] length] != 0) {
        
        dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:CODTokenParameterKey];
    }
    
    dic[@"sign"] = [self Signature:dic];
    
    NSLog(@"%@",dic);
    
    return dic;
}

#pragma mark-签名
-(NSString *)Signature:(NSMutableDictionary *)dic
{
    NSLog(@"%@",[self retutnASCIIDic:dic]);
    NSLog(@"%@",[[self retutnASCIIDic:dic] componentsJoinedByString:@"&"]);
    return [self md5String:[NSString stringWithFormat:@"%@&%@",[[self retutnASCIIDic:dic] componentsJoinedByString:@"&"],@"appSecret= "]];
}

#pragma mark-根据ASCII码小到大排序
-(NSArray *)retutnASCIIDic:(NSMutableDictionary *)dic {
    NSStringCompareOptions comparisonOptions = NSLiteralSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0, obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *keyArray = [[dic allKeys] sortedArrayUsingComparator:sort];
    NSLog(@"%@",keyArray);
    NSMutableArray *mutable = [NSMutableArray array];
    [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [mutable addObject:[NSString stringWithFormat:@"%@=%@",obj,dic[obj]]];
        
    }];
    NSLog(@"%@",mutable);
    return mutable;
}

#pragma mark 获取当前时间戳
-(NSString *)GetCurrentTime {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString ;
}
#pragma mark-MD5加密
-(NSString *)md5String:(NSString *)str {
    NSLog(@"%@",str);
    //转换成UTF8
    const char * Cstr = [str UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    /*
     extern unsigned char * CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了md这个空间中
     */
    CC_MD5(Cstr, (CC_LONG)strlen(Cstr), md);
    //创建一个可变字符串收集结果
    NSMutableString * ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        /**
         15          X 表示以十六进制形式输入/输出
         16          02 表示不足两位，前面补0输出；出过两位不影响
         17          printf("%02X", 0x123); //打印出：123
         18          printf("%02X", 0x1); //打印出：01
         19          */
        [ret appendFormat:@"%02X",md[i]];
    }
    
    return [ret lowercaseStringWithLocale:[NSLocale currentLocale]];
}

@end
