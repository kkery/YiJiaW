//
//  PhotoView.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewDelegate <NSObject>

/**
 *  点击图片时，隐藏图片浏览器
 */
-(void)tapHiddenPhotoView;

@optional
-(void)SaveImageToNativeWithImg:(UIImage *)img;

@end

@interface CODBrowserPhotoView : UIView

/** 父视图 */
@property(nonatomic,strong)  UIScrollView *scrollView;

/** 图片视图 */
@property(nonatomic, strong) UIImageView *imageView;

/** 代理 */
@property(nonatomic, assign) id<PhotoViewDelegate> delegate;

/**
 *  传图片Url
 */
-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl;

/**
 *  传具体图片
 */
-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image;

@end
