//
//  CODInsetTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODInsetTableViewCell.h"
@interface CODInsetTableViewCell ()
@end

@implementation CODInsetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    static CGFloat verticalMargin = 15;
    static CGFloat horizontalMargin = 12;
    frame.origin.x = horizontalMargin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += verticalMargin;
    frame.size.height -= verticalMargin;
    [super setFrame:frame];
}

@end
