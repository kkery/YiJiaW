//
//  CODNewHorseTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/25.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODNewHorseTableViewCell.h"
#import "CODEdgeLabel.h"
#import "TWHRichTextTool.h"

@interface CODNewHorseTableViewCell ()

@property (nonatomic, strong) UIImageView *corverImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *horseNameLabel;
@property (nonatomic, strong) UILabel *addressLabel1;
@property (nonatomic, strong) UILabel *addressLabel2;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) CODEdgeLabel *tagLabel1;
@property (nonatomic, strong) CODEdgeLabel *tagLabel2;
@property (nonatomic, strong) CODEdgeLabel *tagLabel3;
@property (nonatomic, strong) CODEdgeLabel *tagLabel4;


@property (nonatomic, strong) UIView *lineView;

@end

@implementation CODNewHorseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.corverImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 4;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView;
        });
        [self.contentView addSubview:self.corverImageView];
        
        self.playButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"icon_paly"] forState:UIControlStateNormal];
            button;
        });
        [self.corverImageView addSubview:self.playButton];
        
        self.horseNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
        [self.contentView addSubview:self.horseNameLabel];
        
        self.addressLabel1 = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
        [self.contentView addSubview:self.addressLabel1];
        
        self.priceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODHexColor(0xFB5C1D);
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
        [self.contentView addSubview:self.priceLabel];
        
        self.tagLabel1 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:10];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.contentView addSubview:self.tagLabel1];
        
        self.tagLabel2 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:10];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label;
        });
        [self.contentView addSubview:self.tagLabel2];
        
        self.tagLabel3 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:10];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.contentView addSubview:self.tagLabel3];
        
        self.tagLabel4 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:10];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.contentView addSubview:self.tagLabel4];
        
        [self.corverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.centerY.offset(0);
            make.left.offset(10);
        }];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.center.equalTo(self.corverImageView);
        }];
        [self.horseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.left.equalTo(self.corverImageView.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        [self.addressLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horseNameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.corverImageView.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLabel1.mas_bottom).offset(10);
            make.left.equalTo(self.corverImageView.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
            make.left.equalTo(self.corverImageView.mas_right).offset(10);
            make.height.equalTo(@17);
        }];
        [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel1.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@17);
        }];
        [self.tagLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel2.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@17);
        }];
        [self.tagLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel3.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@17);
        }];
        
    }
    return self;
}

- (void)configureWithModel:(CODNewHorseModel *)model {
    [self.corverImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kGetImage(@"place_list")];
    self.horseNameLabel.text = @"南昌恒大时代之光";
    NSString *totalString = @"高新开区  |  经济技术开发区  |  建面113-144㎡";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalString];
    [attrString setColor:CODColor999999 range:[totalString rangeOfString:@"|"]];
    self.addressLabel1.attributedText = attrString;

    self.priceLabel.text = @"888元/㎡";
    
    self.tagLabel1.text = @"住宅";
    self.tagLabel1.textColor = CODHexColor(0x00A0E9);
    self.tagLabel1.backgroundColor = CODHexColor(0xF4FCFF);
    
    self.tagLabel2.text = @"在售";
    self.tagLabel2.textColor = CODHexColor(0x40BE55);
    self.tagLabel2.backgroundColor = CODHexColor(0xECFFEF);
    
    self.tagLabel3.text = @"三室两厅";
    self.tagLabel3.textColor = CODHexColor(0x666666);
    self.tagLabel3.backgroundColor = CODHexColor(0xF5F5F5);
    
    self.tagLabel4.text = @"毛坯";
    self.tagLabel4.textColor = CODHexColor(0x666666);
    self.tagLabel4.backgroundColor = CODHexColor(0xF5F5F5);
}

+ (CGFloat)heightForRow {
    return 130;
}

@end
