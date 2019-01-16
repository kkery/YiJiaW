//
//  ChoosePhotos.h
//  Bee
//
//  Created by 汤文洪 on 2017/5/4.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ChoosePhotosDelegate <NSObject>

@optional
//获取选取的图片
-(void)getImage:(NSMutableArray *)images andAserts:(NSMutableArray *)aserts;

@end

@interface ChoosePhotos : NSObject

/**代理*/
@property (nonatomic,weak)id<ChoosePhotosDelegate>ChoseImgdelegate;

+(ChoosePhotos *)SharedChoseImg;

- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<ChoosePhotosDelegate>)aDelegate andMaxCount:(NSInteger )count;

/** 已存在图片 */
@property (nonatomic, copy)NSMutableArray *ExistSelectPhotos;
/** 已存在相册资源 */
@property (nonatomic, copy)NSMutableArray *ExistSelectAserts;


@end
