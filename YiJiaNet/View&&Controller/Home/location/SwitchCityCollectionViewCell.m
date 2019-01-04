//
//  SwitchCityCollectionViewCell.m
//  JinFengGou
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SwitchCityCollectionViewCell.h"

@implementation SwitchCityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self setBackgroundColor:CODColorBackground];
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 5;
//
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = XFONT_SIZE(15);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor darkGrayColor];
        
        [_nameLabel SetLabLayWithCor:5 andLayerWidth:0.5 andLayerColor:CODColorLine];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}


@end
