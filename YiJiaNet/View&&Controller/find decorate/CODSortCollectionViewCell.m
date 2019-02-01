//
//  CODSortCollectionViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODSortCollectionViewCell.h"

@interface CODSortCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation CODSortCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = CODColor333333;
            label.textAlignment = 1;
            label;
        });
        [self.contentView addSubview:self.titleLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(70));
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
    }
    return self;
}

- (void)setSort:(NSDictionary *)sort {
    _sort = sort;
    self.iconImageView.image = [sort objectForKey:@"icon"];
    self.titleLabel.text = [sort objectForKey:@"title"];

}

@end
