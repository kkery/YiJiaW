//
//  GetMultipleImagesTableViewCell.h
//  PenTW
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 许得诺言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetMultipleImagesTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier superClass:(UIViewController *)parkClass;

@property(nonatomic,copy) void(^getImageNumBlock)(NSMutableArray* imgArr,CGFloat itemWith);
@property(nonatomic,copy) void(^deleteNetWorkImgIDBlock)(NSMutableArray *selectphotos,NSInteger tag);
@property(nonatomic,assign) NSInteger sectionIndex;
@property(nonatomic,strong) NSMutableArray* dataArr;

@end
