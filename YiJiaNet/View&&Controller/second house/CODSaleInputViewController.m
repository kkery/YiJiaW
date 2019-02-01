//
//  CODSaleInputViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/2/1.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODSaleInputViewController.h"
#import "CODBaseWebViewController.h"

@interface CODSaleInputViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

// 输入框
@property (nonatomic, strong) UITextField *dongTF;//栋
@property (nonatomic, strong) UITextField *danyuanTF;//单元
@property (nonatomic, strong) UITextField *shiTF;//室

@property (nonatomic, strong) UITextField *xiaoquTF;//小区
@property (nonatomic, strong) UITextField *mianjiTF;//面积
@property (nonatomic, strong) UITextField *shoujiaTF;//售价
@property (nonatomic, strong) UITextField *chenghuTF;//称呼
// 弹出框
@property (nonatomic, strong) UILabel *huxingLab;//户型
@property (nonatomic, strong) UILabel *loucengLab;//楼层
@property (nonatomic, strong) UILabel *zhuangxiuLab;//装修

@end

@implementation CODSaleInputViewController

- (UITextField *)dongTF {
    if (!_dongTF) {
        _dongTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 100, 50)];
        [_dongTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"必填"];
        [_dongTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _dongTF.delegate = self;
        UIView *rithView = [[UIView alloc] init];
        rithView.size = CGSizeMake(60, 50);
        UILabel *untiLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:2 andBgColor:nil andlabTitle:@"栋(号)"];
        untiLab.size = CGSizeMake(45, 50);
        [rithView addSubview:untiLab];
        _dongTF.rightViewMode = UITextFieldViewModeAlways;
        _dongTF.rightView = rithView;
        _dongTF.keyboardType = UIKeyboardTypeNumberPad;
    }return _dongTF;
}
- (UITextField *)danyuanTF {
    if (!_danyuanTF) {
        _danyuanTF = [[UITextField alloc] initWithFrame:CGRectMake(190, 0, 100, 50)];
        [_danyuanTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"选填"];
        [_danyuanTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _danyuanTF.delegate = self;
        UIView *rithView = [[UIView alloc] init];
        rithView.size = CGSizeMake(50, 50);
        UILabel *untiLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:2 andBgColor:nil andlabTitle:@"单元"];
        untiLab.size = CGSizeMake(35, 50);
        [rithView addSubview:untiLab];
        _danyuanTF.rightViewMode = UITextFieldViewModeAlways;
        _danyuanTF.rightView = rithView;
        _danyuanTF.keyboardType = UIKeyboardTypeNumberPad;
    }return _danyuanTF;
}
- (UITextField *)shiTF {
    if (!_shiTF) {
        _shiTF = [[UITextField alloc] initWithFrame:CGRectMake(SCREENWIDTH-92, 0, 80, 50)];
        [_shiTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"选填"];
        [_shiTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _shiTF.delegate = self;
        UIView *rithView = [[UIView alloc] init];
        rithView.size = CGSizeMake(30, 50);
        UILabel *untiLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:2 andBgColor:nil andlabTitle:@"室"];
        untiLab.size = CGSizeMake(25, 50);
        [rithView addSubview:untiLab];
        _shiTF.rightViewMode = UITextFieldViewModeAlways;
        _shiTF.rightView = rithView;
        _shiTF.keyboardType = UIKeyboardTypeNumberPad;
    }return _shiTF;
}
- (UITextField *)xiaoquTF {
    if (!_xiaoquTF) {
        _xiaoquTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-100, 50)];
        [_xiaoquTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"请输入您的小区名"];
        [_xiaoquTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _xiaoquTF.delegate = self;
    }return _xiaoquTF;
}
- (UITextField *)mianjiTF {
    if (!_mianjiTF) {
        _mianjiTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-100, 50)];
        [_mianjiTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"请输入您的房屋面积"];
        [_mianjiTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        UIView *rithView = [[UIView alloc] init];
        rithView.size = CGSizeMake(40, 50);
        UILabel *untiLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:2 andBgColor:nil andlabTitle:@"m²"];
        untiLab.size = CGSizeMake(25, 50);
        [rithView addSubview:untiLab];
        _mianjiTF.rightViewMode = UITextFieldViewModeAlways;
        _mianjiTF.rightView = rithView;
        _mianjiTF.delegate = self;
        _shiTF.keyboardType = UIKeyboardTypeDecimalPad;
    }return _mianjiTF;
}
- (UITextField *)shoujiaTF {
    if (!_shoujiaTF) {
        _shoujiaTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-100, 50)];
        [_shoujiaTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"请输入您的售价"];
        [_shoujiaTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _shoujiaTF.delegate = self;
        UIView *rithView = [[UIView alloc] init];
        rithView.size = CGSizeMake(40, 50);
        UILabel *untiLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:2 andBgColor:nil andlabTitle:@"万"];
        untiLab.size = CGSizeMake(25, 50);
        [rithView addSubview:untiLab];
        _shoujiaTF.rightViewMode = UITextFieldViewModeAlways;
        _shoujiaTF.rightView = rithView;
        _shoujiaTF.keyboardType = UIKeyboardTypeDecimalPad;
    }return _shoujiaTF;
}
- (UITextField *)chenghuTF {
    if (!_chenghuTF) {
        _chenghuTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-100, 50)];
        [_chenghuTF SetTfTitle:nil andTitleColor:CODColor999999 andFont:kFont(15) andTextAlignment:2 andPlaceHold:@"请输入您的称呼，如：李先生"];
        [_chenghuTF modifyPlaceholdFont:kFont(15) andColor:CODColor999999];
        _chenghuTF.delegate = self;
    }return _chenghuTF;
}

