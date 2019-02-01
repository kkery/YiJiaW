//
//  XHIntegralCollectionReusableView.m
//  JinFengGou
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XHIntegralCollectionReusableView.h"

#import "SDCycleScrollView.h"
#import "CODDIYFourItemView.h"

static CGFloat const kFourItemHeight = 100;
static CGFloat const kBannerHeight = 150;
static CGFloat const kHotVWHeight = 60;

@interface XHIntegralCollectionReusableView () <SDCycleScrollViewDelegate>


// 头部轮播图+分类视图组件

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) CODDIYFourItemView *itemView;


@end


@implementation XHIntegralCollectionReusableView

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, kBannerHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"place_comper_detail"]];
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.currentPageDotImage = [UIImage cod_imageWithColor:[UIColor whiteColor] size:CGSizeMake(25, 3)];
        _bannerView.pageDotImage = [UIImage cod_imageWithColor:CODHexaColor(0xffffff, 0.3) size:CGSizeMake(25, 3)];
        _bannerView.localizationImageNamesGroup = @[@"icon_diybanner"];
    }
    return _bannerView;
}

- (CODDIYFourItemView *)itemView {
    if (!_itemView) {
        _itemView = [[CODDIYFourItemView alloc] initWithFrame:CGRectMake(0, kBannerHeight+10, SCREENWIDTH, kFourItemHeight)];
        [_itemView setFunctionVWItemClickedBlock:^(NSInteger idx, NSString *title) {
            if ([self.delegate respondsToSelector:@selector(sendSelectItmeIndex:)]) {
                [self.delegate sendSelectItmeIndex:idx];
            }
        }];
    }
    return _itemView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.bannerView];
        [self addSubview:self.itemView];

        UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.itemView.frame), SCREENWIDTH, kHotVWHeight)];
        hotView.backgroundColor = CODColorBackground;
        [self addSubview:hotView];

        UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 20)];
        [titleLab SetlabTitle:@"— 热门推荐 —" andFont:[UIFont fontWithName:@"Helvetica-Bold"size:16] andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentCenter andBgColor:nil];
        [hotView addSubview:titleLab];
    }
    return self;
}


- (void)setHeaderDic:(NSDictionary *)headerDic {
    _headerDic = headerDic;

}

+ (CGFloat)heightForReusableView {
    return kBannerHeight+kFourItemHeight+kHotVWHeight;
}

@end
