//
//  GetImage.h
//  UUMATCH
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 weiyajiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//把单例方法定义为宏，使用起来更方便
#define GETIMAGE [GetImage shareUploadImage]

//代理
@protocol GetImageDelegate <NSObject>

@optional
//选取的图片上传到服务器
-(void)getImageToActionWithImage:(UIImage *)image;

@end



@interface GetImage : NSObject<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
{
   UIViewController *_fatherViewController;
}

@property (nonatomic, weak) id <GetImageDelegate> uploadImageDelegate;

//单例方法
+ (GetImage *)shareUploadImage;

//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate;


@end
