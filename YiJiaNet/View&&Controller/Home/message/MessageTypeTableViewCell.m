//
//  MessageTypeTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "MessageTypeTableViewCell.h"

@interface MessageTypeTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;

@property (nonatomic, strong) UIBadgeView *badgeView;


@end

@implementation MessageTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = kFont(16);
            label;
        });
        [self.contentView addSubview:self.titleLable];
        
        self.detailLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = kFont(12);
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.contentView addSubview:self.detailLable];
        
        self.badgeView = ({
            UIBadgeView *view = [[UIBadgeView alloc] init];
            view;
        });
        [self.contentView addSubview:self.badgeView];

        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
        }];
        [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)configureWithModel:(NSDictionary *)model {
    self.titleLable.text = [model objectForKey:@"title"];
    self.iconImageView.image = kGetImage([model objectForKey:@"icon"]);
    self.detailLable.text = @"暂无数据";
}

+ (CGFloat)heightForRow {
    return 80;
}


- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
