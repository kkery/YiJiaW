//
//  CODSearchCollectionViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODSearchCollectionViewCell.h"

@implementation CODSearchCollectionViewCell

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
