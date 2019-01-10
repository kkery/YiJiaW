//
//  CODCommentModel.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CODCommentModel : CODBaseModel

/** 评论id */
@property (nonatomic,copy) NSString *commentId;
/** 用户id */
@property (nonatomic,copy) NSString *uid;
/** 昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 评论用户头像 */
@property (nonatomic,copy) NSString *avatar;
/** 评论内容 */
@property (nonatomic,copy) NSString *content;
/** 评论时间 */
@property (nonatomic,copy) NSString *add_time;
/** 评分 */
@property (nonatomic,copy) NSString *score;
/** 是否有评论图片 */
@property (nonatomic,copy) NSString *has_img;
/** 图片总数 */
@property (nonatomic,copy) NSString *images_number;
/** 评论图片数组 */
@property (nonatomic,strong) NSArray *images;

@end
