//
//  LocationCityCollectionViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/26.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "LocationCityCollectionViewCell.h"
#import "CODLayoutButton.h"
@implementation LocationCityCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.loacBtn = [CODLayoutButton buttonWithType:UIButtonTypeCustom];
        [_loacBtn SetBtnTitle:@"定位中" andTitleColor:[UIColor darkGrayColor] andFont:XFONT_SIZE(15) andBgColor:nil andBgImg:nil andImg:kGetImage(@"positioning_positioning") andClickEvent:nil andAddVC:nil];
        _loacBtn.padding = 5;
        _loacBtn.frame = CGRectMake(0, 0, 80, 40);
        _loacBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_loacBtn];
    }
    return self;
}
@end