- (UILabel *)huxingLab {
    if (!_huxingLab) {
        _huxingLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-130, 50)];
        [_huxingLab SetLabFont:kFont(15) andTitleColor:CODColor999999 andTextAligment:2 andBgColor:nil andlabTitle:@"请选择您的户型"];
    }return _huxingLab;
}
- (UILabel *)loucengLab {
    if (!_loucengLab) {
        _loucengLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-130, 50)];
        [_loucengLab SetLabFont:kFont(15) andTitleColor:CODColor999999 andTextAligment:2 andBgColor:nil andlabTitle:@"请选择您的楼层"];
    }return _loucengLab;
}
- (UILabel *)zhuangxiuLab {
    if (!_zhuangxiuLab) {
        _zhuangxiuLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, SCREENWIDTH-130, 50)];
        [_zhuangxiuLab SetLabFont:kFont(15) andTitleColor:CODColor999999 andTextAligment:2 andBgColor:nil andlabTitle:@"请选择房屋装修"];
    }return _zhuangxiuLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"委托出售";
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = CODColorBackground;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        UIButton *commitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(12, 15, SCREENWIDTH-24, 44);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"立即委托" forState:UIControlStateNormal];
            button.backgroundColor = CODColorTheme;
            [button SetLayWithCor:22 andLayerWidth:0 andLayerColor:nil];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self commitAction];
            }];
            button;
        });
        [tableFooterView addSubview:commitButton];
        tableView.tableFooterView = tableFooterView;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // data
    self.titleArray = @[@[@"小区名",@"楼栋(单元)"], @[@"户型",@"面积",@"楼层",@"装修",@"售价",@"称呼"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCellID = @"cellID";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCellID];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBaseCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        titleLabel.textColor = CODColor333333;
        titleLabel.tag = 1;
        titleLabel.font = kFont(15);
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            [cell.contentView addSubview:self.dongTF];
            [cell.contentView addSubview:self.danyuanTF];
            [cell.contentView addSubview:self.shiTF];
            
            UILabel *tipsLab = [UILabel GetLabWithFont:kFont(12) andTitleColor:CODColor999999 andTextAligment:2 andBgColor:nil andlabTitle:@"地址保密，仅用于信息核验"];
            [cell.contentView addSubview:tipsLab];
            [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-12);
                make.bottom.offset(-10);
            }];
        }
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.xiaoquTF];
            } else {
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [cell.contentView addSubview:self.huxingLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 1) {
                [cell.contentView addSubview:self.mianjiTF];
            } else if (indexPath.row == 2) {
                [cell.contentView addSubview:self.loucengLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 3) {
                [cell.contentView addSubview:self.zhuangxiuLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 4) {
                [cell.contentView addSubview:self.shoujiaTF];
            } else {
                [cell.contentView addSubview:self.chenghuTF];
            }
        }
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
    titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
  

    
    
    
//    if (indexPath.row == 4) {
//        cell.detailTextLabel.text = self.version;
//    }
//    if (indexPath.row == 5) {
//        cell.detailTextLabel.text = kFORMAT(@"%.1fM", self.cacheSize);
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 70;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 40 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    UIButton *tipBtn = [UIButton GetBtnWithTitleColor:CODHexColor(0x82C3E1) andFont:kFont(12) andBgColor:nil andBgImg:nil andImg:kGetImage(@"login_check_selected") andClickEvent:@selector(tipsAction) andAddVC:self andTitle:@"出售须知"];
    tipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    tipBtn.frame = CGRectMake(SCREENWIDTH - 90, 10, 80, 20);
    [footer addSubview:tipBtn];
    return section == 1 ? footer : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Action
- (void)commitAction {
    
}
- (void)tipsAction {
    CODBaseWebViewController *webVC = [[CODBaseWebViewController alloc] initWithUrlString:CODDetaultWebUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
