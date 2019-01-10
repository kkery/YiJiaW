//
//  CODPersonInfoViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/5.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODPersonInfoViewController.h"
#import "GetImage.h"
#import "BRDatePickerView.h"
#import "UIImageView+WebCache.h"
//#import "SelectDatapickView.h"//选择时间


#import "SetNickNameViewController.h"

@interface CODPersonInfoViewController () <GetImageDelegate>

@property(nonatomic,strong) NSArray* textArr;
@property(nonatomic,strong) UIImageView* headPortraitImageView;
/** 数据*/
@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic, copy) NSDictionary *AllImfoDic;
@property (nonatomic, copy) NSDictionary *imfoDic;

@end

@implementation CODPersonInfoViewController

-(UIImageView *)headPortraitImageView {
    
    if (!_headPortraitImageView) {
        _headPortraitImageView = [[UIImageView alloc] init];
        _headPortraitImageView.image = [UIImage imageNamed:@"place_default_avatar"];
        [_headPortraitImageView setLayWithCor:30 andLayerWidth:0 andLayerColor:nil];
    }return _headPortraitImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    
    [self.baseTabeleviewGrouped setBackgroundColor:kLightGrayBgColor];
    [self.view addSubview:self.baseTabeleviewGrouped];
    
    [self initVariable];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyDataViewControllerNoti) name:@"MyDataViewClicked" object:nil];
}

#pragma mark - Init
-(void)initVariable
{
    self.textArr = @[@[@"头像"],@[@"昵称",@"手机号",@"性别",@"生日"]];
//    self.dataArr = [[NSMutableArray alloc] initWithObjects:@[@[@""],@[@"未设置",@"未设置",@"未设置",@"未设置"]], nil];
//    self.dataArr = [NSMutableArray arrayWithArray:@[@[@""],@[@"未设置",@"未设置",@"未设置",@"未设置"]]];
    
    NSMutableArray *arr0 = [NSMutableArray arrayWithObjects:@"", nil];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"未设置",@"未设置",@"未设置",@"未设置", nil];
    self.dataArr = [[NSMutableArray alloc] initWithObjects:arr0, arr, nil];

    
}

