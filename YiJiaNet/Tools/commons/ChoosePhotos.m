//
//  ChoosePhotos.m
//  Bee
//
//  Created by 汤文洪 on 2017/5/4.
//  Copyright © 2017年 JR.TWH. All rights reserved.
//

#import "ChoosePhotos.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

static ChoosePhotos *getImage = nil;

@interface ChoosePhotos()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UIViewController *_fatherViewController;
    BOOL _isSelectOriginalPhoto;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/** 选中的图片 */
@property (nonatomic,copy)NSMutableArray *selectedPhotos;
/** 选中的相册资源信息 */
@property (nonatomic, copy) NSMutableArray *selectedAssets;
/**最大张数*/
@property (nonatomic,assign)NSInteger MaxCount;

@end

@implementation ChoosePhotos

-(NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc]init];
    }return _selectedAssets;
}

-(NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc]init];
    }return _selectedPhotos;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


+(ChoosePhotos *)SharedChoseImg
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    getImage = [[ChoosePhotos alloc] init];
//    });
    return getImage;
}

- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<ChoosePhotosDelegate>)aDelegate andMaxCount:(NSInteger )count{
    
    getImage.ChoseImgdelegate = aDelegate;
//    if (aDelegate) {
//       self.ChoseImgdelegate = aDelegate;
//    }
    _fatherViewController = fatherVC;
    
    self.MaxCount = count;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self pushImagePickerController];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhoto];
    }];
    
    [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    [photos setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [camera setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    
    [fatherVC presentViewController:alert animated:YES completion:nil];
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertController *alert=[UIAlertController  alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *CanCel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:CanCel];
        [_fatherViewController presentViewController:alert animated:YES completion:nil];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [_fatherViewController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
    
}


//#pragma mark - 拍照（旧版本）
//- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([type isEqualToString:@"public.image"]) {
//        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//        tzImagePickerVc.sortAscendingByModificationDate = NO;
//        [tzImagePickerVc showProgressHUD];
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        // save photo and get asset / 保存图片，获取到asset
//
//        [[TZImageManager manager] savePhotoWithImage:image completion:^{
//            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
//                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
//                    [tzImagePickerVc hideProgressHUD];
//                    TZAssetModel *assetModel = [models firstObject];
//                    if (tzImagePickerVc.sortAscendingByModificationDate) {
//                        assetModel = [models lastObject];
//                    }
//                    [self.selectedAssets addObject:assetModel.asset];
//                    [self.selectedPhotos addObject:image];
//                    [self.ChoseImgdelegate getImage:self.selectedPhotos andAserts:self.selectedAssets];
//                }];
//            }];
//        }];
//    }
//}
#pragma mark - 拍照(2018-1-12 最新版本)
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        
        
        
        
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    [weakSelf.selectedAssets addObject:assetModel.asset];
                    [weakSelf.selectedPhotos addObject:image];
                    [weakSelf.ChoseImgdelegate getImage:weakSelf.selectedPhotos andAserts:weakSelf.selectedAssets];
                }];
            }];
            
        }];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 选择图片(改变相册的导航栏背景颜色)
- (void)pushImagePickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.MaxCount > 0 ? self.MaxCount : 1 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.showSelectBtn = YES;
    
    // 改变相册的导航栏背景颜色
//    imagePickerVc.navigationBar.barTintColor = [UIColor lightGrayColor]/* ThemeColor MYCOLOR(245, 90, 71)*/;
//    [imagePickerVc wr_setNavBarBarTintColor:ThemeColor];
    // WRNavigationBar 不会对 blackList 中的控制器有影响
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController"]];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        
        _fatherViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
    
    [_fatherViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark .TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [self.selectedPhotos removeAllObjects];
    [self.selectedPhotos addObjectsFromArray:photos];
    
    [self.selectedAssets removeAllObjects];
    [self.selectedAssets addObjectsFromArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.ChoseImgdelegate getImage:self.selectedPhotos andAserts:self.selectedAssets];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    [self.selectedPhotos removeAllObjects];
    [self.selectedPhotos addObject:coverImage];
    
    [self.selectedAssets removeAllObjects];
    [self.selectedAssets addObject:asset];
    
    [self.ChoseImgdelegate getImage:self.selectedPhotos andAserts:self.selectedAssets];
}

-(void)setExistSelectAserts:(NSMutableArray *)ExistSelectAserts{
    _ExistSelectAserts = ExistSelectAserts;
    [self.selectedAssets removeAllObjects];
    [self.selectedAssets addObjectsFromArray:ExistSelectAserts];
}

-(void)setExistSelectPhotos:(NSMutableArray *)ExistSelectPhotos{
    _ExistSelectPhotos = ExistSelectPhotos;
    [self.selectedPhotos removeAllObjects];
    [self.selectedPhotos addObjectsFromArray:ExistSelectPhotos];
}

@end

