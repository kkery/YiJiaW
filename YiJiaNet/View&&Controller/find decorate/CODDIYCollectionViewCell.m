//
//  CODDIYCollectionViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYCollectionViewCell.h"

@interface CODDIYCollectionViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;

@end


@implementation CODDIYCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds =YES;
        
        self.coverImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self.contentView addSubview:self.coverImageView];
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = CODColor333333;
            label.numberOfLines = 2;
            label;
        });
        [self.contentView addSubview:self.titleLabel];
        
        self.currentPriceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = CODHexColor(0xFB5B1C);
            label;
        });
        [self.contentView addSubview:self.currentPriceLabel];
        
        self.originalPriceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = CODColor999999;
            label;
        });
        [self.contentView addSubview:self.originalPriceLabel];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints {
    @weakify(self);
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(self.width));
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    [self.currentPriceLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.currentPriceLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@15);
        make.bottom.equalTo(self.currentPriceLabel.mas_bottom);
        make.left.equalTo(self.currentPriceLabel.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
}

- (void)setViewModel:(CODDIYModel *)viewModel {
    _viewModel = viewModel;
    
    self.coverImageView.backgroundColor = [UIColor lightGrayColor];
    if (viewModel.images.count > 0) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.images[0]] placeholderImage:nil];
    }
    self.titleLabel.text = viewModel.name;
    
    NSString *price = @"￥888.00";
    
    if ([price containsString:@"."]) {
        NSRange range = [price rangeOfString:@"."];
        NSString *floStr = [price substringFromIndex:range.location];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:price];
        [attrString setFont:kFont(13) range:[price rangeOfString:floStr]];
        self.currentPriceLabel.attributedText = attrString;
    } else {
        self.currentPriceLabel.text = price;
    }
    
    [self.originalPriceLabel setLabelMiddleLineWithLab:@"￥8888.00" andMiddleLineColor:CODColor999999];
         
}

@end
