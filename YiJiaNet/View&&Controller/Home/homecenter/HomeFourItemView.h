//
//  HomeFourItemView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>
// 首页四个itme
@interface HomeFourItemView : UIView
@property (nonatomic, copy) void(^FunctionVWItemClickedBlock)(NSInteger idx,NSString *title);

@end
