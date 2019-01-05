//
//  CODAuthenViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/4.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODAuthenViewController.h"
#import "GetImage.h"
#import "NSString+COD.h"
@interface CODAuthenViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GetImageDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property(nonatomic,strong) UITextField *nameField;
@property(nonatomic,strong) UITextField *identifierField;
@property(nonatomic,strong) UITextField *telField;

@property(nonatomic,strong) UIImageView *positiveIDImageView;
@property(nonatomic,strong) UIImageView *reverseIDImageView;

@property(nonatomic,assign) NSInteger imageType;
//@property(nonatomic,assign) NSInteger imageType;
//@property(nonatomic,assign) NSInteger imageType;
@property(nonatomic,strong) NSMutableDictionary *ImgDic;

@property(nonatomic,strong) NSMutableArray *imgArr;

@property(nonatomic,strong) NSMutableDictionary *parmarDic;

@property (nonatomic, assign) BOOL edited;// 是否编辑过

@end

@implementation CODAuthenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:CODColorTheme];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont(15), NSFontAttributeName, nil] forState:0];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont(15), NSFontAttributeName, nil] forState:UIControlStateDisabled];
    
    self.parmarDic = [NSMutableDictionary dictionary];
    self.ImgDic = [NSMutableDictionary dictionary];
    self.imgArr = [NSMutableArray array];

    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = CODColorBackground;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//
//    RACSignal *imagValidSignal = [RACSignal combineLatest:@[RACObserve(self, imgArr)] reduce:^id(NSMutableArray *value) {
//        return @(value.count == 2);
//    }];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.nameField.rac_textSignal, self.identifierField.rac_textSignal, self.telField.rac_textSignal] reduce:^id (NSString *name, NSString *indentf, NSString *phone) {
        
        return @((name.length > 0) && (indentf.length > 0) && (phone.length > 0));
    }];
    
    RACSignal *editedSignal = [RACSignal combineLatest:@[self.nameField.rac_textSignal, self.identifierField.rac_textSignal, self.telField.rac_textSignal] reduce:^id (NSString *name, NSString *indentf, NSString *phone) {
        return @((name.length > 0) || (indentf.length > 0) || (phone.length > 0));
    }];
    RAC(self, edited) = editedSignal;

//
//
//    RACSignal *validSignal = [RACSignal combineLatest:@[RACObserve(self.viewModel, remainWordCount)] reduce:^id(NSNumber *remainWordCount) {
//        return @([remainWordCount integerValue] <= 0);
//    }];
//    RACSignal *textValidSignal = [RACSignal combineLatest:@[RACObserve(self.viewModel, content)] reduce:^id(NSString *content) {
//        return @(content.length > 0);
//    }];
//    RACSignal *executingSignal = RACObserve(self.viewModel, executing);
//    // 合并validSignal、textValidSignal、executingSignal
//    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[validSignal, textValidSignal, [executingSignal not]] reduce:^id(NSNumber *valid, NSNumber *executing){
//        return @([valid boolValue] && [executing boolValue]);
//    }];
    
    // rac
//    RACSignal *enabledSignal = [RACSignal combineLatest:@[RACObserve(self, name)] reduce:^id(NSString *text) {
//        return @(text.length > 0);
//    }];
//    
//    RAC(self.navigationItem.rightBarButtonItem, enabled) = enabledSignal;
    // data

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View
-(UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc]init];
        [_nameField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入真实姓名"];
        [_nameField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _nameField.textAlignment = 2;
        _nameField.tintColor = ThemeColor;
    }return _nameField;
}

