//
//  XHIntegralCollectionReusableView.h
//  JinFengGou
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectHeadViewItemProtocol <NSObject>

-(void)sendSelectItmeIndex:(NSInteger)index;

@end

@interface XHIntegralCollectionReusableView : UICollectionReusableView

@property(nonatomic,weak) id <SelectHeadViewItemProtocol> delegate;

@property(nonatomic,strong) NSDictionary *headerDic;

+ (CGFloat)heightForReusableView;

@end
