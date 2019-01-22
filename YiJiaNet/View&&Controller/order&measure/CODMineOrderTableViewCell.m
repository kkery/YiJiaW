//
//  CODMineOrderTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODMineOrderTableViewCell.h"

@interface CODMineOrderTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *adressImageView;
@property (nonatomic, strong) UILabel *adressLabel;

@end

@implementation CODMineOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = kGetImage(@"amount_appointment");
            imageView;
        });
        [self.contentView addSubview:self.iconImageView];
        
        self.timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.timeLabel];
        
        self.lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = CODColorLine;
            view;
        });
        [self.contentView addSubview:self.lineView];
        
        self.logoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 25;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:self.logoImageView];
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
        [self.contentView addSubview:self.nameLabel];
        
        self.adressImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = kGetImage(@"amount_location");
            imageView;
        });
        [self.contentView addSubview:self.adressImageView];
        
        self.adressLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
        [self.contentView addSubview:self.adressLabel];

        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 17));
            make.left.offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImageView);
            make.left.equalTo(self.iconImageView.mas_right).offset(15);
            make.height.equalTo(@17);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.offset(10);
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        [self.adressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 12));
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.centerY.equalTo(self.adressLabel);
        }];
        [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.adressImageView.mas_right).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)configureWithModel:(CODOrderModel *)model type:(NSString *)type {
    if ([type isEqualToString:@"预约"]) {
        self.iconImageView.image = kGetImage(@"amount_appointment");
        self.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@-%@", model.start_time, model.end_time];
    } else {
        self.iconImageView.image = kGetImage(@"my_amount");
        self.timeLabel.text = [NSString stringWithFormat:@"量房时间：%@-%@", model.start_time, model.end_time];
    }
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:kGetImage(@"place_default_avatar")];
    self.nameLabel.text = model.name;
    self.adressLabel.text = model.address;
}

+ (CGFloat)heightForRow {
    return 124+15;
}

@end
