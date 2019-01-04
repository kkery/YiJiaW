//
//  DecorateConditionView.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/3.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CODLayoutButton.h"

typedef NS_ENUM(NSInteger, ConditionType) {// 筛选类型
    ConditionTypeNormal = 1,
    ConditionTypePraise = 2,
    ConditionTypeDistance = 3
};

@interface DecorateConditionView : UIView

@property (nonatomic, assign) NSInteger type;// 筛选类型，1:综合，2：口碑 ,3：距离

/** 记录目前处于选中的按钮 */
@property (nonatomic,strong)NSMutableDictionary *recodeChoseDic;

@property(nonatomic, strong, readonly) CODLayoutButton *itmeBtnOne;

@property(nonatomic,copy) void(^BtnSelectItemBlock)(ConditionType condition);

@end
