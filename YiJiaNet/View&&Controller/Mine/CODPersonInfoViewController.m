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
    self.dataArr = [NSMutableArray arrayWithArray:@[@[@""],@[@"未设置",@"未设置",@"未设置",@"未设置"]]];
}

- (void)MyDataViewControllerNoti
{
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
        params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
    }
//    [[HJNetWorkQuery shareManger] AFrequestData:@"App,Member,userinfo" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//
//            self.AllImfoDic = [NSDictionary getValuesForKeysWithDictionary:result[@"data"]];
//            self.imfoDic = self.AllImfoDic[@"info"];
//
//            [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:kFORMAT(@"%@%@",AllImgAddressUrl,self.imfoDic[@"avatar"])] placeholderImage:[UIImage imageNamed:@"avatar_my"]];
//
//            NSMutableArray *arr = self.dataArr[0];
//            if ([self.imfoDic[@"nickname"] isKindOfClass:[NSNull class]]) {
//                [arr replaceObjectAtIndex:1 withObject:kFORMAT(@"未设置")];
//            } else {
//                [arr replaceObjectAtIndex:1 withObject:kFORMAT(@"%@",self.imfoDic[@"nickname"])];
//            }
//            if ([self.imfoDic[@"sex"] isEqualToString:@"未知"]) {
//                [arr replaceObjectAtIndex:2 withObject:kFORMAT(@"未设置")];
//            } else if ([self.imfoDic[@"sex"] isEqualToString:@"1"]) {
//                [arr replaceObjectAtIndex:2 withObject:@"男"];
//            } else if ([self.imfoDic[@"sex"] isEqualToString:@"2"]) {
//                [arr replaceObjectAtIndex:2 withObject:@"女"];
//            }
//            if ([self.imfoDic[@"birthday"] isKindOfClass:[NSNull class]]) {
//                [arr replaceObjectAtIndex:3 withObject:kFORMAT(@"未设置")];
//            } else {
//                [arr replaceObjectAtIndex:3 withObject:kFORMAT(@"%@",[NSString getDateStringWithTimeInterval:self.imfoDic[@"birthday"] DataFormatterString:@"YYYY-MM-dd"])];
//            }
//            if ([self.imfoDic[@"mobile"] isKindOfClass:[NSNull class]]) {
//                [arr replaceObjectAtIndex:4 withObject:kFORMAT(@"未设置")];
//            } else {
//                [arr replaceObjectAtIndex:4 withObject:kFORMAT(@"%@",self.imfoDic[@"mobile"])];
//            }
//
//            [self.baseTabeleviewGrouped reloadData];
//        } else {
//            [self showErrorText:result[@"message"]];
//        }
//    } AndError:^(NSError *error) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
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
                //            [self showText:@"正在修改..."];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
                    params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
                }
                params[@"sex"] = @"1";
                //            [[HJNetWorkQuery shareManger] AFrequestData:@"App,Member,xgsex" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
                //                if ([result[@"code"] integerValue] == 200) {
                //                    [self showSuccessText:@"设置成功"];
                //                    NSMutableArray *arr = self.dataArr[0];
                //                    [arr replaceObjectAtIndex:2 withObject:@"男"];
                //                    [self.baseTabeleviewGrouped reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                //                } else {
                //                    [self showErrorText:result[@"message"]];
                //                }
                //            } AndError:^(NSError *error) {
                //                [self showErrorText:@"网络异常，请重试!"];
                //            }];
            }];
            UIAlertAction *camera = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //            [self showText:@"正在修改..."];
                //            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                //            if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
                //                params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
                //            }
                //            params[@"sex"] = @"2";
                //            [[HJNetWorkQuery shareManger] AFrequestData:@"App,Member,xgsex" HttpMethod:@"POST" parames:params comPletionResult:^(id result) {
                //                if ([result[@"code"] integerValue] == 200) {
                //                    [self showSuccessText:@"设置成功"];
                //                    NSMutableArray *arr = self.dataArr[0];
                //                    [arr replaceObjectAtIndex:2 withObject:@"女"];
                //                    [self.baseTabeleviewGrouped reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                //                } else {
                //                    [self showErrorText:result[@"message"]];
                //                }
                //            } AndError:^(NSError *error) {
                //                [self showErrorText:@"网络异常，请重试!"];
                //            }];
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
//            if ([get(UserInfo)[@"birthday"] isNotBlank]) {
//                defaultValue = [NSString TimeStrType:@"yyyy-MM-dd" andCreatTime:get(UserInfo)[@"birthday"]];
//            } else {
//                defaultValue = @"";
//            }
            
            [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:defaultValue minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:CODColorTheme resultBlock:^(NSString *selectValue) {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd";
                NSDate *selectedDate = [format dateFromString:selectValue];
                NSTimeInterval interval = [selectedDate timeIntervalSince1970]*1000;
//                [self requestUpdateInfoWithValue:[NSString stringWithFormat:@"%@",@(interval)] key:@"birthday"];
            } cancelBlock:^{
            }];
        }
    }
    
    
}


#pragma mark - GetImageDelegate(选取的图片上传到服务器)的代理方法
-(void)getImageToActionWithImage:(UIImage *)image {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if ([kUserCenter objectForKey:@"login_credentials"] != nil) {
        params[@"user_id"] = [kUserCenter objectForKey:@"login_credentials"];
    }
    NSMutableDictionary *imageData = [NSMutableDictionary dictionary];
//    [imageData setObject:image forKey:@"avatar"];
//    [[HJNetWorkQuery shareManger] AfPostUrl:@"App,Member,avatar_edit" params:params Data:imageData completionHandle:^(id result) {
//        if ([result[@"code"] integerValue] == 200) {
//            self.headPortraitImageView.image = image;
//            // 通知主类刷新
//            [kNotiCenter postNotificationName:@"MyMainVCNoti" object:nil userInfo:nil];
//            [self showSuccessText:@"设置头像成功"];
//        } else {
//            [self showErrorText:result[@"message"]];
//        }
//    } errorHandle:^(NSError *error) {
//        [self showErrorText:@"网络异常，请重试!"];
//    }];
    
}

#pragma mark - 移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
