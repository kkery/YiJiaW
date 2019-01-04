//
//  CODDecoExamCollectionViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODDecoExamCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat const kCoverImageViewHeight = 106;
static CGFloat const kVerticalMargin = 5;

@interface CODDecoExamCollectionViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *soldOutLabel;
@property (nonatomic, strong) UIView *rightLineView;

@end

@implementation CODDecoExamCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.coverImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 5;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView;
        });
        [self.contentView addSubview:self.coverImageView];
        
        self.shopNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = CODColor333333;
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        [self.contentView addSubview:self.shopNameLabel];
        
        self.typeNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = CODHexColor(0x777777);
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        [self.contentView addSubview:self.typeNameLabel];
        
        [self configureConstraints];
    }
    return self;
}

- (void)configureConstraints {
    @weakify(self);
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@(kCoverImageViewHeight));
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@20);
        make.top.equalTo(self.coverImageView.mas_bottom).offset(kVerticalMargin);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@20);
        make.top.equalTo(self.shopNameLabel.mas_bottom).offset(kVerticalMargin);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.offset(10);
        make.right.offset(-10);
    }];
}

- (void)configureWithModel:(NSDictionary *)model {
    self.shopNameLabel.text = model[@"title"];
    self.typeNameLabel.text = model[@"subTitle"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model[@"icon"]] placeholderImage:kGetImage(@"place_zxal")];
    
}

+ (CGSize)sizeForRow {
    return CGSizeMake(0, 180);
}

@end

