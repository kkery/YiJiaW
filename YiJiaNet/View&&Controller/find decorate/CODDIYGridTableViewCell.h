//
//  CODDIYGridTableViewCell.h
//  YiJiaNet
//
//  Created by KUANG on 2019/1/25.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewCell.h"
#import "CODDIYModel.h"
@protocol CustomCollectionDelegate <NSObject>

- (void)CustomCollection:(UICollectionView *)collectionView didSelectCollectionItem:(NSInteger )itme;

@end

@interface CODDIYGridTableViewCell : CODBaseTableViewCell

@property (nonatomic, assign) id<CustomCollectionDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArray;

@end
