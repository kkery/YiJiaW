//
//  CODHouseDetailIntroCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODHouseDetailIntroCell.h"
#import "CODEdgeLabel.h"
#import "TWHRichTextTool.h"
#import "UIButton+COD.h"
#import "UIImage+COD.h"
@interface CODHouseDetailIntroCell ()

@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, strong) UILabel *horseNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *addressIcon;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, strong) CODEdgeLabel *tagLabel1;
@property (nonatomic, strong) CODEdgeLabel *tagLabel2;
@property (nonatomic, strong) CODEdgeLabel *tagLabel3;
@property (nonatomic, strong) CODEdgeLabel *tagLabel4;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation CODHouseDetailIntroCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.zPosition = 1;//设置cell层级，配置遮挡属性，默认0
        self.clipsToBounds = NO;
        
        self.backImageView = ({
            UIView *imageView = [[UIView alloc] init];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 4;
            imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//阴影的颜色
            imageView.layer.shadowOpacity = 0.4f;//阴影的透明度
            imageView.layer.shadowRadius = 5.0f;//圆角
            imageView.layer.shadowOffset = CGSizeMake(0,-3);//偏移量
            imageView.userInteractionEnabled = YES;
            imageView;
        });
        [self.contentView addSubview:self.backImageView];
        
        self.horseNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = [UIFont systemFontOfSize:17];
            label;
        });
        [self.backImageView addSubview:self.horseNameLabel];
        
        self.tagLabel1 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.backImageView addSubview:self.tagLabel1];
        
        self.tagLabel2 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label;
        });
        [self.backImageView addSubview:self.tagLabel2];
        
        self.tagLabel3 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.backImageView addSubview:self.tagLabel3];
        
        self.tagLabel4 = ({
            CODEdgeLabel *label = [[CODEdgeLabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
            label.layer.cornerRadius = 1;
            label.clipsToBounds = YES;
            label;
        });
        [self.backImageView addSubview:self.tagLabel4];
        
        self.priceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODHexColor(0xFB5C1D);
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
        [self.backImageView addSubview:self.priceLabel];
        
        self.addressIcon = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"amount_location"];
            imageView;
        });
        [self.backImageView addSubview:self.addressIcon];
        
        self.addressLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor666666;
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
        [self.backImageView addSubview:self.addressLabel];
        
        self.addressBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitle:@"查看路线" forState:UIControlStateNormal];
            [button setTitleColor:CODHexColor(0x7496DF) forState:UIControlStateNormal];
            [button setImage:kGetImage(@"commodity_navigation_location")  forState:UIControlStateNormal];
            [button cod_alignImageUpAndTitleDown];
            button;
        });
        [self.backImageView addSubview:self.addressBtn];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-12);
            make.left.offset(12);
            make.right.offset(-12);
            make.height.equalTo(@180);
        }];
        [self.horseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.left.offset(13);
            make.height.equalTo(@20);
        }];
        [self.tagLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horseNameLabel.mas_bottom).offset(10);
            make.left.offset(13);
            make.height.equalTo(@20);
        }];
        [self.tagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel1.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@20);
        }];
        [self.tagLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel2.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@20);
        }];
        [self.tagLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel3.mas_right).offset(5);
            make.centerY.equalTo(self.tagLabel1.mas_centerY);
            make.height.equalTo(@20);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagLabel1.mas_bottom).offset(10);
            make.left.offset(13);
            make.height.equalTo(@20);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(40);
            make.left.offset(30);
            make.right.offset(-60);
            make.height.equalTo(@20);
        }];
        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(13);
            make.centerY.equalTo(self.addressLabel);
            make.size.mas_equalTo(CGSizeMake(10, 12));
        }];
        [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addressLabel);
            make.size.mas_equalTo(CGSizeMake(50, 60));
            make.right.offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = CODColorLine;
        [self.backImageView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(20);
            make.height.offset(1);
            make.left.offset(12);
            make.right.offset(-12);
        }];
    }
    return self;
}

- (void)configureWithModel:(CODNewHorseModel *)model {
    self.horseNameLabel.text = @"南昌恒大时代之光";
    self.addressLabel.text = @"南昌市青云谱区新地路景泰华产业园";
    
    self.priceLabel.text = @"均价约888元/㎡";
    
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
    return 180;
}


@end
