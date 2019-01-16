//
//  CODHistroyModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"
#import "CODDectateListModel.h"

@interface CODHistroyModel : CODBaseModel

@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,strong) NSArray <CODDectateListModel *> *browse;

@end
