//
//  CODDIYFourItemView.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CODDIYFourItemView : UIView

@property (nonatomic, copy) void(^FunctionVWItemClickedBlock)(NSInteger idx,NSString *title);

@end
