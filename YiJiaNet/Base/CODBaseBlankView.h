//
//  CODBaseBlankView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CODBaseBlankViewDataSource;
@protocol CODBaseBlankViewDataDelegate;

@interface CODBaseBlankView : UIView

@property (nonatomic, weak) id<CODBaseBlankViewDataSource> dataSource;
@property (nonatomic, weak) id<CODBaseBlankViewDataDelegate> delegate;

- (void)reloadBlankView;

@end

@protocol CODBaseBlankViewDataSource <NSObject>
@optional

- (NSAttributedString *)titleForBlankView:(CODBaseBlankView *)blankView;
- (NSAttributedString *)descriptionForBlankView:(CODBaseBlankView *)blankView;
- (UIImage *)imageForBlankView:(CODBaseBlankView *)blankView;
- (NSAttributedString *)buttonTitleForBlankView:(CODBaseBlankView *)blankView forState:(UIControlState)state;
- (UIImage *)buttonBackgroundImageForBlankView:(CODBaseBlankView *)blankView forState:(UIControlState)state;
- (UIColor *)backgroundColorForBlankView:(CODBaseBlankView *)blankView;
- (UIView *)customViewForBlankView:(CODBaseBlankView *)blankView;
- (CGFloat)spaceHeightForBlankView:(CODBaseBlankView *)blankView;

@end

@protocol CODBaseBlankViewDataDelegate <NSObject>
@optional

- (BOOL)blankViewShouldDisplay:(CODBaseBlankView *)blankView;
- (BOOL)blankViewShouldAllowTouch:(CODBaseBlankView *)blankView;
- (void)blankViewDidTapView:(CODBaseBlankView *)blankView;
- (void)blankViewDidTapButton:(CODBaseBlankView *)blankView;
- (void)blankViewWillAppear:(CODBaseBlankView *)blankView;
- (void)blankViewWillDisappear:(CODBaseBlankView *)blankView;

@end
