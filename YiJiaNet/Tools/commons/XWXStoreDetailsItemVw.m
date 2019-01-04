//
//  XWXStoreDetailsItemVw.m
//  BaiYeMallShop
//
//  Created by XWXMac on 2018/8/14.
//  Copyright © 2018年 许得诺言. All rights reserved.
//

#import "XWXStoreDetailsItemVw.h"

@interface XWXStoreDetailsItemVw()

@end

@implementation XWXStoreDetailsItemVw

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUI];
        self.size = CGSizeMake(SCREENWIDTH, 45);
    }return self;
}


#pragma mark - UI Event
-(void)setUI
{
    NSArray *tleArr = @[@"分类",@"销量",@"价格"];
    for (NSInteger i = 0; i<tleArr.count; i++) {
        TWHImgTitleBtn *btn = [TWHImgTitleBtn buttonWithType:UIButtonTypeCustom];
        [btn setSpace:1];
        [btn setBtnStyle:TwhBtnStyleImageRight];
        if (i==2) {
            [btn SetBtnTitleColor:CODColor666666 andFont:XFONT_SIZE(15) andBgColor:nil andBgImg:nil andImg:kGetImage(@"boult_gray") andClickEvent:@selector(btnClicked:) andAddVC:self andTitle:tleArr[i]];
            [btn SetBtnSelectBgImg:nil andSelTitleColor:ThemeColor andSelImg:nil andSelTitle:nil];
        } else if (i==0) {
            [btn SetBtnTitleColor:CODColor666666 andFont:XFONT_SIZE(15) andBgColor:nil andBgImg:nil andImg:kGetImage(@"down_numl") andClickEvent:@selector(btnClicked:) andAddVC:self andTitle:tleArr[i]];
            [btn SetBtnSelectBgImg:nil andSelTitleColor:ThemeColor andSelImg:nil andSelTitle:nil];
        } else {
            [btn SetBtnTitleColor:CODColor666666 andFont:XFONT_SIZE(15) andBgColor:nil andBgImg:nil andImg:nil andClickEvent:@selector(btnClicked:) andAddVC:self andTitle:tleArr[i]];
            [btn SetBtnSelectBgImg:nil andSelTitleColor:ThemeColor andSelImg:nil andSelTitle:nil];
        }
        
        [btn setTag:700 + 1 + i];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(i * (SCREENWIDTH/3));
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(SCREENWIDTH/3);
        }];
        [self.btnArr addObject:btn];
        // 默认第一个选中
        //        if (i == 0) {
        //            btn.selected = YES;
        //            self.recodeChoseDic[@"select"] = btn;
        //        }
        
    }
    UIView *lineVW = [UIView getAViewWithFrame:CGRectZero andBgColor:SepLineColor];
    [self addSubview:lineVW];
    [lineVW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(.8);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - Click Event
-(void)btnClicked:(TWHImgTitleBtn *)btn
{
    NSInteger true_index = btn.tag - 700 - 1;
    //    if (true_index == 1 || true_index == 2) {
    [((TWHImgTitleBtn *)(self.btnArr[true_index])) setSelected:YES];
    if ([[self.recodeChoseDic allKeys] containsObject:@"select"] && ![((TWHImgTitleBtn *)(self.recodeChoseDic[@"select"])) isEqual:self.btnArr[true_index]]) {
        // 这里是控制点击过时，再点其它的按钮时，之前点的按钮的状态还是原来的状态（为YES时），反之在点击一个按钮后再点击另一个按钮的时候，之前的按钮的状态变了（为NO时）
        [((TWHImgTitleBtn *)(self.recodeChoseDic[@"select"])) setSelected:YES];
    }
    self.recodeChoseDic[@"select"] = ((TWHImgTitleBtn *)(self.btnArr[true_index]));
    //    }
    
    if (self.BtnClickBlock) {
        self.BtnClickBlock(true_index, self.key_imfo_arr[true_index],btn,self.btnArr);
    }
}


#pragma mark - getter
-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc]init];
    }return _btnArr;
}

-(NSMutableDictionary *)recodeChoseDic{
    if (!_recodeChoseDic) {
        _recodeChoseDic = [[NSMutableDictionary alloc]init];
    }return _recodeChoseDic;
}

-(NSArray *)key_imfo_arr
{
    if (!_key_imfo_arr) {
        _key_imfo_arr = @[@"分类",@"销量",@"价格"];
    }return _key_imfo_arr;
}


@end