- (void)MyDataViewControllerNoti
{
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = get(CODLoginTokenKey);
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=user_info" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            save(object[@"data"][@"info"], CODUserInfoKey);
            
            self.imfoDic = object[@"data"][@"info"];
            
            [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.imfoDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"place_default_avatar"]];

            NSMutableArray *arr = self.dataArr[1];
            if (kStringIsEmpty(self.imfoDic[@"nickname"])) {
                [arr replaceObjectAtIndex:0 withObject:kFORMAT(@"未设置")];
            } else {
                [arr replaceObjectAtIndex:0 withObject:kFORMAT(@"%@",self.imfoDic[@"nickname"])];
            }
            if ([self.imfoDic[@"sex"] integerValue] == 0) {
                [arr replaceObjectAtIndex:2 withObject:kFORMAT(@"未设置")];
            } else if ([self.imfoDic[@"sex"] isEqualToString:@"1"]) {
                [arr replaceObjectAtIndex:2 withObject:@"男"];
            } else if ([self.imfoDic[@"sex"] isEqualToString:@"2"]) {
                [arr replaceObjectAtIndex:2 withObject:@"女"];
            }
            if ([self.imfoDic[@"birthday"] integerValue] == 0) {
                [arr replaceObjectAtIndex:3 withObject:kFORMAT(@"未设置")];
            } else {
                [arr replaceObjectAtIndex:3 withObject:kFORMAT(@"%@",[NSString getDateStringWithTimeInterval:self.imfoDic[@"birthday"] DataFormatterString:@"YYYY-MM-dd"])];
            }
            if (kStringIsEmpty(self.imfoDic[@"mobile"])) {
                [arr replaceObjectAtIndex:1 withObject:kFORMAT(@"未设置")];
            } else {
                [arr replaceObjectAtIndex:1 withObject:kFORMAT(@"%@",self.imfoDic[@"mobile"])];
            }
            
            [self.baseTabeleviewGrouped reloadData];
            
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.textArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.textArr[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *OneCellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OneCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:OneCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0) {
            [cell.contentView addSubview:self.headPortraitImageView];
            [self.headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(60);
                make.height.offset(60);
                make.right.equalTo(cell.contentView);
                make.centerY.equalTo(cell.contentView);
            }];
        }
    }
    
    cell.textLabel.text = self.textArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.dataArr[indexPath.section][indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .001;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
         [GETIMAGE showActionSheetInFatherViewController:self delegate:self];
    }
    
    else {
        if (indexPath.row == 0) {
            SetNickNameViewController* setNickVC = [[SetNickNameViewController alloc] init];
            setNickVC.titleStr = self.imfoDic[@"nickname"];
            setNickVC.doneBlock = ^(NSString *textValue) {
                [self requestUpdateNick:textValue];
            };
            [self.navigationController pushViewController:setNickVC animated:YES];
        } else if (indexPath.row == 1) {
            SetNickNameViewController* setNickVC = [[SetNickNameViewController alloc] init];
            setNickVC.titleStr = @"手机号";
            [self.navigationController pushViewController:setNickVC animated:YES];
        } else if (indexPath.row == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *photos = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestUpdateSex:@"男"];
            }];
            UIAlertAction *camera = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestUpdateSex:@"女"];
            }];
            
            [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
            [photos setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            [camera setValue:[UIColor blackColor] forKey:@"titleTextColor"];
            
            [alert addAction:photos];
            [alert addAction:camera];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if(indexPath.row == 3) {
            
            NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
            NSDate *maxDate = [NSDate date];
            NSString *defaultValue;

            if ([self.imfoDic[@"birthday"] integerValue] == 0) {
                defaultValue = @"";
            } else {
                defaultValue = kFORMAT(@"%@",[NSString getDateStringWithTimeInterval:self.imfoDic[@"birthday"] DataFormatterString:@"YYYY-MM-dd"]);
            }
            [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:defaultValue minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:CODColorTheme resultBlock:^(NSString *selectValue) {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate *selectedDate = [format dateFromString:selectValue];
                NSString *dateString = [format stringFromDate:selectedDate];
                [self requestUpdateBirthday:dateString];
            } cancelBlock:^{
            }];
        }
    }
    
    
}

#pragma mark - Update data
- (void)requestUpdateNick:(NSString *)obj {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"nickname"] = obj;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=edit_nickname" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_showWithSuccessInfo:@"更新成功"];
            [self loadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}
- (void)requestUpdateSex:(NSString *)obj {
    
    NSString *sex;
    if ([obj isEqualToString:@"男"]) {
        sex = @"1";
    } else {
        sex = @"2";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"sex"] = sex;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=edit_sex" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_showWithSuccessInfo:@"更新成功"];
            [self loadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

- (void)requestUpdateBirthday:(NSString *)obj {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"birthday"] = obj;//1994-06-12
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=edit_birthday" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_showWithSuccessInfo:@"更新成功"];
            [self loadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

- (void)requestUpdatePhone:(NSString *)obj {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"new_mobile"] = obj;
    params[@"code"] = obj;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=member&a=edit_mobile" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_showWithSuccessInfo:@"更新成功"];
            [self loadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - GetImageDelegate
-(void)getImageToActionWithImage:(UIImage *)image {
    
    NSMutableDictionary *imageData = [NSMutableDictionary dictionary];
    [imageData setObject:image forKey:@"avatar"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    
    [[CODNetWorkManager shareManager] AFPostData:@"m=App&c=member&a=edit_avatar" Parameters:params ImageDatas:imageData AndSucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            [SVProgressHUD cod_showWithSuccessInfo:@"设置头像成功"];
            self.headPortraitImageView.image = image;
            [kNotiCenter postNotificationName:CODRefeshMineNotificationName object:nil userInfo:nil];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - 移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
