//
//  DecorateFourItemView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateFourItemView : UIView
@property (nonatomic, copy) void(^FunctionVWItemClickedBlock)(NSInteger idx,NSString *title);

@end
