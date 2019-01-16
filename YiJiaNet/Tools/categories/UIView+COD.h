//
//  UIView+COD.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/15.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBadgeView.h"

typedef NS_ENUM(NSInteger, BadgePositionType) {
    
    BadgePositionTypeDefault = 0,
    BadgePositionTypeMiddle
};
@interface UIView (COD)

- (UIViewController *)findViewController;

- (void)addBadgeTip:(NSString *)badgeValue withCenterPosition:(CGPoint)center;
- (void)addBadgeTip:(NSString *)badgeValue;
- (void)addBadgePoint:(NSInteger)pointRadius withPosition:(BadgePositionType)type;
- (void)addBadgePoint:(NSInteger)pointRadius withPointPosition:(CGPoint)point;
- (void)removeBadgePoint;
- (void)removeBadgeTips;
- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setOrigin:(CGPoint)origin;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setSize:(CGSize)size;
- (CGFloat)maxXOfFrame;

@end
