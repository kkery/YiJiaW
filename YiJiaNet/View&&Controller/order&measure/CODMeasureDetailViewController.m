//
//  CODMeasureDetailViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODMeasureDetailViewController.h"
#import "CODInsetTableViewCell.h"
#import "CODPublishCommentViewController.h"
#import "ServicePathView.h"
#import "MeasureDocView.h"

@interface CODMeasureDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *compDic;
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSArray *paperImgArr;
@property (nonatomic, strong) NSArray *reportDocArr;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) MeasureDocView *drawPaperView;//量房图纸
@property (nonatomic, strong) MeasureDocView *reportView;//量房报告

@property (nonatomic, strong) ServicePathView *pathView;

@end

@implementation CODMeasureDetailViewController

- (MeasureDocView *)drawPaperView {
    if (!_drawPaperView) {
        _drawPaperView = [[MeasureDocView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-24, 106)];
        _drawPaperView.type = 1;
    } return _drawPaperView;
}
- (MeasureDocView *)reportView {
    if (!_reportView) {
        _reportView = [[MeasureDocView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-24, 106)];
        _reportView.type = 2;
    } return _reportView;
}
- (ServicePathView *)pathView {
    if (!_pathView) {
        _pathView = [[ServicePathView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-24, 90)];
    } return _pathView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"量房详情";
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    self.commentBtn = ({
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"去评价" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonNormal] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage cod_imageWithColor:CODColorButtonHighlighted] forState:UIControlStateHighlighted];
        button.hidden = YES;
        button;
    });
    [self.view addSubview:self.commentBtn];

    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(50);
    }];
    @weakify(self);
    [[self.commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        CODPublishCommentViewController *publishVC = [[CODPublishCommentViewController alloc] init];
        publishVC.paramId = self.infoDic[@"id"];
        publishVC.refreshBlock = ^{
            [self loadMeasureDetail];
        };
        [self.navigationController pushViewController:publishVC animated:YES];
    }];
    
    // data
    [self loadMeasureDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)loadMeasureDetail {
    [SVProgressHUD cod_showStatu];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    params[@"id"] = self.merchantId;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=Setting&a=detail" andParameters:params Sucess:^(id object) {
        [SVProgressHUD cod_dismis];
        if ([object[@"code"] integerValue] == 200) {
            self.compDic = object[@"data"][@"merchant"];
            self.infoDic = object[@"data"][@"ordered"];
            
            self.paperImgArr = [self.infoDic objectForKey:@"photo"];
            if (!kStringIsEmpty([self.infoDic objectForKey:@"report"])) {
                self.reportDocArr = [NSArray arrayWithObject:[self.infoDic objectForKey:@"report"]];
            }
            //已评价
            if ([[self.infoDic objectForKey:@"status"] integerValue] == 4) {
                self.commentBtn.hidden = YES;
                self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-KTabBarNavgationHeight);
            } else {
                self.commentBtn.hidden = NO;
                self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-KTabBarNavgationHeight-50);
            }
            
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
    return 6;
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
            titleLabel.text = @"量房时间";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(titleLabel.frame)+20, SCREENWIDTH-24-24, 20)];
            timeLable.textColor = CODColor666666;
            timeLable.tag = 1;
            timeLable.font = kFont(15);
            [cell.contentView addSubview:timeLable];
        }
        
        UILabel *orderTimeLab = (UILabel *)[cell.contentView viewWithTag:1];
        if (!kDictIsEmpty(self.compDic))
        {
            orderTimeLab.text = [NSString stringWithFormat:@"%@-%@", self.compDic[@"start_time"], self.compDic[@"end_time"]];
        }
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
            titleLabel.text = @"量房公司";
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
            
            UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(compNameLable.frame)+10, SCREENWIDTH-90-30, 20)];
            addressLable.textColor = CODColor666666;
            addressLable.font = [UIFont systemFontOfSize:12];
            addressLable.tag = 3;
            addressLable.numberOfLines = 2;
            addrImg.centerY = addressLable.centerY;
            [cell.contentView addSubview:addressLable];
        }
        
        UIImageView *logoImgView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *compNameLable = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *addressLable = (UILabel *)[cell.contentView viewWithTag:3];
        [logoImgView sd_setImageWithURL:[NSURL URLWithString:self.compDic[@"logo"]] placeholderImage:kGetImage(@"place_default_avatar")];
        compNameLable.text = self.compDic[@"name"];
        addressLable.text = self.compDic[@"address"];
        CGFloat mHeight = kGetTextSize(addressLable.text, SCREENWIDTH-90-20, 60, 12).height;
        addressLable.height = mHeight > 20 ? mHeight : 20;

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
            titleLabel.text = @"量房信息";
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
    
        horseNameLabel.text = kFORMAT(@"小区名称：%@",self.infoDic[@"house_name"] ?: @"暂无数据");
        sizeLab.text = kFORMAT(@"房屋面积：%@",self.infoDic[@"house_acreage"] ?: @"暂无数据");
        styleLab.text = kFORMAT(@"房屋户型：%@",self.infoDic[@"house_type"] ?: @"暂无数据");
        hourAddrLab.text = kFORMAT(@"量房地址：%@",self.infoDic[@"address"] ?: @"暂无数据");
        
        return cell;
    }
    
    else if (indexPath.row == 3) {
        static NSString * kServiceFlowCellID = @"serviceFlowCellID";
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceFlowCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kServiceFlowCellID];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"量房图纸";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            [cell.contentView addSubview:self.drawPaperView];
            [self.drawPaperView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.equalTo(titleLabel.mas_bottom).offset(20);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            }];
        }
        self.drawPaperView.imgArr = self.paperImgArr;
        cell.hidden = kArrayIsEmpty(self.paperImgArr);
        return cell;
    }

    else if (indexPath.row == 4) {
        static NSString * kServiceFlowCellID = @"serviceFlowCellID";
        CODInsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceFlowCellID];
        if (!cell) {
            cell = [[CODInsetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kServiceFlowCellID];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREENWIDTH-40, 17)];
            titleLabel.textColor = CODColor333333;
            titleLabel.font = kFont(16);
            titleLabel.text = @"量房报告";
            [cell.contentView addSubview:titleLabel];
            UIImageView *lineIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 3, 17)];
            lineIcon.image = kGetImage(@"amount_title");
            [cell.contentView addSubview:lineIcon];
            
            [cell.contentView addSubview:self.reportView];
            [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.equalTo(titleLabel.mas_bottom).offset(20);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            }];
        }

        self.reportView.imgArr = self.reportDocArr;
        cell.hidden = kArrayIsEmpty(self.reportDocArr);

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
            
            [cell.contentView addSubview:self.pathView];
            [self.pathView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.top.equalTo(titleLabel.mas_bottom).offset(20);
            }];
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
    } else if (indexPath.row == 3) {
        return kArrayIsEmpty(self.paperImgArr) ? 0 : 156+15;
    } else if (indexPath.row == 4) {
        return kArrayIsEmpty(self.reportDocArr) ? 0 : 156+15;
    } else {
        return 150+15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
