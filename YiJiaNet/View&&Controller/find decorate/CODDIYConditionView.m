//
//  CODDIYConditionView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYConditionView.h"
#import "DecorateConditionView.h"

@interface CODDIYConditionView ()

@property(nonatomic,strong) CODLayoutButton *itmeBtnOne;
@property(nonatomic,strong) CODLayoutButton *itmeBtnTwo;
@property(nonatomic,strong) CODLayoutButton *itmeBtnThree;
@property(nonatomic,assign) BOOL isOn;

@end

@implementation CODDIYConditionView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatUI];
    }
    return self;
}

-(void)creatUI {
    self.itmeBtnOne = [CODLayoutButton buttonWithType:UIButtonTypeCustom];
    [self.itmeBtnOne setTitle:@"全部分类" forState:UIControlStateNormal];
    [self.itmeBtnOne setImage:kGetImage(@"mall_screening") forState:UIControlStateNormal];
    self.itmeBtnOne.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.itmeBtnOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.itmeBtnOne.selected = YES;
    [self.itmeBtnOne setTitleColor:CODColorTheme forState:UIControlStateSelected];
    self.itmeBtnOne.tag = 1;
    [self.itmeBtnOne addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.itmeBtnOne.BtnStyle = BtnStyleImageRight;
    
    [self addSubview:self.itmeBtnOne];
    [self.itmeBtnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.bottom.offset(0);
        make.width.offset(SCREENWIDTH/3);
    }];
    
    self.itmeBtnTwo = [CODLayoutButton buttonWithType:UIButtonTypeCustom];
    [self.itmeBtnTwo setTitle:@"人气最高" forState:UIControlStateNormal];
    self.itmeBtnTwo.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.itmeBtnTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.itmeBtnTwo.tag = 2;
    [self.itmeBtnTwo addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.itmeBtnTwo setTitleColor:CODColorTheme forState:UIControlStateSelected];
    [self addSubview:self.itmeBtnTwo];
    [self.itmeBtnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itmeBtnOne.mas_right);
        make.top.bottom.offset(0);
        make.width.offset(SCREENWIDTH/3);
    }];
    
    self.itmeBtnThree = [CODLayoutButton buttonWithType:UIButtonTypeCustom];
    [self.itmeBtnThree setTitle:@"品牌" forState:UIControlStateNormal];
    [self.itmeBtnThree setImage:kGetImage(@"mall_screening") forState:UIControlStateNormal];
    self.itmeBtnThree.titleLabel.font = [UIFont systemFontOfSize:15];
    self.itmeBtnThree.tag = 3;
    [self.itmeBtnThree addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.itmeBtnThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.itmeBtnThree setTitleColor:CODColorTheme forState:UIControlStateSelected];
    self.itmeBtnThree.BtnStyle = BtnStyleImageRight;
    [self addSubview:self.itmeBtnThree];
    [self.itmeBtnThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itmeBtnTwo.mas_right);
        make.width.offset(SCREENWIDTH/3);
        make.top.bottom.offset(0);
    }];
}

-(void)btnAction:(UIButton *)sender {
    if (sender.tag == 1) {
        self.itmeBtnOne.selected = YES;
        self.itmeBtnTwo.selected = NO;
        self.itmeBtnThree.selected = NO;
        self.type = ConditionTypeOne;
    } else if (sender.tag == 2) {
        self.itmeBtnOne.selected = NO;
        self.itmeBtnTwo.selected = YES;
        self.itmeBtnThree.selected = NO;
        self.type = ConditionTypeTwo;
    } else {
        self.itmeBtnOne.selected = NO;
        self.itmeBtnTwo.selected = NO;
        self.itmeBtnThree.selected = YES;
        self.type = ConditionTypeThree;
    }
    
    if (self.BtnSelectItemBlock) {
        self.BtnSelectItemBlock(self.type);
    }
}
@end
