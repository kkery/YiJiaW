//
//  ConditionPopView.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/3.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionPopView : UIView


/**
 下拉弹窗初始化

 @param frame 弹窗大小
 @param vw 添加视图
 @return 弹窗
 */
-(instancetype)initWithFrame:(CGRect)frame supView:(UIView *)vw;


/**
 展示弹窗

 @param data 下拉弹窗选项数据
 @param key 用于存储选择事件
 */
-(void)showWithData:(NSArray *)data opitionKey:(NSString *)key;


/**
 关闭弹窗
 */
-(void)dismiss;

/** 勾选操作回调 */
@property (nonatomic, copy) void(^SelectBlock)(NSString *key,NSInteger idx,NSString *chooseTle);

/** 记录勾选下标 */
@property (nonatomic,strong)NSMutableDictionary *recodeIndexDic;

/** 是否是处于展示状态(外部仅可读) */
@property (nonatomic,assign,readonly) BOOL isShow;


@end
