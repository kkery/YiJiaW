//
//  SwitchCityViewController.h
//  JinFengGou
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CODBaseTableViewController.h"

@interface SwitchCityViewController : CODBaseTableViewController

@property(nonatomic,copy) void (^SelectCity)(NSString *CityStr);

@end
