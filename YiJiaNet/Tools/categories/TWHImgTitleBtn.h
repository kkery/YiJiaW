//
//  TWHImgTitleBtn.h
//  XTX
//
//  Created by 汤文洪 on 2017/5/5.
//  Copyright © 2017年 TWH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TwhBtnStyle){
    TwhBtnStyleImageLeft,
    TwhBtnStyleImageRight,
    TwhBtnStyleImageUp,
    TwhBtnStyleImageDown
};

@interface TWHImgTitleBtn : UIButton

/**样式*/
@property (nonatomic,assign)TwhBtnStyle BtnStyle;

/**图文间距*/
@property (nonatomic,assign)CGFloat Space;

@end
