//
//  MyCommentImfoMode.h
//  WGC
//
//  Created by Tang on 2018/4/8.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentImfoMode : NSObject

/** 评价id */
@property (nonatomic,copy) NSString *CommentImfoID;
/** 用户id */
@property (nonatomic,copy) NSString *uid;
/** 头像 */
@property (nonatomic,copy) NSString *avatar;
/** 昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 时间 */
@property (nonatomic,copy) NSString *add_time;
/** 星级 */
@property (nonatomic,copy) NSString *score;
/** 内容描述 */
@property (nonatomic,copy) NSString *content;
/** 图片 */
@property (nonatomic,copy) NSArray *images;


/**  */
@property (nonatomic,copy) NSString *comment_object;
/**  */
@property (nonatomic,copy) NSString *realname;
/**  */
@property (nonatomic,copy) NSString *from_uid;
/**  */
@property (nonatomic,copy) NSString *object_id;



/** 高度 */
@property (nonatomic,assign) CGFloat rowHeight;

@end
