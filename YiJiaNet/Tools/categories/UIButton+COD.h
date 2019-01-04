//
//  UIButton+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (COD)

- (void)cod_alignImageUpAndTitleDown;
- (void)cod_alignImageUpAndTitleDownWithPadding:(CGFloat)padding;

- (void)cod_alignTitleLeftAndImageRight;
- (void)cod_alignTitleLeftAndImageRightWithPadding:(CGFloat)padding;

- (void)cod_alignTitleAndImageCenter;

@end
