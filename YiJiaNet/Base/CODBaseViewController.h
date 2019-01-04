//
//  CODBaseViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CODBaseViewController : UIViewController

- (void)cod_returnAction;// 返回动作
#pragma mark - Full view loading with blank
- (void)startLoadingWithBlock:(void (^)(void))block;
- (void)stopLoadingWithBlank:(BOOL)blank;

@end