-(UITextField *)identifierField {
    if (!_identifierField) {
        _identifierField = [[UITextField alloc]init];
        [_identifierField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入身份证号"];
        [_identifierField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _identifierField.tintColor = ThemeColor;
        _identifierField.delegate = self;
        _identifierField.textAlignment = 2;
    }return _identifierField;
}

-(UITextField *)telField {
    if (!_telField) {
        _telField = [[UITextField alloc]init];
        [_telField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入手机号码"];
        [_telField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _telField.keyboardType = UIKeyboardTypeNumberPad;
        _telField.tintColor = ThemeColor;
        _telField.delegate = self;
        _telField.textAlignment = 2;
    }return _telField;
}

-(UIImageView *)positiveIDImageView {
    if (!_positiveIDImageView) {
        _positiveIDImageView = [[UIImageView alloc] init];
        _positiveIDImageView.image = [UIImage imageNamed:@"apply_merchants_card_is"];
        _positiveIDImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_positiveIDImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            self.imageType = 1;
            [GETIMAGE showActionSheetInFatherViewController:self delegate:self];
        }];
    }return _positiveIDImageView;
}

-(UIImageView *)reverseIDImageView {
    if (!_reverseIDImageView) {
        _reverseIDImageView = [[UIImageView alloc] init];
        _reverseIDImageView.image = [UIImage imageNamed:@"apply_merchants_card_the"];
        _reverseIDImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_reverseIDImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            self.imageType = 2;
            [GETIMAGE showActionSheetInFatherViewController:self delegate:self];
        }];
    }return _reverseIDImageView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCellID = @"cellID";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBaseCellID];
        cell.backgroundColor = [UIColor whiteColor];
        kCellNoneSelct(cell);
        if (indexPath.section == 0) {
            cell.textLabel.font = XFONT_SIZE(14);
            cell.textLabel.textColor = CODColor333333;
            cell.textLabel.text = @[@"真实姓名", @"身份证号", @"手机号码"][indexPath.row];
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.nameField];
                [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(50);
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(100);
                    make.right.equalTo(cell.contentView).offset(-15);
                }];
                
            } else if(indexPath.row == 1) {
                [cell.contentView addSubview:self.identifierField];
                [self.identifierField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(50 );
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(100);
                    make.right.equalTo(cell.contentView).offset(-15);
                }];
                
            } else {
                [cell.contentView addSubview:self.telField];
                [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(50);
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(100);
                    make.right.equalTo(cell.contentView).offset(-15);
                }];
            }
        } else {
            [cell.contentView addSubview:self.positiveIDImageView];
            [self.positiveIDImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(257, 137));
                make.centerX.offset(0);
                make.top.offset(30);
            }];
            
            [cell.contentView addSubview:self.reverseIDImageView];
            [self.reverseIDImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(257, 137));
                make.centerX.offset(0);
                make.top.equalTo(self.positiveIDImageView.mas_bottom).offset(20);
            }];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 50 : SCREENHEIGHT-150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
//    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Action
- (void)commitAction {
    
    if (![self.identifierField.text cod_isIdCardNumber]) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入正确格式的身份证"];
        return;
    }
    if (![self.telField.text cod_isPhone]) {
        [SVProgressHUD cod_showWithErrorInfo:@"请输入正确格式的手机号"];
        return;
    }
    if (self.imgArr.count < 2) {
        [SVProgressHUD cod_showWithErrorInfo:@"请上传身份证正反面"];
        return;
    }
    
    self.parmarDic[@"realname"] = self.nameField.text;
    self.parmarDic[@"id_number"] = self.identifierField.text;
    self.parmarDic[@"mobile"] = self.telField.text;
    
    if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
        self.parmarDic[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
    }
//    [[HJNetWorkQuery shareManger] AfPostUrl:@"App,RiderTask,application" params:self.parmarDic Data:self.ImgDic completionHandle:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//            [self showSuccessText:@"提交申请成功"];
//            // 通知主类刷新
//            [kNotiCenter postNotificationName:@"MyMainVCNoti" object:nil userInfo:nil];
//            XWXRiderApplyTypeViewController *Vw = [XWXRiderApplyTypeViewController new];
//            Vw.infoDic = @{@"status":@"0"}.mutableCopy;
//            Vw.isTwoReturn = YES;
//            [self.navigationController pushViewController:Vw animated:YES];
//        } else {
//            [self showErrorText:result[@"message"]];
//        }
//    } errorHandle:^(NSError *error) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GetImageDelegate
-(void)getImageToActionWithImage:(UIImage *)image {
    if (self.imageType == 1) {
        [self.positiveIDImageView setImage:image];
        self.ImgDic[@"identity_card1"] = image;
        [self.imgArr addObject:image];
    } else {
        [self.reverseIDImageView setImage:image];
        self.ImgDic[@"identity_card2"] = image;
        [self.imgArr addObject:image];
    }
}

#pragma mark - Return
- (void)cod_returnAction {
    if (self.edited || self.imgArr.count > 0) {
        [self showAlertWithTitle:@"确定取消认证吗？" andMesage:nil andCancel:^(id cancel) {
        } Determine:^(id determine) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    [super cod_returnAction];
}

@end
