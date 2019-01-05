//
//  CODSetPwdViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/4.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODSetPwdViewController.h"

@interface CODSetPwdViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property(nonatomic,strong) UITextField *pwdField;
@property(nonatomic,strong) UITextField *confirmPwdField;

@property(nonatomic,strong) UITextField *oldField;
@property(nonatomic,strong) UITextField *newPwdField;
@property(nonatomic,strong) UITextField *confirmNewPwdField;

@end

@implementation CODSetPwdViewController

-(UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        [_pwdField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请设置6-18位登录密码"];
        [_pwdField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _pwdField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdField.tintColor = ThemeColor;
    }return _pwdField;
}

-(UITextField *)confirmPwdField {
    if (!_confirmPwdField) {
        _confirmPwdField = [[UITextField alloc] init];
        [_confirmPwdField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请确认密码"];
        [_confirmPwdField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _confirmPwdField.keyboardType = UIKeyboardTypeNumberPad;
        _confirmPwdField.tintColor = ThemeColor;
    }return _confirmPwdField;
}

-(UITextField *)oldField {
    if (!_oldField) {
        _oldField = [[UITextField alloc] init];
        [_oldField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请输入旧手机号码"];
        [_oldField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _oldField.keyboardType = UIKeyboardTypeNumberPad;
        _oldField.tintColor = ThemeColor;
    }return _oldField;
}

-(UITextField *)newPwdField {
    if (!_newPwdField) {
        _newPwdField = [[UITextField alloc] init];
        [_newPwdField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请设置6-18位新登录密码"];
        [_newPwdField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _newPwdField.keyboardType = UIKeyboardTypeNumberPad;
        _newPwdField.tintColor = ThemeColor;
    }return _newPwdField;
}

-(UITextField *)confirmNewPwdField {
    if (!_confirmNewPwdField) {
        _confirmNewPwdField = [[UITextField alloc] init];
        [_confirmNewPwdField SetTfTitle:nil andTitleColor:CODColor333333 andFont:XFONT_SIZE(14) andTextAlignment:NSTextAlignmentLeft andPlaceHold:@"请确认新登录密码"];
        [_confirmNewPwdField modifyPlaceholdFont:XFONT_SIZE(13) andColor:CODColor999999];
        _confirmNewPwdField.keyboardType = UIKeyboardTypeNumberPad;
        _confirmNewPwdField.tintColor = ThemeColor;
    }return _confirmNewPwdField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self wr_setNavBarShadowImageHidden:NO];
    if (self.status == 2) {
        self.title = @"修改登录密码";
    } else {
        self.title = @"设置登录密码";
    }
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = CODColorBackground;
        UIView *tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
            view;
        });
        UIButton *confirmB = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20, 30, SCREENWIDTH-40, 50);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonNormal] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonHighlighted] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonDisabled] forState:UIControlStateDisabled];
            [button SetLayWithCor:20 andLayerWidth:0 andLayerColor:0];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self confirmAction];
            }];
            button;
        });
        [tableFooterView addSubview:confirmB];
        tableView.tableFooterView = tableFooterView;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.status == 2) ? 3 : 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCellID = @"cellID";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBaseCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = XFONT_SIZE(15);
        cell.textLabel.textColor = CODColor333333;
    }
    if (self.status == 2) {
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.oldField];
            [self.oldField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(100);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
            
        } else if(indexPath.row == 1) {
            [cell.contentView addSubview:self.newPwdField];
            [self.newPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50 );
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(100);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        } else {
            [cell.contentView addSubview:self.confirmNewPwdField];
            [self.confirmNewPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50 );
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(100);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        }
        cell.textLabel.text = @[@"旧密码", @"新密码", @"确认新密码"][indexPath.row];

        return cell;

    } else {
        {
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.pwdField];
                [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(50);
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(100);
                    make.right.equalTo(cell.contentView).offset(-15);
                }];
                
            } else if(indexPath.row == 1) {
                [cell.contentView addSubview:self.newPwdField];
                [self.confirmPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(50 );
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(100);
                    make.right.equalTo(cell.contentView).offset(-15);
                }];
            }
            cell.textLabel.text = @[@"密   码", @"确认密码"][indexPath.row];
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}

#pragma mark - Action
- (void)confirmAction {
    

    [SVProgressHUD cod_showWithSuccessInfo:@"设置密码成功"];
    
    [self cod_returnAction];
}

@end
