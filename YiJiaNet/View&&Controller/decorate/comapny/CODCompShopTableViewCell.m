//
//  CODCompShopTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODCompShopTableViewCell.h"

@interface CODCompShopTableViewCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *areaLabel;

@end

@implementation CODCompShopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *typeLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor666666 andTextAligment:0 andBgColor:nil andlabTitle:@"承接类型:"];
        [self.contentView addSubview:typeLab];
        [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(10);
            make.height.equalTo(@20);
            make.width.equalTo(@70);
        }];
        
        self.typeLabel = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"承接类型xxx"];
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(typeLab.mas_right).offset(10);
            make.centerY.equalTo(typeLab.mas_centerY);
            make.right.offset(-10);
        }];
        
        UILabel *priceLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor666666 andTextAligment:0 andBgColor:nil andlabTitle:@"承接价位:"];
        [self.contentView addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.equalTo(typeLab.mas_bottom).offset(15);
            make.height.equalTo(@20);
            make.width.equalTo(@70);
        }];
        
        self.priceLabel = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"承接价位xxx"];
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLab.mas_right).offset(10);
            make.centerY.equalTo(priceLab.mas_centerY);
            make.right.offset(-10);
        }];
        
        UILabel *areaLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor666666 andTextAligment:0 andBgColor:nil andlabTitle:@"服务区域:"];
        [self.contentView addSubview:areaLab];
        [areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.equalTo(priceLab.mas_bottom).offset(15);
            make.height.equalTo(@20);
            make.width.equalTo(@70);
        }];
        
        self.areaLabel = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"服务区域xxx"];
        self.areaLabel.numberOfLines = 0;
        [self.contentView addSubview:self.areaLabel];
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(areaLab.mas_right).offset(10);
            make.top.equalTo(priceLab.mas_bottom).offset(15);
            make.right.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
         
    return self;
}

#pragma mark - setter
-(void)setInfoMod:(CODCompanyDetailModel *)infoMod {
    _infoMod = infoMod;
    
    NSString *nullStr = @"暂无信息";
    self.typeLabel.text = kStringIsEmpty(infoMod.accept_type) ? nullStr : infoMod.accept_type;
    self.priceLabel.text = kStringIsEmpty(infoMod.accept_price) ? nullStr : infoMod.accept_type;
    self.areaLabel.text = kStringIsEmpty(infoMod.service_area) ? nullStr : infoMod.accept_type;
    CGSize textSize = kGetTextSize(self.areaLabel.text, SCREENWIDTH-100, MAXFLOAT, 14);
    
    infoMod.shopRowHeight = 100 + textSize.height;
}

@end
