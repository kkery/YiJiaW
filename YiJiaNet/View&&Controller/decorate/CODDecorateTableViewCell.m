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
            imageView.layer.cornerRadius = 18;
            imageView.layer.masksToBounds = YES;
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
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(10, 10, 0, 10));
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
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
    }
    return self;
}

- (void)configureWithModel:(CODDectateListModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:kGetImage(@"place_default_avatar")];
    self.nameLabel.text = model.name;
    self.distanceLabel.text = model.distance;
   
    self.introLabel.text = [NSString stringWithFormat:@"案例：%@  |  好评度：%@", model.case_number, model.score];
    if (model.images.count > 0) {
        self.corverImageView.hidden = NO;
        self.corverImageView.netImages = model.images;
    } else {
        self.corverImageView.hidden = YES;
    }
}

+ (CGFloat)heightForRow {
    return 200;
}

@end
