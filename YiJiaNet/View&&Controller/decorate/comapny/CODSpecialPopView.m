//
//  CODSpecialPopView.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/29.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODSpecialPopView.h"
#define self_ViewH (SCREENHEIGHT*0.75)
#import "CODCompanyDetailModel.h"
@interface CODSpecialPopView () <UITableViewDelegate,UITableViewDataSource>

/*底部弹出视图*/
@property(nonatomic,strong) UIControl * coverView;
@property(nonatomic,strong) UIView *whiteView;
/** 左侧tableView */
@property(nonatomic,strong) UITableView *TableView;
/** 确定 */
@property(nonatomic,strong) UIButton *yesBtn;
@property(nonatomic,strong) UIView *yesView;


@property(nonatomic,strong) NSMutableArray* dataSource;

@end

@implementation CODSpecialPopView

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }return _dataSource;
}

#pragma mark - 懒加载
-(UIControl *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [_coverView addTarget:self action:@selector(removeMain) forControlEvents:UIControlEventTouchUpInside];
        _coverView.userInteractionEnabled = YES;
    }
    return _coverView;
}

-(UIView *)whiteView
{
    if (!_whiteView) {
        
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, self_ViewH)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.userInteractionEnabled = YES;
        _whiteView.layer.cornerRadius = 10;
        _whiteView.layer.masksToBounds = YES;
    }
    return _whiteView;
}

-(UITableView *)TableView
{
    if (!_TableView) {
        _TableView = [UITableView GetTableWithFrame:(CGRect){0,60,SCREENWIDTH, self_ViewH-50-60} andVC:self andBgColor:[UIColor whiteColor] andStyle:UITableViewStylePlain andHeadVW:nil andFootVW:nil andWhetherNeedSepLine:NO andSepLineColor:nil];
        _TableView.bounces = NO;
        
    }
    return _TableView;
}


-(UIView *)yesView
{
    if (!_yesView) {
        
        _yesView = [[UIView alloc] init];
        _yesView.backgroundColor = [UIColor whiteColor];
    }
    return _yesView;
}

- (UIButton *)yesBtn
{
    if (!_yesBtn) {
        _yesBtn = [[UIButton alloc] init];
        [_yesBtn SetBtnTitle:@"完成" andTitleColor:[UIColor whiteColor] andFont:kFont(18) andBgColor:ThemeColor andBgImg:nil andImg:nil andClickEvent:nil andAddVC:self];
        [_yesBtn SetLayWithCor:20 andLayerWidth:0 andLayerColor:0];
        @weakify(self);
        [_yesBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self);
            [self removeMain];
        }];
    } return _yesBtn;
}

#pragma mark-初始化UI
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self creatUI];
    }
    return self;
}

//-(void)setDic:(NSDictionary *)dic {
//    _dic = dic;
//
//    dic[@""]
//
//    [self.TableView reloadData];
//}

-(void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.TableView reloadData];
}

-(void)creatUI
{
    UILabel *titleLab = [[UILabel alloc] init];
    [titleLab SetlabTitle:@"特色服务" andFont:kFont(18) andTitleColor:[UIColor blackColor] andTextAligment:1 andBgColor:nil];
//    UIView *lineVw = [[UIView alloc] init];
//    lineVw.backgroundColor = CODColorBackground;
    
    [self addSubview:self.coverView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:titleLab];
//    [titleLab addSubview:lineVw];
    [self.whiteView addSubview:self.TableView];
    [self.yesView addSubview:self.yesBtn];
    [self.whiteView addSubview:self.yesView];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        make.left.top.right.equalTo(self.whiteView);
    }];
//    [lineVw mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(0.8);
//        make.left.bottom.right.equalTo(titleLab);
//    }];
    [self.yesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(64);
        make.left.bottom.right.equalTo(self.whiteView);
    }];
    [self.yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.left.equalTo(self.yesView).offset(10);
        make.right.equalTo(self.yesView).offset(-10);
        make.bottom.equalTo(self.yesView).offset(-10);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CODSpecialModel *mode = [self.dataArray objectAtIndex:indexPath.row];
    NSString *content = mode.content;
    CGSize textSize = kGetTextSize(content, SCREENWIDTH-50, MAXFLOAT, 14);
    return textSize.height + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"identifier";
    CODBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CODBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
        UIImageView *icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        icoImageView.tag = 1;
        [cell.contentView addSubview:icoImageView];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENWIDTH-50, 20)];
        titLab.font = kFont(16);
        titLab.tag = 2;
        titLab.textColor = CODColor333333;
        [cell.contentView addSubview:titLab];
        
        UILabel *subTitLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, SCREENWIDTH-50, 20)];
        subTitLab.font = kFont(14);
        subTitLab.tag = 3;
        subTitLab.textColor = CODColor666666;
        subTitLab.numberOfLines = 0;
        [cell.contentView addSubview:subTitLab];
    }
    
    UIImageView *icoImageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *titLab = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *subTitLab = (UILabel *)[cell.contentView viewWithTag:3];
    
    CODSpecialModel *mode = [self.dataArray objectAtIndex:indexPath.row];
    
    icoImageView.image = kGetImage(@"decorate_service_tick");
    titLab.text = mode.name;
    subTitLab.text = mode.content;
    CGSize textSize = kGetTextSize(mode.content, SCREENWIDTH-50, MAXFLOAT, 14);
    subTitLab.height = textSize.height;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    
    UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(10, 19, 15, 12)];
    imge.image = kGetImage(@"decorate_service_prompt");
    [sectionHeaderView addSubview:imge];
    
    UILabel *tipLabel = [UILabel GetLabWithFont:kFont(12) andTitleColor:CODColor999999 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:@"温馨提示：以下服务内容由装修公司提供，且服务的后续事项由装修公司自行安排及负责。"];
    tipLabel.numberOfLines = 0;
    tipLabel.frame = CGRectMake(35, 0, SCREENWIDTH-45, 50);
    [sectionHeaderView addSubview:tipLabel];
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - 显示视图
-(void)show
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.whiteView.y = SCREENHEIGHT - self_ViewH;
    }];
}

#pragma mark - 隐藏视图
-(void)removeMain
{
    [self resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        self.whiteView.y = SCREENHEIGHT;
    }
                     completion:^(BOOL finished)
     {
         self.coverView = nil;
         self.whiteView = nil;
         [self removeFromSuperview];
     }];
    
}
@end
