//
//  CODModifyQuantityView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/21.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODModifyQuantityView.h"

static CGFloat const kButtonWidth = 22;
static CGFloat const kTextFieldWidth = 40;
static CGFloat const kHorizontalMargin = 8;

static CGFloat const kContentHeight = 30;
static CGFloat const kContentWidth = kButtonWidth+kHorizontalMargin+kTextFieldWidth+kHorizontalMargin+kButtonWidth;

CGFloat const CODModifyQuantityViewContentHeight = kContentHeight;
CGFloat const CODModifyQuantityViewContentWidth = kContentWidth;

static NSUInteger const kMinQuantity = 0;// 默认最小数量
static NSUInteger const kMaxQuantity = 100;// 默认最大数量
@interface CODModifyQuantityView () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UILabel *unitLable;

@end

@implementation CODModifyQuantityView

- (void)configureInit {
    
    self.quantity = MAX(kMinQuantity, self.quantity);
    self.maxQuantity = MAX(kMaxQuantity, self.maxQuantity);
    
    self.minusButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jian"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jian"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jian"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.inputTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = CODColor333333;
        textField.font = [UIFont systemFontOfSize:14];
        textField.keyboardType = UIKeyboardTypeNumberPad;
//        textField.layer.borderWidth = 1;
//        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.cornerRadius = 2.5;
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 32)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收起" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
        toolbar.items = @[flexibleSpace, flexibleSpace, doneButtonItem];
        textField.inputAccessoryView = toolbar;
        textField;
    });
    
    self.unitLable = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.unit;
        label.textColor = CODColor333333;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    
    self.plusButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jia"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jia"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"offer_jia"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self addSubview:self.minusButton];
    [self addSubview:self.inputTextField];
    [self addSubview:self.plusButton];
    [self addSubview:self.unitLable];

    [self configureConstraints];
    
    @weakify(self);
    [RACObserve(self, quantity) subscribeNext:^(id x) {
        @strongify(self);
        self.inputTextField.text = [NSString stringWithFormat:@"%@", x];
        if (self.quantityChangeBlock) {
            self.quantityChangeBlock([x unsignedIntegerValue]);
        }
    }];
    RAC(self.minusButton, enabled) = [RACSignal combineLatest:@[RACObserve(self, quantity)] reduce:^id(NSNumber *qunantity) {
        return @(qunantity.unsignedIntegerValue > 0);
    }];
}

- (void)configureConstraints {
    @weakify(self);
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(@(kButtonWidth));
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
    }];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.minusButton.mas_right).offset(kHorizontalMargin);
        make.width.equalTo(@40);
    }];
    [self.unitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.inputTextField.mas_right).offset(3);
    }];
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(@(kButtonWidth));
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.unitLable.mas_right).offset(5);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)resignKeyboard {
    [self.inputTextField resignFirstResponder];
}

- (instancetype)initWithFrame:(CGRect)frame Unit:(NSString *)unit {
    if (self = [super initWithFrame:frame]) {
        _unit = unit;
        [self configureInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kContentWidth, kContentHeight);
}

#pragma mark - Actions
- (void)minusAction {
    NSUInteger quantity = self.quantity;
    if (--quantity < kMinQuantity) {
        return;
    }
    self.quantity = quantity;
}

- (void)plusAction {
    NSUInteger quantity = self.quantity;
    if (++quantity > self.maxQuantity) {
        [self overMaxQuantityAlert];
        return;
    }
    self.quantity = quantity;
}

#pragma mark - Alert
- (void)overMaxQuantityAlert {
    NSString *message = [NSString stringWithFormat:@"超过最大限制，最多%@", @(self.maxQuantity)];
    [SVProgressHUD cod_showWithErrorInfo:message];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUInteger quantity = [textField.text integerValue];
    if (quantity < kMinQuantity) {
        quantity = kMinQuantity;
    }
    if (quantity > self.maxQuantity) {
        quantity = self.quantity;
    }
    self.quantity = quantity;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (range.length > 0 && textField.text.length == range.length) {// delete
//        self.quantity = kMinQuantity;
//        return NO;
//    }
    
    NSMutableString *futureText = [NSMutableString stringWithString:textField.text];
    [futureText insertString:string atIndex:range.location];
    NSUInteger futureQuantity = [futureText integerValue];
    
//    if (futureQuantity == 0) {
//        return NO;
//    }
    
    if (futureQuantity > self.maxQuantity) {
        [self overMaxQuantityAlert];
        return NO;
    }
    return YES;
}

@end
