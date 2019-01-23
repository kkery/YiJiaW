//
//  CODBaseWebViewController.m
//  GroupContact
//
//  Created by kuangkai on 2018/2/5.
//  Copyright © 2018年 baowei. All rights reserved.
//

#import "CODBaseWebViewController.h"
#import <WebKit/WebKit.h>

@interface CODBaseWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *fixedSpaceItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, strong) UIBarButtonItem *homeItem;

@end

@implementation CODBaseWebViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
    [self updateNavigationItems];
//    [self addLeftBarButtonItemsWithClose:NO];
    
    [self configureView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    self.webView = ({
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:Configuration];
        webView.opaque = NO;
        webView.multipleTouchEnabled = YES;
        webView.navigationDelegate = self;
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        webView;
    });
    [self.view addSubview:self.webView];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.progressView = ({
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.tintColor = CODColorTheme;
        progressView.trackTintColor = [UIColor whiteColor];
        progressView;
    });
    [self.view addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@2);
    }];
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

#pragma mark - WKNavigationDelegate

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    
//    self.title = self.webView.title;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

//请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 拦截可恶的广告  域名51zhanzhuang.cn ！！！
    if ([navigationAction.request.URL.absoluteString rangeOfString:@"51zhanzhuang"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    [self updateNavigationItems];
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark - WKWebView Progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0 animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Return action
-(void)updateNavigationItems{
    if (self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.fixedSpaceItem,self.closeItem];
    } else {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}

- (void)closeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBackAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

