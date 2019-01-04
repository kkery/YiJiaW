//
//  CODHotTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODHotTableViewCell.h"

@interface CODHotTableViewCell ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *corverImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CODHotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:15];
            label.numberOfLines = 2;
            label;
        });
        [self.contentView addSubview:self.titleLable];
        
        self.timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
        [self.contentView addSubview:self.timeLabel];
        
        self.corverImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView;
        });
        [self.contentView addSubview:self.corverImageView];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        [self.corverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 80));
            make.centerY.offset(0);
            make.left.equalTo(self.titleLable.mas_right).offset(10);
            make.right.offset(-10);
        }];
    }
    return self;
}

- (void)configureWithModel:(NSDictionary *)model {
    self.titleLable.text = @"南昌新增一张生态名片玲岗湿公园基本完工";
    self.timeLabel.text = @"2018-10-14";
    [self.corverImageView sd_setImageWithURL:nil placeholderImage:kGetImage(@"place_list")];
}


+ (CGFloat)heightForRow {
    return 110;
}

@end
