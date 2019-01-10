//
//  CODExampleTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/25.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODExampleTableViewCell.h"

@interface CODExampleTableViewCell ()

@property (nonatomic, strong) UIImageView *corverImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation CODExampleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.selectionStyle = UITableViewCellAccessoryNone;
        
        self.corverImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:self.corverImageView];
        
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 20;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:17];
            label;
        });
        [self.contentView addSubview:self.nameLabel];
        
        self.introLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.introLabel];
        
        self.priceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODHexColor(0xFB5B1C);
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.contentView addSubview:self.priceLabel];
        
        [self.corverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.offset(12);
            make.right.offset(-12);
            make.height.equalTo(@180);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.corverImageView.mas_bottom).offset(-20);
            make.right.equalTo(self.corverImageView.mas_right).offset(-15);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.corverImageView.mas_bottom).offset(10);
            make.left.equalTo(self.corverImageView.mas_left);
            make.right.equalTo(self.corverImageView.mas_right);
            make.height.equalTo(@20);
        }];
        [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.corverImageView.mas_left);
//            make.right.equalTo(self.corverImageView.mas_right);
            make.height.equalTo(@20);
        }];
        [self.priceLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal|UILayoutConstraintAxisVertical];
        [self.priceLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal|UILayoutConstraintAxisVertical];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.introLabel.mas_centerY);
            make.left.equalTo(self.introLabel.mas_right).offset(10);
            make.right.equalTo(self.corverImageView.mas_right);
        }];
    }
    return self;
}

- (void)configureWithModel:(CODDectateExampleModel *)model {
    [self.corverImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kGetImage(@"place_zxal")];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.merchants_logo] placeholderImage:kGetImage(@"place_default_avatar")];
    self.nameLabel.text = model.house_areas;
    self.introLabel.text = model.introduction;
    self.priceLabel.text = model.decorate_fare;
}


+ (CGFloat)heightForRow {
    return 250;
}

@end
