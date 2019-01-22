//
//  ServicePathView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/17.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "ServicePathView.h"
@implementation ServicePathView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *imageArr = @[@"amount_process1", @"amount_process2", @"amount_process3", @"amount_process4"];
        NSArray *titArr = @[@"提交申请\n预约量房", @"提交申请\n预约量房", @"免费设计\n3分设计对比", @"方案沟通\n满意为止"];

        CGFloat padding = 25;
        CGFloat midPadding = (frame.size.width-50-24*4) / 3;
        CGFloat imgW = 24;
        CGFloat midPadding1 = ((frame.size.width-50-24*4) / 3 - 7)/2;

        for (NSInteger i = 0; i<imageArr.count; i++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.image = kGetImage(imageArr[i]);
            
            UILabel *titLab = [[UILabel alloc] init];
            titLab.font = kFont(12);
            titLab.textColor = CODColor666666;
            titLab.numberOfLines = 0;
            titLab.textAlignment = 1;
            titLab.text = titArr[i];
            
            [self addSubview:imageV];
            [self addSubview:titLab];

            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(i*imgW + i*midPadding + padding);
                make.width.mas_equalTo(imgW);
                make.height.mas_equalTo(imgW);
                make.top.equalTo(self.mas_top).offset(10);
            }];
            [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageV);
                make.top.equalTo(imageV.mas_bottom).offset(10);
            }];

            if (i < 3) {
                UIImageView *arrowImageV = [[UIImageView alloc] init];
                arrowImageV.image = kGetImage(@"my_arrow");// 7 12
                [self addSubview:arrowImageV];
                
                [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imageV.mas_right).offset(midPadding1);
                    make.width.mas_equalTo(7);
                    make.height.mas_equalTo(12);
                    make.centerY.offset(-3);
                }];
            }
        }
    }
    return self;
}
@end
