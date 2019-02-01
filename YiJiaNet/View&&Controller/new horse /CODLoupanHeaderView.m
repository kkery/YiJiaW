//
//  CODLoupanHeaderView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/31.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODLoupanHeaderView.h"
@interface CODLoupanHeaderView ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CODLoupanHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [UILabel GetLabWithFont:kFont(16) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:nil];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.centerY.offset(10);
        }];
    }
    return self;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
