//
//  CQPlaceholderView.m
//  PenTW
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 CYH. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 占位图的类型 */
typedef NS_ENUM(NSInteger, CQPlaceholderViewType) {
    /** 只有图片 */
    CQPlaceholderViewTypeNoNetwork = 1,
    /** 只有文字 */
    CQPlaceholderViewTypeNoOrder,
    /** 图片文字 */
    CQPlaceholderViewTypeNoGoods,
    /** 图片文字按钮 */
    CQPlaceholderViewTypeBeautifulGirl
};

#pragma mark - @protocol

@class CQPlaceholderView;

@protocol CQPlaceholderViewDelegate <NSObject>

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender;

@end

#pragma mark - @interface

@interface CQPlaceholderView : UIView

@property(nonatomic,strong) UIImageView* imageView;
@property(nonatomic,strong) UILabel* descLabel;
@property(nonatomic,strong) UILabel* subtitleLabel;
@property(nonatomic,strong) UIButton* reloadButton;

/** 占位图类型（只读） */
@property (nonatomic, assign, readonly) CQPlaceholderViewType type;
/** 占位图的代理方（只读） */
@property (nonatomic, weak, readonly) id <CQPlaceholderViewDelegate> delegate;

/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame
                         type:(CQPlaceholderViewType)type
                     delegate:(id)delegate;

@end
