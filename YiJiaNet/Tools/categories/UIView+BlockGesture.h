//
//  UIView+UIView_BlockGesture.h
//  CustomFramework
//
//  Created by 胡俊杰 on 2017/4/28.
//  Copyright © 2017年 胡俊杰. All rights reserved.

#import <UIKit/UIKit.h>

/**
 block回调
 */
typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (BlockGesture)

/**
 点击手势回调
 */
- (void)addTapActionWithBlock:(GestureActionBlock)block;

/**
 长按手势回调
 */
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;


+(UIView *)addToolSenderWithTarget:(id)target Action:(SEL)sel;


@end
