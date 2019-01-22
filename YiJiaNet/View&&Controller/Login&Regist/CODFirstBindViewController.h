//
//  CODFirstBindViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/22.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseViewController.h"
#import <UMShare/UMShare.h>
NS_ASSUME_NONNULL_BEGIN
// 第三方授权第一次登录 需要绑定手机号再登录
@interface CODFirstBindViewController : CODBaseViewController

@property (nonatomic,strong) UMSocialUserInfoResponse *response;

@property (nonatomic,strong) UIViewController *popToVc;

@end

NS_ASSUME_NONNULL_END
