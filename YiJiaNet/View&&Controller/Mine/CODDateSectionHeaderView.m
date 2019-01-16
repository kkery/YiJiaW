//
//  CODDateSectionHeaderView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDateSectionHeaderView.h"
@interface CODDateSectionHeaderView ()

@property(nonatomic,strong) UILabel *dateLabel;

@end

@implementation CODDateSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor= CODColorBackground;
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.dateLabel.textColor = CODColor999999;
        [self addSubview:self.dateLabel];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-5);
        }];
    }
    return self;
    
}

- (void)setModel:(CODHistroyModel *)model {
    _model = model;
    
    self.dateLabel.text = model.add_time;
}

@end
