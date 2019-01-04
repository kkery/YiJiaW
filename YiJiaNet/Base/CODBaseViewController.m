//
//  CODBaseViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseViewController.h"
#import "CODBaseLoadView.h"
#import "CODBaseBlankView.h"
#import <objc/runtime.h>

static NSInteger const kLoadViewTag = 31541;
static NSInteger const kBlankViewTag = 31542;

@interface CODBaseViewController ()

@end

@implementation CODBaseViewController

- (void)dealloc {
	CODLogDebug();
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
	self.view.backgroundColor = CODColorBackground;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_app_return"] style:UIBarButtonItemStyleDone target:self action:@selector(cod_returnAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)cod_returnAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark - Loading
- (void)startLoadingWithBlock:(void (^)(void))block {
    objc_setAssociatedObject(self, @selector(block), nil, OBJC_ASSOCIATION_RETAIN);
    if (block) {
        objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_RETAIN);
    }
    [self stopLoadingWithBlank:NO];
    CODBaseLoadView *loadView = [[CODBaseLoadView alloc] init];
    loadView.tag = kLoadViewTag;
    loadView.delayShowTime = 0.3;
    [self.view addSubview:loadView];
    @weakify(self);
    [loadView mas_makeConstraints: ^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    [loadView start];
}

- (void)stopLoadingWithBlank:(BOOL)blank {
    [self blank:blank];
    CODBaseLoadView *loadView = (CODBaseLoadView *)[self.view viewWithTag:kLoadViewTag];
    [loadView stop];
    [loadView removeFromSuperview];
}

#pragma mark - Blank
- (void)blank:(BOOL)blank {
    if (blank) {
        CODBaseBlankView *blankView = [[CODBaseBlankView alloc] init];
        blankView.dataSource = (id<CODBaseBlankViewDataSource>)self;
        blankView.delegate = (id<CODBaseBlankViewDataDelegate>)self;
        blankView.tag = kBlankViewTag;
        [self.view addSubview:blankView];
        @weakify(self);
        [blankView mas_makeConstraints: ^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self.view);
        }];
        [blankView reloadBlankView];
    } else {
        CODBaseBlankView *blankView = (CODBaseBlankView *)[self.view viewWithTag:kBlankViewTag];
        blankView.dataSource = nil;
        blankView.delegate = nil;
        [blankView removeFromSuperview];
    }
}

#pragma mark - CODBaseBlankViewDataSource
- (NSAttributedString *)titleForBlankView:(CODBaseBlankView *)blankView {
    NSString *text = NSLocalizedString(@"load error prompt", nil);
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: [UIColor lightGrayColor] };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForBlankView:(CODBaseBlankView *)blankView {
    return [UIImage imageNamed:@"no_success_img"];
}

- (UIColor *)backgroundColorForBlankView:(CODBaseBlankView *)blankView {
    return [UIColor whiteColor];
}

#pragma mark - CODBaseBlankViewDataDelegate
- (BOOL)blankViewShouldAllowTouch:(CODBaseBlankView *)blankView {
    return YES;
}

- (void)blankViewDidTapView:(CODBaseBlankView *)blankView {
    void(^block)(void) = objc_getAssociatedObject(self, @selector(block));
    if (block) {
        block();
    }
}

@end
