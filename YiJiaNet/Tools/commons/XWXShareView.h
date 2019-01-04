//
//  XWXShareView.h
//  HHShopping
//
//  Created by mac on 2017/11/15.
//  Copyright © 2017年 嘉瑞科技有限公司 - 许得诺言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWXShareView : UIView

@property(nonatomic,strong) NSDictionary* dic;
@property(nonatomic,strong) UIViewController* navSelf;

// 单例
+ (instancetype)shared;
// 类方法
+ (void)showShareView;

-(void)show;

@end
