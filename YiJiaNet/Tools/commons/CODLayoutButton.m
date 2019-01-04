//
//  CODLayoutButton.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODLayoutButton.h"

@implementation CODLayoutButton

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.padding=5;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //设置自适应
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    switch (self.BtnStyle) {
        case BtnStyleImageUp:
            [self layoutSubviewsWithUPview:self.imageView DownView:self.titleLabel];
            break;
        case BtnStyleImageDown:
            [self layoutSubviewsWithUPview:self.titleLabel DownView:self.imageView];
            break;
        case BtnStyleImageLeft:
            [self layoutSubviewsWithLeftView:self.imageView RightView:self.titleLabel];
            
            break;
        case BtnStyleImageRight:
            [self layoutSubviewsWithLeftView:self.titleLabel RightView:self.imageView];
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviewsWithLeftView:(UIView *)LeftView RightView:(UIView *)RightView {
    CGRect LeftViewFrame = LeftView.frame;
    CGRect RightViewFrame = RightView.frame;
    CGFloat totalWidth = CGRectGetWidth(LeftViewFrame)+self.padding+CGRectGetWidth(RightViewFrame);
    LeftViewFrame.origin.x = (CGRectGetWidth(self.frame)-totalWidth)/2.0;
    LeftViewFrame.origin.y = (CGRectGetHeight(self.frame)-CGRectGetHeight(LeftViewFrame))/2.0;
    LeftView.frame = LeftViewFrame;
    RightViewFrame.origin.x = CGRectGetMaxX(LeftViewFrame)+self.padding;
    RightViewFrame.origin.y = (CGRectGetHeight(self.frame)-CGRectGetHeight(RightViewFrame))/2.0;
    RightView.frame = RightViewFrame;
}

-(void)layoutSubviewsWithUPview:(UIView *)Upview DownView:(UIView *)DownView
{
    CGRect upViewFrame = Upview.frame;
    CGRect downViewFrame = DownView.frame;
    CGFloat totalHeight = CGRectGetHeight(upViewFrame)+self.padding+CGRectGetHeight(downViewFrame);
    upViewFrame.origin.x = (CGRectGetWidth(self.frame)-CGRectGetWidth(upViewFrame))/2.0;
    upViewFrame.origin.y = (CGRectGetHeight(self.frame)-totalHeight)/2.0;
    Upview.frame = upViewFrame;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame)-CGRectGetWidth(downViewFrame))/2.0;
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame)+self.padding;
    DownView.frame = downViewFrame;
}

@end
