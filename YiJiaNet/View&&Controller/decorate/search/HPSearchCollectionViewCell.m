//
//  HPSearchCollectionViewCell.m
//  JinFengGou
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HPSearchCollectionViewCell.h"

@implementation HPSearchCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:CODColorBackground];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15*proportionH;
        
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = XFONT_SIZE(13);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = CODColor999999;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        
    }
    return self;
}


@end
