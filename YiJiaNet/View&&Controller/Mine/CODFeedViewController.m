//
//  CODFeedViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/5.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODFeedViewController.h"
#import "CODTextView.h"

static CGFloat const kMaxLimit = 200;

@interface CODFeedViewController () <UITextViewDelegate>

/** 建议输入框*/
@property (nonatomic, strong) CODTextView *inputTextView;
@property (nonatomic, strong) UILabel *countLab;

@property (nonatomic, copy) NSString *content;

@end

@implementation CODFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"反馈内容";
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 225)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    UILabel *titlLabel = [UILabel GetLabWithFont:kFont(15) andTitleColor:CODColor333333 andTextAligment:0 andBgColor:nil andlabTitle:@"反馈内容"];
    titlLabel.frame = CGRectMake(10, 10, 100, 20);
    [bgView addSubview:titlLabel];

    UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 1)];
    linV.backgroundColor = CODColorLine;
    [bgView addSubview:linV];
    
    self.inputTextView = [[CODTextView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 150)];
    [self.inputTextView setPlaceholder:@"请输入遇到的问题或建议..."];
    [self.inputTextView setBackgroundColor:[UIColor whiteColor]];
    [self.inputTextView setDelegate:self];
    [self.inputTextView setFont:XFONT_SIZE(15)];
    [bgView addSubview:self.inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView);
        make.left.offset(15);
        make.top.equalTo(bgView).offset(45);
        make.bottom.equalTo(bgView).offset(-25);
    }];
    
    self.countLab = [UILabel GetLabWithFont:XFONT_SIZE(16) andTitleColor:[UIColor darkGrayColor] andTextAligment:2 andBgColor:nil andlabTitle:kFORMAT(@"0/%@",@(kMaxLimit))];
    [bgView addSubview:self.countLab];
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-5);
        make.right.equalTo(bgView).offset(-5);
    }];
    
    UIButton* LogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [LogoutBtn SetBtnTitleColor:[UIColor whiteColor] andFont:XFONT_SIZE(14) andBgColor:ThemeColor andBgImg:nil andImg:nil andClickEvent:@selector(exitAction) andAddVC:self andTitle:@"提交"];
    [LogoutBtn setLayWithCor:22.5 andLayerWidth:0 andLayerColor:nil];
    [self.view addSubview:LogoutBtn];
    [LogoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.view).offset(280);
    }];
}

-(void)exitAction {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
        params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
    }
    params[@"content"] = self.content;
//    [[HJNetWorkQuery shareManger] AFrequestData:@"App,Setting,option" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//
//            [self showSuccessText:@"反馈成功"];
//            [self NavAllBackClicked];
//        } else {
//            [self showErrorText:result[@"message"]];
//        }
//    } AndError:^(NSError *error) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
    [SVProgressHUD cod_showWithSuccessInfo:@"提交成功\n感谢您对益家网的信任与支持\n我们将尽快为您解决"];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > kMaxLimit)
    {
        textView.text = [textView.text substringToIndex:kMaxLimit];
    }
    self.countLab.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, @(kMaxLimit)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > kMaxLimit)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:kMaxLimit];
        
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:kMaxLimit];
            //防止粘贴时字数超限,不走textViewDidChange方法,重新计算字数
            self.countLab.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, @(kMaxLimit)];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxLimit)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;
}


@end
