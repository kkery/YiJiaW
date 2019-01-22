//
//  SetNickNameViewController.m
//  JinFengGou
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SetNickNameViewController.h"

@interface SetNickNameViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField* nickNameTextFile;

@end

@implementation SetNickNameViewController

-(UITextField *)nickNameTextFile {
    if (!_nickNameTextFile) {
        _nickNameTextFile = [[UITextField alloc] init];
        [_nickNameTextFile SetTfTitle:nil andTitleColor:[UIColor blackColor] andFont:kFont(15) andTextAlignment:0 andPlaceHold:@"请输入昵称"];
        _nickNameTextFile.tintColor = ThemeColor;
//        _nickNameTextFile.text = self.nameString;
        _nickNameTextFile.clearButtonMode = UITextFieldViewModeAlways;
        _nickNameTextFile.delegate = self;
    }return _nickNameTextFile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"昵称";
    [self wr_setNavBarShadowImageHidden:NO];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nickNameTextFile];
    [self.nickNameTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(20);
    }];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = CODColorTheme;
    [self.view addSubview:linView];
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(self.nickNameTextFile.mas_bottom).offset(2);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    UIButton *confirmB = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonNormal] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonHighlighted] forState:UIControlStateHighlighted];
        [button SetLayWithCor:22 andLayerWidth:0 andLayerColor:0];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self confirmAction];
        }];
        button;
    });
    [self.view addSubview:confirmB];
    [confirmB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.top.equalTo(self.nickNameTextFile.mas_bottom).offset(50);
        make.left.offset(15);
        make.right.offset(-15);
    }];

    self.nickNameTextFile.text = self.titleStr;
    
}

-(void)confirmAction
{
    if (kStringIsEmpty(self.nickNameTextFile.text)) {
        [SVProgressHUD cod_showWithInfo:@"内容不能为空"];
        return;
    }
    if (self.doneBlock) {
        self.doneBlock(self.nickNameTextFile.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//限定尼称文字字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.nickNameTextFile) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    return YES;
}

@end
