//
//  GetImage.m
//  UUMATCH
//
//  Created by mac on 16/12/12.
//  Copyright © 2016年 weiyajiang. All rights reserved.
//

#import "GetImage.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

static GetImage *getImage = nil;

@interface GetImage()

@property (nonatomic, assign) BOOL isIcon;

@end

@implementation GetImage


//单例方法
+ (GetImage *)shareUploadImage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getImage = [[GetImage alloc] init];
    });
    return getImage;
}
//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<GetImageDelegate>)aDelegate
{
    getImage.uploadImageDelegate = aDelegate;
    _fatherViewController = fatherVC;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotos];
    }];
    
    [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    [photos setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [camera setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alert addAction:photos];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [fatherVC presentViewController:alert animated:YES completion:nil];
    
    
}
#pragma mark - 相机中选择
-(void)openCamera
{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 已经开启授权，可继续
            UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePC.allowsEditing = YES;
            imagePC.delegate = self;
            [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
        } else {
            [SVProgressHUD cod_showWithInfo:@"无法调用相机"];
        }
}

//图片库中查找图片
-(void)openPhotos
{
       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePC.delegate = self;
        imagePC.allowsEditing = YES;
        [_fatherViewController presentViewController:imagePC animated:YES completion:nil];
    } else {
        [SVProgressHUD cod_showWithInfo:@"暂无相册资源"];

    }
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(getImageToActionWithImage:)]) {
        [self.uploadImageDelegate getImageToActionWithImage:image];
    }
}

@end
