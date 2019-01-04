//
//  DecorateFourItemView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/28.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "DecorateFourItemView.h"
#import "TWHImgTitleBtn.h"

@interface DecorateFourItemView ()

@end

@implementation DecorateFourItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *imfo_arr = @[
                              @{@"title":@"精装修",@"icon":kGetImage(@"decorate_categorize1")},
                              @{@"title":@"半包施工",@"icon":kGetImage(@"decorate_categorize2")},
                              @{@"title":@"自装采购",@"icon":kGetImage(@"decorate_categorize3")},
                              @{@"title":@"软装设计",@"icon":kGetImage(@"decorate_categorize4")},
                              ];
        float item_width = frame.size.width / 4;
        for (NSInteger i = 0; i<imfo_arr.count; i++) {
            TWHImgTitleBtn *btn = [TWHImgTitleBtn buttonWithType:UIButtonTypeCustom];
            [btn setBtnStyle:TwhBtnStyleImageUp];
            [btn setSpace:5];
            [btn SetBtnTitle:imfo_arr[i][@"title"] andTitleColor:CODColor333333 andFont:kFont(14) andBgColor:nil andBgImg:nil andImg:imfo_arr[i][@"icon"] andClickEvent:@selector(functionBtnClicked:) andAddVC:self];
            [btn setTag:700 + 1 + i];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(i * item_width);
                make.width.mas_equalTo(item_width);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
        
    }return self;
}


-(void)functionBtnClicked:(TWHImgTitleBtn *)btn{
    if (self.FunctionVWItemClickedBlock) {
        self.FunctionVWItemClickedBlock(btn.tag - 700 - 1, btn.titleLabel.text);
    }
}

@end
