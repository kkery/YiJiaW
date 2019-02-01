//
//  CODLouPanInfoViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODLouPanInfoViewCell.h"

@interface CODLouPanInfoViewCell ()

@property (nonatomic, strong) UILabel *loupanLabel;
@property (nonatomic, strong) UILabel *mainjiLabel;
@property (nonatomic, strong) UILabel *zhuangtaiLabel;
@property (nonatomic, strong) UILabel *kaipanLabel;
@property (nonatomic, strong) UILabel *jiaofangLabel;

@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation CODLouPanInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.loupanLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:17];
            label.text = @"楼盘信息";
            label;
        });
        [self.contentView addSubview:self.loupanLabel];
        
        self.mainjiLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.mainjiLabel];
        
        self.zhuangtaiLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.zhuangtaiLabel];
        
        self.kaipanLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.kaipanLabel];
        
        self.jiaofangLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:14];
            label;
        });
        [self.contentView addSubview:self.jiaofangLabel];
        
        self.moreButton = ({
            UIButton *button = [UIButton GetBtnWithTitleColor:CODHexColor(0x7396DF) andFont:kFont(12) andBgColor:CODHexColor(0xF2F2F2) andBgImg:nil andImg:nil andClickEvent:nil andAddVC:nil andTitle:@"更多信息"];
            button;
        });
        [self.contentView addSubview:self.moreButton];
        
        [self.loupanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.left.offset(12);
            make.height.equalTo(@20);
        }];
        [self.mainjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loupanLabel.mas_bottom).offset(20);
            make.left.offset(12);
            make.height.equalTo(@20);
        }];
        [self.zhuangtaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainjiLabel.mas_bottom).offset(10);
            make.left.offset(12);
            make.height.equalTo(@20);
        }];
        [self.kaipanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.zhuangtaiLabel.mas_bottom).offset(10);
            make.left.offset(12);
            make.height.equalTo(@20);
        }];
        [self.jiaofangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kaipanLabel.mas_bottom).offset(10);
            make.left.offset(12);
            make.height.equalTo(@20);
        }];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jiaofangLabel.mas_bottom).offset(20);
            make.left.offset(12);
            make.right.offset(-12);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

- (void)configureWithModel:(CODNewHorseModel *)model {
    self.mainjiLabel.text = kFORMAT(@"楼盘面积：%@", @"80-150平方");
    self.zhuangtaiLabel.text = kFORMAT(@"销售状态：%@", @"在售");
    self.kaipanLabel.text = kFORMAT(@"开盘时间：%@", @"2018-10-27");
    self.jiaofangLabel.text = kFORMAT(@"交房时间：%@", @"80-150平方");
}

+ (CGFloat)heightForRow {
    return 260;
}

@end
