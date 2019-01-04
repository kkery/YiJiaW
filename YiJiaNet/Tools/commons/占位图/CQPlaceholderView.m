//
//  CQPlaceholderView.m
//  PenTW
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 CYH. All rights reserved.
//

#import "CQPlaceholderView.h"

@interface CQPlaceholderView ()

@end

@implementation CQPlaceholderView

#pragma mark - 构造方法
/**
 构造方法
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(CQPlaceholderViewType)type delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _type = type;
        _delegate = delegate;
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.backgroundColor = [UIColor whiteColor];
    
    //------- 图片在正中间 -------//
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.centerX-140*proportionW/2, 85*proportionH, 140*proportionW, 140*proportionH)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];

    
    //------- 说明label在图片下方 -------//
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?13:15];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?11:13];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    
    //------- 按钮在说明label下方 -------//
    self.reloadButton = [[UIButton alloc]init];
    self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE_5?13:15];
    [self.reloadButton setTitleColor:ThemeColor forState:UIControlStateNormal];
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.layer.cornerRadius = 20*proportionH;
    self.reloadButton.layer.borderColor = ThemeColor.CGColor;
    self.reloadButton.layer.borderWidth = .7;
    [self.reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //------- 根据type创建不同样式的UI -------//
    switch (_type) {
        case CQPlaceholderViewTypeNoNetwork: // 只有图片
        {
            [self addSubview:self.imageView];
        }
            break;
            
        case CQPlaceholderViewTypeNoOrder: // 只有文字
        {
            self.imageView.frame = CGRectMake(self.centerX-200*proportionW/2, 85*proportionH, 200*proportionW, 180*proportionH);
            [self addSubview:self.imageView];
            
            
            [self addSubview:self.descLabel];
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(SCREENWIDTH);
                make.centerX.equalTo(self);
                make.top.equalTo(self.imageView.mas_bottom).offset(20*proportionH);
            }];
            
            
            [self addSubview:self.subtitleLabel];
            [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(SCREENWIDTH);
                make.centerX.equalTo(self);
                make.top.equalTo(self.descLabel.mas_bottom).offset(10*proportionH);
            }];
            
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 图片文字
        {
            [self addSubview:self.imageView];
            [self addSubview:self.descLabel];
            
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(SCREENWIDTH);
                make.centerX.equalTo(self);
                make.top.equalTo(self.imageView.mas_bottom).offset(20*proportionH);
            }];
            
        }
            break;
            
        case CQPlaceholderViewTypeBeautifulGirl: // 图片文字按钮
        {
            [self addSubview:self.imageView];

            [self addSubview:self.descLabel];
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(SCREENWIDTH);
                make.centerX.equalTo(self);
                make.top.equalTo(self.imageView.mas_bottom).offset(20*proportionH);
            }];
            
            [self addSubview:self.reloadButton];
            [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(210*proportionW);
                make.height.offset(40*proportionH);
                make.centerX.equalTo(self);
                make.top.equalTo(self.descLabel.mas_bottom).offset(30*proportionH);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 重新加载按钮点击

- (void)reloadButtonClicked:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClick:)]) {
        [_delegate placeholderView:self reloadButtonDidClick:sender];
    }
}

@end
