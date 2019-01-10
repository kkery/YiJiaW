//
//  CODHotDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/9.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODHotDetailViewController.h"
#import "NSString+COD.h"

@interface CODHotDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,copy) NSString *htmlUrl;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *timeLable;

@end

@implementation CODHotDetailViewController

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.backgroundColor = SepLineColor;
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.scrollView.bounces = NO;
        
    }return _webView;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.numberOfLines = 2;
        _titleLable.textColor = CODColor333333;
        _titleLable.font = kFont(20);
        
    }return _titleLable;
}
-(UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.textColor = CODColor666666;
        _timeLable.font = kFont(12);
    }return _timeLable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"头条详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.view addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(10);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(@20);
    }];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLable.mas_bottom).offset(25);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self loadData];
}

#pragma mark - Data
- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.hotId;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=index&a=head_line_detail" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            self.titleLable.text = object[@"data"][@"article"][@"title"];
            self.timeLable.text = object[@"data"][@"article"][@"add_time"];
            
            self.htmlUrl = object[@"data"][@"article"][@"info"];
            // 网页的加载(标签)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 延时操作
                [self.webView loadHTMLString:[self htmlEntityDecode:self.htmlUrl] baseURL:nil];
            });
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - 标签转为HTML网址
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @“<"
    // 上述操作是将后台返回的字符转译html字符
    // 这段代码是css布局，这里css与js互用的话不兼容会出现缩小情况最好单一使用
    string = [NSString stringWithFormat:@"<html> \n"
              "<head> \n"
              "<style type=\"text/css\"> \n"
              "</style> \n"
              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">"
              
              "</head> \n"
              "<body>"
              "<script type='text/javascript'>"
              "window.onload = function(){\n"
              "var $img = document.getElementsByTagName('img');\n"
              "for(var p in  $img){\n"
              " $img[p].style.width = '100%%';\n"
              "$img[p].style.height ='auto'\n"
              "}\n"
              "}"
              "</script>%@"
              "</body>"
              "</html>",string];
    
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
