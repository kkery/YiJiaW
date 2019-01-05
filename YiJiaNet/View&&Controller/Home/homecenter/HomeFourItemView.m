//
//  HomeFourItemView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "HomeFourItemView.h"
#import "TWHImgTitleBtn.h"

@interface HomeFourItemView()

@end

@implementation HomeFourItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:frame];
        backImgView.image = kGetImage(@"home_categorize_bg");
        [self addSubview:backImgView];
        [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        NSArray *imfo_arr = @[
                              @{@"title":@"找装修",@"icon":kGetImage(@"home_categorize1")},
                              @{@"title":@"新房购",@"icon":kGetImage(@"home_categorize2")},
                              @{@"title":@"二手房",@"icon":kGetImage(@"home_categorize3")},
                              @{@"title":@"长租房",@"icon":kGetImage(@"home_categorize4")},
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
