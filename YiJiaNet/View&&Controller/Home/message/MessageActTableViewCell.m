//
//  MessageActTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/21.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "MessageActTableViewCell.h"

@interface MessageActTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *actButton;

@end

@implementation MessageActTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        
        self.timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = 1;
            label;
        });
        [self.contentView addSubview:self.timeLabel];
        
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
            imageView.layer.cornerRadius = 3;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        [self.backView addSubview:self.iconImageView];
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
        [self.backView addSubview:self.titleLabel];
        
        self.subTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 2;
            label;
        });
        [self.backView addSubview:self.subTitleLabel];
        
        self.lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = CODColorLine;
            view;
        });
        [self.backView addSubview:self.lineView];
        
        self.actButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:CODColorTheme forState:UIControlStateNormal];
            [button setTitle:@"立即查看" forState:UIControlStateNormal];
            button;
        });
        [self.backView addSubview:self.actButton];
    
        // 布局
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.offset(0);
            make.height.equalTo(@15);
        }];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(0);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.left.offset(15);
            make.top.equalTo(self.backView.mas_top).offset(15);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView.mas_top).offset(20);
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.offset(-10);
            make.height.equalTo(@20);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.offset(-10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
            make.left.offset(10);
            make.right.offset(-10);
            make.height.equalTo(@1);
        }];
        [self.actButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
            make.centerX.offset(0);
        }];
    }
    return self;
}

- (void)configureWithModel:(CODMessageModel *)model {
    self.timeLabel.text = model.send_time;
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.data;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kGetImage(@"place_list")];
}

+ (CGFloat)heightForRow {
    return 185;
}

@end
