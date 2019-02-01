//
//  CODDIYFourItemView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/24.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODDIYFourItemView.h"
#import "TWHImgTitleBtn.h"

@interface CODDIYFourItemView ()

@end

@implementation CODDIYFourItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *imfo_arr = @[
                              @{@"title":@"智能家具",@"icon":kGetImage(@"mall_categorize1")},
                              @{@"title":@"智能安防",@"icon":kGetImage(@"mall_categorize2")},
                              @{@"title":@"生活电器",@"icon":kGetImage(@"mall_categorize3")},
                              @{@"title":@"全部分类",@"icon":kGetImage(@"mall_categorize4")},
                              ];
        float item_width = frame.size.width / 4;
        for (NSInteger i = 0; i<imfo_arr.count; i++) {
            TWHImgTitleBtn *btn = [TWHImgTitleBtn buttonWithType:UIButtonTypeCustom];
            [btn setBtnStyle:TwhBtnStyleImageUp];
            [btn setSpace:10];
            [btn SetBtnTitle:imfo_arr[i][@"title"] andTitleColor:CODColor333333 andFont:kFont(14) andBgColor:nil andBgImg:nil andImg:imfo_arr[i][@"icon"] andClickEvent:@selector(functionBtnClicked:) andAddVC:self];
            [btn setTag:i+1];
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
        self.FunctionVWItemClickedBlock(btn.tag, btn.titleLabel.text);
    }
}

@end
