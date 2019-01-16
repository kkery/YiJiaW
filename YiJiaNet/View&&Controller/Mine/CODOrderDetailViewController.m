//
//  CODOrderDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODOrderDetailViewController.h"
#import "CODInsetTableViewCell.h"

@interface CODOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *compDic;
@property (nonatomic, strong) NSDictionary *infoDic;

@end

@implementation CODOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"预约详情";
    self.dataArray = [NSMutableArray array];
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = CODColorBackground;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
//        [tableView registerClass:[CODMineOrderTableViewCell class] forCellReuseIdentifier:kCODMineOrderTableViewCell];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // data
    [self loadOrderDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)loadOrderDetail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"status"] = @(2);//2预约 3量房
    params[@"merchant_id"] = self.merchantId;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=Setting&a=detail" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            self.compDic = object[@"data"][@"res"];
            self.infoDic = object[@"data"][@"list"];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络异常，请重试!"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString * kTimeCellID = @"timeCell";
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTimeCellID];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"预约时间";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, SCREENWIDTH-24-24, 20)];
            timeLable.textColor = CODHexColor(0x55555);
            timeLable.tag = 1;
            timeLable.font = kFont(15);
            [cell.contentView addSubview:timeLable];
        }
        
        UILabel *orderTimeLab = (UILabel *)[cell.contentView viewWithTag:1];
        orderTimeLab.text = [NSString stringWithFormat:@"%@-%@", self.compDic[@"start_time"], self.compDic[@"end_time"]];
        return cell;
    }
    
    else if (indexPath.row == 1) {
        static NSString * kCompanyCellID = @"companyCell";
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCompanyCellID];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"预约公司";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, 50, 50)];
            logoImgView.layer.cornerRadius = 25;
            logoImgView.layer.masksToBounds = YES;
            logoImgView.tag = 1;
            [cell.contentView addSubview:logoImgView];
            
            UILabel *compNameLable = [[UILabel alloc] initWithFrame:CGRectMake(74, CGRectGetMaxY(titleLabel.frame)+20, SCREENWIDTH-110, 20)];
            compNameLable.textColor = CODColor333333;
            compNameLable.font = [UIFont systemFontOfSize:16];
            compNameLable.tag = 2;
            [cell.contentView addSubview:compNameLable];
            
            UIImageView *addrImg = [[UIImageView alloc] init];
            addrImg.size = CGSizeMake(10, 12);
            addrImg.left = compNameLable.left;
            addrImg.image = kGetImage(@"amount_location");
            [cell.contentView addSubview:addrImg];

            UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(compNameLable.frame)+10, SCREENWIDTH-90-20, 20)];
            addressLable.textColor = CODColor666666;
            addressLable.font = [UIFont systemFontOfSize:12];
            addressLable.tag = 3;
            addrImg.centerY = addressLable.centerY;
            [cell.contentView addSubview:addressLable];
        }
        
        UIImageView *logoImgView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *compNameLable = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *addressLable = (UILabel *)[cell.contentView viewWithTag:3];
        [logoImgView sd_setImageWithURL:[NSURL URLWithString:self.compDic[@"logo"]] placeholderImage:kGetImage(@"place_default_avatar")];
        compNameLable.text = self.compDic[@"name"];
        addressLable.text = self.compDic[@"address"];
        return cell;
    }
    
    else if (indexPath.row == 2) {
        
        static NSString * kHourseInfoCellID = @"kHourseInfoCell";
        
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHourseInfoCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHourseInfoCellID];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"预约信息";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            UILabel *horseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, SCREENWIDTH-40, 20)];
            horseNameLabel.textColor = CODColor333333;
            horseNameLabel.tag = 1;
            horseNameLabel.font = kFont(15);
            [cell.contentView addSubview:horseNameLabel];
            
            UILabel *sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(horseNameLabel.frame)+10, SCREENWIDTH-40, 20)];
            sizeLab.textColor = CODColor333333;
            sizeLab.tag = 2;
            sizeLab.font = kFont(15);
            [cell.contentView addSubview:sizeLab];
            
            UILabel *styleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(sizeLab.frame)+10, SCREENWIDTH-40, 20)];
            styleLab.textColor = CODColor333333;
            styleLab.tag = 3;
            styleLab.font = kFont(15);
            [cell.contentView addSubview:styleLab];
            
            UILabel *hourAddrLab = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(styleLab.frame)+10, SCREENWIDTH-40, 20)];
            hourAddrLab.textColor = CODColor333333;
            hourAddrLab.tag = 4;
            hourAddrLab.font = kFont(15);
            [cell.contentView addSubview:hourAddrLab];
        }
        
        UILabel *horseNameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *sizeLab = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *styleLab = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *hourAddrLab = (UILabel *)[cell.contentView viewWithTag:4];
        
        horseNameLabel.text = kFORMAT(@"小区名称：%@",self.infoDic[@"house_name"]);
        sizeLab.text = kFORMAT(@"房屋面积：%@",self.infoDic[@"house_acreage"]);
        styleLab.text = kFORMAT(@"房屋户型：%@",self.infoDic[@"house_type"]);
        hourAddrLab.text = kFORMAT(@"量房地址：%@",self.infoDic[@"address"]);
        
        return cell;
    }
    else {
        static NSString * kServiceFlowCellID = @"serviceFlowCellID";
        
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceFlowCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kServiceFlowCellID];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"服务流程说明";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
           
        }
        
        
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80+15;
    } else if (indexPath.row == 1) {
        return 120+15;
    } else if (indexPath.row == 2) {
        return 180+15;
    } else {
        return 150+15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
