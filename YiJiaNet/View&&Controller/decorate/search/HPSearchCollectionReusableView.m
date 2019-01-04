//
//  HPSearchCollectionReusableView.m
//  JinFengGou
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HPSearchCollectionReusableView.h"

@implementation HPSearchCollectionReusableView

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab SetLabFont:XFONT_SIZE(14) andTitleColor:[UIColor blackColor] andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
    }return _titleLab;
}

-(UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleBtn setImage:[UIImage imageNamed:@"address_address_delete"] forState:UIControlStateNormal];
        _deleBtn.hidden = YES;
    }return _deleBtn;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(5*proportionH);
            make.left.equalTo(self).offset(13*proportionW);
        }];
        
        
        [self addSubview:self.deleBtn];
        [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(50*proportionW);
            make.height.offset(30*proportionH);
            make.right.equalTo(self);
            make.centerY.equalTo(self.titleLab);
        }];
        
    }
    return self;
}


@end
