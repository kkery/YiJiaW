//
//  GoodsDetailCommentGradeVW.h
//  WGC
//
//  Created by Tang on 2018/4/13.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailCommentGradeVW : UIView

/** 分类视图 */
@property (nonatomic, copy) NSArray *kinArr;

@property(nonatomic,strong) NSString *countStr;

/** 高度加载出来之后的高度 */
@property (nonatomic, copy) void(^ReloadHeightBlock)(void);
/** 点击iteam的选中回调 */
@property (nonatomic, copy) void(^SelectIteamBlock)(NSInteger indexCount);

@end



@interface GoodsDetailCommentGradeItem : UICollectionViewCell

/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 是否是选中样式 */
@property (nonatomic,assign) BOOL isSelectStyle;

@end
