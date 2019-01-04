//
//  UIButton+COD.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "UIButton+COD.h"

@implementation UIButton (COD)

- (void)cod_alignImageUpAndTitleDown {
    [self cod_alignImageUpAndTitleDownWithPadding:5];
}

- (void)cod_alignImageUpAndTitleDownWithPadding:(CGFloat)padding {
    CGSize imageSize = self.imageView.intrinsicContentSize;
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    // lower the text and push it left so it appears centered below the image
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-padding*0.5, 0);
    // raise the image and push it right so it appears centered above the text
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-padding*0.5, 0, 0, -titleSize.width);
}

- (void)cod_alignTitleLeftAndImageRight {
    [self cod_alignTitleLeftAndImageRightWithPadding:5];
}

- (void)cod_alignTitleLeftAndImageRightWithPadding:(CGFloat)padding {
    CGSize imageSize = self.imageView.intrinsicContentSize;
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, -padding*0.5, 0, -padding*0.5);
    // left
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width+padding*0.5);
    // right
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+padding*0.5, 0, -titleSize.width);
}

- (void)cod_alignTitleAndImageCenter {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.intrinsicContentSize.width, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

@end
