//
//  HomeLeftRightView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "HomeLeftRightView.h"

@interface HomeLeftRightView()

@property(nonatomic,strong) UIImageView *leftImgVw;
@property(nonatomic,strong) UIImageView *RTopImgVw;
@property(nonatomic,strong) UIImageView *RBotomImgVw;

@end

@implementation HomeLeftRightView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        self.leftImgVw = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = kGetImage(@"home_activity1");
            imageView;
        });
        [self addSubview:self.leftImgVw];
        
        self.RTopImgVw = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = kGetImage(@"home_activity2");
            imageView;
        });
        [self addSubview:self.RTopImgVw];
        
        self.RBotomImgVw = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = kGetImage(@"home_activity3");
            imageView;
        });
        [self addSubview:self.RBotomImgVw];
        
        [self.leftImgVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.bottom.offset(0);
            make.width.mas_equalTo(@(SCREENWIDTH/2));
        }];
        
        [self.RTopImgVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImgVw.mas_right).offset(5);
            make.top.offset(0);
            make.right.offset(0);
            make.height.equalTo(@74);
        }];
        
        [self.RBotomImgVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImgVw.mas_right).offset(5);
            make.top.equalTo(self.RTopImgVw.mas_bottom).offset(5);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap1:)];
        self.leftImgVw.userInteractionEnabled = YES;
        [self.leftImgVw addGestureRecognizer:tapRecognize1];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap2:)];
        self.RTopImgVw.userInteractionEnabled = YES;
        [self.RTopImgVw addGestureRecognizer:tapRecognize2];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap3:)];
        self.RBotomImgVw.userInteractionEnabled = YES;
        [self.RBotomImgVw addGestureRecognizer:tapRecognize3];
        
        
    }return self;
}


#pragma UIGestureRecognizer Handles
-(void)handleTap1:(UITapGestureRecognizer *)recognizer
{
    if (self.SelectImgVwBack) {
        self.SelectImgVwBack(@"算报价");
    }
}
-(void)handleTap2:(UITapGestureRecognizer *)recognizer
{
    if (self.SelectImgVwBack) {
        self.SelectImgVwBack(@"效果图");
    }
}
-(void)handleTap3:(UITapGestureRecognizer *)recognizer
{
    if (self.SelectImgVwBack) {
        self.SelectImgVwBack(@"装修公司");
    }
}

@end
