//
//  XWXImageVwIteam.h
//  HHShopping
//
//  Created by mac on 2017/11/20.
//  Copyright © 2017年 嘉瑞科技有限公司 - 许得诺言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWXImageVwIteam : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;

- (UIView *)snapshotView;

@end
