//
//  StarEvaluationView.h
//  JR-Businesses-CCN
//
//  Created by zluof on 16/9/27.
//  Copyright © 2016年 JR-LXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StarEvaluationView;
@interface StarEvaluationView : UIView


/*
 *@pramas  evaluateViewDidChooseStarBlock 点击评价之后回调的星星数量
 */
+ (instancetype)evaluationViewWithChooseStarBlock:(void(^)(StarEvaluationView *starview,NSUInteger count))evaluateViewChoosedStarBlock;


/*
 *@pramas  spacing 星星之间的间距
 ********  大小为：0～1，超过1则置为1
 ********  spacing = 0.1,则间隙为星星的宽度的0.1倍,默认为0.5(即不设置)
 */
@property (assign ,nonatomic) CGFloat spacing;

/*
 *@pramas  starCount 星星需要设置成的数量
 ********  大小为：1～5，超过5则置为5
 ********  默认不设置，如果输入值，则设置成需要的星星数
 */
@property (assign ,nonatomic) NSUInteger starCount;

/*
 *@pramas  tapEnabled 关闭星星点击手势，关闭就不能点击
 */
@property (assign ,nonatomic,getter=isTapEnabled) BOOL tapEnabled;


/**只展示几个*/
@property (nonatomic,assign)NSInteger OnlyShowCount;

/** 选中图片 */
@property (nonatomic, copy) UIImage *SelImg;
/** 空图片 */
@property (nonatomic, copy) UIImage *NorImg;

@end
