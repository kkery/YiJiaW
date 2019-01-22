//
//  ImageBrowserViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 跳转方式
 */
typedef NS_ENUM(NSUInteger,PhotoBroswerVCType) {
    
    //modal
    PhotoBroswerVCTypePush=0,
    
    //push
    PhotoBroswerVCTypeModal,
    
    //zoom
    PhotoBroswerVCTypeZoom,
};

@interface ImageBrowserViewController : UIViewController
/**
 *  显示图片
 */
+(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type index:(NSUInteger)index imagesBlock:(NSArray *(^)(void))imagesBlock;
@end
