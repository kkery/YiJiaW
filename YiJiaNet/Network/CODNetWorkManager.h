//
//  CODNetWorkManager.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CODNetWorkManager : NSObject

void save(id value,NSString *key);

id get(NSString *key);

//请求失败
typedef void(^NetWorkFailed)(NSError *error);
//请求成功
typedef void(^NetWorkSucess)(id object);

+(instancetype)shareManager;

//@property (nonatomic, strong) NSURLSessionDataTask *urlSessionDataTask;// 任务对象

-(void)AFRequestData:(NSString *)hexfApi andParameters:(NSMutableDictionary *)parameters Sucess:(NetWorkSucess)Sucess failed:(NetWorkFailed)failed;

-(void)AFPostData:(NSString *)hexfApi Parameters:(NSMutableDictionary *)params ImageDatas:(NSMutableDictionary *)imageDatas AndSucess:(NetWorkSucess)Sucess failed:(NetWorkFailed)failed;

@end
