//
//  XWXStoreDetailsItemVw.h
//  BaiYeMallShop
//
//  Created by XWXMac on 2018/8/14.
//  Copyright © 2018年 许得诺言. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWHImgTitleBtn.h"

@interface XWXStoreDetailsItemVw : UIView

/** 当前按钮数组 */
@property (nonatomic,strong)NSMutableArray *btnArr;
/** 记录目前处于选中的按钮 */
@property (nonatomic,strong)NSMutableDictionary *recodeChoseDic;
/** 按钮点击回调 */
@property (nonatomic, copy) void(^BtnClickBlock)(NSInteger idx,NSString *key,TWHImgTitleBtn *btn,NSMutableArray *btnArr);
/** 存储选择 */
@property (nonatomic, copy) NSArray *key_imfo_arr;

@end
