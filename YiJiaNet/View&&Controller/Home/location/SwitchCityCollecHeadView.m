//
//  SwitchCityCollecHeadView.m
//  JinFengGou
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SwitchCityCollecHeadView.h"

@implementation SwitchCityCollecHeadView

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab SetLabFont:XFONT_SIZE(14) andTitleColor:CODColor666666 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
    }return _titleLab;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(13*proportionW);
        }];
        
        
    }
    return self;
}

@end
