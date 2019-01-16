//
//  CODDectateExampleModel.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseModel.h"

@interface CODDectateExampleModel : CODBaseModel
//"id": "4",
//"merchant_id": "99",
//"title": "测试案例",
//"img": "http://yijia.test/data/attachment/case/1812/24/181224145146_80.JPG",
//"house_areas": "绿地悦城",
//"decorate_fare": "5-8万",
//"merchants_logo": "http://yijia.test/data/attachment/merchant/1812/22/181222162537_53.jpg",
//"introduction": "100-150m2/三居/新中式 | 质鼎国际设计"

@property (nonatomic,assign) NSInteger examId;
@property (nonatomic,assign) NSInteger merchant_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *house_areas;
@property (nonatomic,copy) NSString *decorate_fare;
@property (nonatomic,copy) NSString *merchants_logo;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,assign) NSInteger imgs_num;

@end
