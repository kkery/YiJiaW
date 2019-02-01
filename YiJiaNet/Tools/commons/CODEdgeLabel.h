//
//  CODEdgeLabel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/30.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CODEdgeLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end
