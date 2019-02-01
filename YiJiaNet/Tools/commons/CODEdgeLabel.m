//
//  CODEdgeLabel.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODEdgeLabel.h"

@implementation CODEdgeLabel

@synthesize contentEdgeInsets = _contentEdgeInsets;

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    _topEdge = _contentEdgeInsets.top;
    _leftEdge = _contentEdgeInsets.left;
    _rightEdge = _contentEdgeInsets.right;
    _bottomEdge = _contentEdgeInsets.bottom;
    
    [self invalidateIntrinsicContentSize];
}
- (void)setTopEdge:(CGFloat)topEdge
{
    _topEdge = topEdge;
    [self invalidateIntrinsicContentSize];
}

- (void)setLeftEdge:(CGFloat)leftEdge
{
    _leftEdge = leftEdge;
    [self invalidateIntrinsicContentSize];
}

- (void)setBottomEdge:(CGFloat)bottomEdge
{
    _bottomEdge = bottomEdge;
    [self invalidateIntrinsicContentSize];
}

- (void)setRightEdge:(CGFloat)rightEdge
{
    _rightEdge = rightEdge;
    [self invalidateIntrinsicContentSize];
}

- (UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = UIEdgeInsetsMake(_topEdge, _leftEdge, _bottomEdge, _rightEdge);
    return _contentEdgeInsets;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.height += (_topEdge  + _bottomEdge);
    size.width  += (_leftEdge + _rightEdge);
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = [super sizeThatFits:size];
    newSize.height += (_topEdge  + _bottomEdge);
    newSize.width  += (_leftEdge + _rightEdge);
    return newSize;
}

-(void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(_topEdge, _leftEdge, _bottomEdge, _rightEdge))];
}

@end
