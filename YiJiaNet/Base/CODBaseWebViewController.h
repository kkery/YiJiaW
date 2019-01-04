//
//  CODBaseWebViewController.h
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseViewController.h"

@interface CODBaseWebViewController : CODBaseViewController

- (instancetype)initWithUrl:(NSURL *)url;
- (instancetype)initWithUrlString:(NSString *)urlString;

@property (nonatomic, strong) NSString *webTitleString;

- (void)configureView;
- (void)loadData;

@end
