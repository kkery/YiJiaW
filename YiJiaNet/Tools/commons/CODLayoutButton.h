//
//  CODLayoutButton.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

typedef NS_ENUM(NSInteger,CODLayoutBtnStyle){
    BtnStyleImageLeft = 0,
    BtnStyleImageRight,
    BtnStyleImageUp,
    BtnStyleImageDown
};

@interface CODLayoutButton : UIButton

/**样式*/
@property (nonatomic,assign) CODLayoutBtnStyle BtnStyle;

/**图文间距*/
@property (nonatomic,assign) CGFloat padding;

@end
