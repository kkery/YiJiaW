//
//  CODShopInfoViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/10.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODShopInfoViewController.h"

static NSString * const kCell = @"CODHotTableViewCell";

@interface CODShopInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation CODShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商户信息";
    self.info = [NSDictionary dictionary];
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // data
    [self loadInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data
-(void)loadInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.companyId;
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=merchant&a=info" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            self.info = object[@"data"];
            
            [self.tableView reloadData];
            
        } else {
            
            [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kBaseCell = @"baseCell";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBaseCell];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBaseCell];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = kFont(15);
        cell.textLabel.textColor = CODColor333333;
        
        if (indexPath.section == 2) {
            self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 160)];
            [cell.contentView addSubview:self.logoImageView];
        }
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.info objectForKey:@"info"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [self.info objectForKey:@"Business_hours"];
    } else {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[self.info objectForKey:@"photo"]] placeholderImage:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kGetTextSize([self.info objectForKey:@"info"], SCREENWIDTH-30, MAXFLOAT, 15).height;
    } else if (indexPath.section == 1) {
        return kGetTextSize([self.info objectForKey:@"Business_hours"], SCREENWIDTH-30, MAXFLOAT, 15).height;
    } else {
        return 180;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    sectionHeaderview.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = kFont(18);
    
    [sectionHeaderview addSubview:titleLab];
    
    if (section == 0) {
        titleLab.text = @"企业信息";
    } else if (section == 1) {
        titleLab.text = @"营业时间";
    } else {
        titleLab.text = @"营业执照";
    }
    return sectionHeaderview;
}

@end
