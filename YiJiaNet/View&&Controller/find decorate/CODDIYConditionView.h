//
//  CODDIYConditionView.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CODLayoutButton.h"

typedef NS_ENUM(NSInteger, DIYConditionType) {// 筛选类型
    ConditionTypeOne = 1,
    ConditionTypeTwo = 2,
    ConditionTypeThree = 3
};

@interface CODDIYConditionView : UIView

@property (nonatomic, assign) NSInteger type;// 筛选类型，1:全部分类，2：人气最高 ,3：品牌

/** 记录目前处于选中的按钮 */
@property (nonatomic,strong)NSMutableDictionary *recodeChoseDic;

@property(nonatomic, strong, readonly) CODLayoutButton *itmeBtnOne;
@property(nonatomic, strong, readonly) CODLayoutButton *itmeBtnThree;

@property(nonatomic,copy) void(^BtnSelectItemBlock)(DIYConditionType condition);

@end

