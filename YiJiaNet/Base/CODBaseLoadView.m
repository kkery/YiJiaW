//
//  CODBaseLoadView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseLoadView.h"
#import "UILabel+COD.h"

static CGFloat const kVerticalSpace = 12;

@interface CODBaseLoadView ()

@property (nonatomic, strong) UIImageView *animateImageView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSTimer *delayShowTimer;

@end

@implementation CODBaseLoadView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.animateImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiazhen1"]];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.animationImages = @[[UIImage imageNamed:@"jiazhen1"], [UIImage imageNamed:@"jiazhen2"], [UIImage imageNamed:@"jiazhen3"]];
            imageView.animationDuration = 0.3;
            imageView;
        });
        [self addSubview:self.animateImageView];
        
        self.textLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor lightGrayColor];
            label.text = @"努力加载中...";
            label;
        });
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGSize imageSize = [UIImage imageNamed:@"jiazhen1"].size;
    CGSize textSize = [self.textLabel cod_sizeForText];
    CGPoint imageOrigin = CGPointMake((bounds.size.width - imageSize.width)*0.5, (bounds.size.height - imageSize.height - textSize.height - kVerticalSpace)*0.5);
    CGPoint textOrigin = CGPointMake((bounds.size.width - textSize.width)*0.5, imageOrigin.y + imageSize.height + kVerticalSpace);
    self.animateImageView.frame = (CGRect){.origin=imageOrigin, .size=imageSize};
    self.textLabel.frame = (CGRect){.origin=textOrigin, .size=textSize};
}

#pragma mark - Public methods
- (void)start {
    if (self.delayShowTime > 0) {
        self.animateImageView.alpha = 0;
        self.textLabel.alpha = 0;
        if ([self.delayShowTimer isValid]) {
            [self.delayShowTimer invalidate];
            self.delayShowTimer = nil;
        }
        self.delayShowTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayShowTime target:self selector:@selector(startAnimating) userInfo:nil repeats:NO];
    } else {
        [self startAnimating];
    }
}

- (void)stop {
    if (self.delayShowTime > 0) {
        if ([self.delayShowTimer isValid]) {
            [self.delayShowTimer invalidate];
            self.delayShowTimer = nil;
        }
        [self stopAnimating];
    } else {
        [self stopAnimating];
    }
}

- (BOOL)loading {
    return [self.animateImageView isAnimating];
}

#pragma mark - Private methods
- (void)startAnimating {
    if (self.delayShowTime > 0) {
        self.animateImageView.alpha = 1;
        self.textLabel.alpha = 1;
    }
    [self.animateImageView startAnimating];
}

- (void)stopAnimating {
    [self.animateImageView stopAnimating];
}

@end
