//
//  CODBaseWebViewController.m
//  GroupContact
//
//  Created by kuangkai on 2018/2/5.
//  Copyright © 2018年 baowei. All rights reserved.
//

#import "CODBaseWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface CODBaseWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;
@property (nonatomic, strong) NJKWebViewProgress *webViewProgress;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *fixedSpaceItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, strong) UIBarButtonItem *homeItem;

@end

@implementation CODBaseWebViewController

- (void)dealloc {
    _webView.delegate = nil;
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    return [self initWithUrl:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.webTitleString ?: @"详情";
    
    [self addLeftBarButtonItemsWithClose:NO];
    
    [self configureView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webViewProgress reset];
    [super viewWillDisappear:animated];
}

#pragma mark - data
- (void)loadData {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
    NSLog(@"url = %@", self.url);
    [self.webView loadRequest:request];
}

#pragma mark - configure view
- (void)configureView {
    self.webViewProgress.webViewProxyDelegate = nil;
    self.webViewProgress.progressDelegate = nil;
    self.webView.delegate = nil;
    
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        webView.contentMode = UIViewContentModeScaleAspectFit;
        webView;
    });
    [self.view addSubview:self.webView];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.webViewProgress = ({
        NJKWebViewProgress *webViewProgress = [[NJKWebViewProgress alloc] init];
        webViewProgress.webViewProxyDelegate = self;
        webViewProgress.progressDelegate = self;
        webViewProgress;
    });
    self.webView.delegate = self.webViewProgress;
    
//    self.webViewProgressView = ({
//        NJKWebViewProgressView *webViewProgressView = [[NJKWebViewProgressView alloc] init];
//        webViewProgressView;
//    });
//    [self.view addSubview:self.webViewProgressView];
//
//    [self.webViewProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(@2);
//    }];
}

- (void)addLeftBarButtonItemsWithClose:(BOOL)close {
    if (close) {
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.fixedSpaceItem,self.closeItem];
    }
    else {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

#pragma mark - Accessors
- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImage:[UIImage imageNamed:@"nav_app_return"] forState:UIControlStateNormal];
            [button setTitle:@"返回" forState:UIControlStateNormal];
            button.titleLabel.font = kFont(15);
            [button setTitleColor:CODColor333333 forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
            [button sizeToFit];
            UIView *view = ({
                UIView *view = [[UIView alloc] initWithFrame:button.bounds];
                view;
            });
            [view addSubview:button];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
            item;
        });
    }
    return _backItem;
}

- (UIBarButtonItem *)fixedSpaceItem {
    if (!_fixedSpaceItem) {
        _fixedSpaceItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            item.width = 8;
            item;
        });
    }
    return _fixedSpaceItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = ({
            UIButton *button = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button setTitle:@"关闭" forState:UIControlStateNormal];
                button.titleLabel.font = kFont(15);
                [button setTitleColor:CODColor333333 forState:UIControlStateNormal];
                [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
                [button sizeToFit];
                button;
            });
            UIView *view = ({
                UIView *view = [[UIView alloc] initWithFrame:button.bounds];
                view;
            });
            [view addSubview:button];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
            item;
        });
    }
    return _closeItem;
}

#pragma mark - Return action
- (void)closeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBackAction {
    if ([self.webView canGoBack]) {
        [self addLeftBarButtonItemsWithClose:YES];
        [self.webView goBack];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//#pragma mark - NJKWebViewProgressDelegate
//- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
//    [self.webViewProgressView setProgress:progress animated:YES];
//}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"网页加载失败");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

@end

