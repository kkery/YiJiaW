//
//  CODLoupanInfoViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/31.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODLoupanInfoViewController.h"
#import "CODLoupanHeaderView.h"

@interface CODLoupanInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CODLoupanInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self wr_setNavBarShadowImageHidden:YES];

    self.title = @"楼盘信息";
    
    // configure view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    
    [self.view addSubview:self.tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
-(void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = COD_USERID;
    
    [[CODNetWorkManager shareManager] AFRequestData:@"m=App&c=message&a=msg_list" andParameters:params Sucess:^(id object) {
        if ([object[@"code"] integerValue] == 200) {
            
            self.dataArray = object[@"data"][@"list"];

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
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([CODBaseTableViewCell class]);
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 20)];
        titleLabel.textColor = CODColor666666;
        titleLabel.tag = 1;
        titleLabel.font = kFont(14);
        [cell.contentView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, SCREENWIDTH-90, 20)];
        subTitleLabel.textColor = CODColor333333;
        subTitleLabel.tag = 2;
        subTitleLabel.font = kFont(14);
        [cell.contentView addSubview:subTitleLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *subTitleLabel = (UILabel *)[cell.contentView viewWithTag:2];
   
    titleLabel.text = @"楼盘面积:";
    subTitleLabel.text = @"住宅均价12254元/m";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString * const kSectionHeaderViewID = @"sectionHeaderViewID";
    CODLoupanHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderViewID];
    if (!headerView) {
        headerView = [[CODLoupanHeaderView alloc] initWithReuseIdentifier:kSectionHeaderViewID];
    }
    NSArray *titleArr = @[@"楼盘信息",@"销售信息",@"楼盘信息",@"楼盘信息",@"楼盘信息",@"楼盘信息"];
    headerView.title = [titleArr objectAtIndex:section];
    return headerView;
}
@end
