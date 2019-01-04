//
//  CODDecorateTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODDecorateTableViewCell.h"

@interface CODDecorateTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) CODImageLineView *corverImageView;

@end

@implementation CODDecorateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        
        self.backView = ({
            UIView *view = [[UIView alloc] init];
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        [self.contentView addSubview:self.backView];
        
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self.backView addSubview:self.iconImageView];
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:17];
            label;
        });
        [self.backView addSubview:self.nameLabel];
        
        self.distanceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.backView addSubview:self.distanceLabel];
        
        self.introLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
        [self.backView addSubview:self.introLabel];
        
        self.corverImageView = ({
            CODImageLineView *imageLineView = [[CODImageLineView alloc] init];
            imageLineView;
        });
        [self.backView addSubview:self.corverImageView];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.left.offset(10);
            make.top.equalTo(self.backView.mas_top).offset(10);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImageView);
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImageView);
            make.left.equalTo(self.nameLabel.mas_right).offset(10);
            make.right.equalTo(self.backView.mas_right).offset(-10);
            make.height.equalTo(@20);
        }];
        [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.height.equalTo(@20);
        }];
        [self.corverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.introLabel.mas_bottom).offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.height.equalTo(@100);
        }];
//
//        [self.priceLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal|UILayoutConstraintAxisVertical];
//        [self.priceLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal|UILayoutConstraintAxisVertical];
//        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.introLabel.mas_centerY);
//            make.left.equalTo(self.introLabel.mas_right).offset(10);
//            make.right.equalTo(self.corverImageView.mas_right);
//        }];
    }
    return self;
}

- (void)configureWithModel:(NSDictionary *)model {
//    [self.corverImageView sd_setImageWithURL:[NSURL URLWithString:[model objectForKey:@"icon"]] placeholderImage:kGetImage(@"place_zxal")];
    [self.iconImageView sd_setImageWithURL:nil placeholderImage:kGetImage(@"place_default_avatar")];
    self.nameLabel.text = @"雅丽豪庭金先生雅居";
    self.distanceLabel.text = @"￥15.2km";
    self.introLabel.text = @"案例：452 |  好评度：99%";
    
    self.corverImageView.images = @[kGetImage(@"place_zxal"), kGetImage(@"place_zxal"), kGetImage(@"place_zxal")];
}


+ (CGFloat)heightForRow {
    return 200;
}


@end
