//
//  CODLoginViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseViewController.h"

@interface CODLoginViewController : CODBaseViewController

@property (nonatomic, copy) void(^loginBlock)(void);

@end
