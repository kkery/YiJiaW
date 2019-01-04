//
//  CODImageLineView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODImageLineView.h"

@interface CODImageLineView ()

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *imageFrames;
@property (nonatomic, assign) CGFloat horizontalSpace;
@property (nonatomic, assign) CGFloat verticalSpace;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation CODImageLineView

- (void)configureInit {
    self.imageWidth = 0;
    self.imageHeight = 0;
    self.imageViews = [[NSMutableArray alloc] init];
    self.imageFrames = [[NSMutableArray alloc] init];
    self.horizontalSpace = 12;// 水平间距
    self.verticalSpace = 5;// 垂直间距
    self.contentSize = CGSizeZero;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutImageViews];
}

- (CGSize)intrinsicContentSize {
    return self.contentSize;
}

#pragma mark - Accessors
- (void)setDirection:(CODImageLineViewDirection)direction {
    _direction = direction;
    [self layoutIfNeeded];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    UIImage *image = [_images firstObject];
//    self.imageWidth = image.size.width;
//    self.imageHeight = image.size.height;
    // 写死图片宽高为80
    self.imageWidth = 100;
    self.imageHeight = 100;
    
    for (NSUInteger i = 0, count = self.imageViews.count; i < count; i++) {
        UIImageView *imageView = self.imageViews[i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    [self.imageFrames removeAllObjects];
    for (NSUInteger i = 0,count = _images.count; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.image = _images[i];
        // 添加点击
        imageView.userInteractionEnabled = YES;
        [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (self.singleTap) {
                self.singleTap(i);
            }
        }];
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        [self.imageFrames addObject:[NSValue valueWithCGRect:CGRectZero]];
    }
    [self layoutIfNeeded];
}

#pragma mark - Layout
- (void)layoutImageViews {
    NSInteger count = self.images.count;
    
    if (count == 0) {
        self.contentSize = CGSizeZero;
        [self invalidateIntrinsicContentSize];
        return;
    }
    
    CGFloat x=0;
    CGFloat y=0;
    for (NSUInteger i = 0,count = _images.count; i < count; i++) {
        if (self.direction == CODImageLineViewDirectionHorizontal) {
            x = i * self.imageWidth + i * self.horizontalSpace;
            y = 0;
        } else {
            x = i * self.imageWidth + i * self.horizontalSpace;
            y = i * self.imageHeight + i * self.horizontalSpace;
        }
        
        [self.imageFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:CGRectMake(x, y, self.imageWidth, self.imageHeight)]];
    }
    
    // layout image view
    for (NSUInteger i=0; i<count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.frame = [self.imageFrames[i] CGRectValue];
    }
    CGRect lastFrame = [[self.imageFrames lastObject] CGRectValue];
    self.contentSize = CGSizeMake(lastFrame.origin.x+self.imageWidth, self.imageHeight);
    [self invalidateIntrinsicContentSize];
}

@end
