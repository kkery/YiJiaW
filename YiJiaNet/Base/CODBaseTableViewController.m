//
//  CODBaseTableViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/20.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODBaseTableViewController.h"

@interface CODBaseTableViewController ()

@end

@implementation CODBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceList = [[NSMutableArray alloc]init];
}

#pragma mark - 初始化变量
-(void)initVariable{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}

#pragma mark - Click Event
-(void)vCBackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy load
-(UITableView *)baseTabeleviewGrouped{
    if (_baseTabeleviewGrouped ==nil) {
        _baseTabeleviewGrouped = [[UITableView alloc]initWithFrame:(CGRect){0,0,SCREENWIDTH,SCREENHEIGHT - KTabBarNavgationHeight}  style:UITableViewStyleGrouped];
        _baseTabeleviewGrouped.delegate = self;
        _baseTabeleviewGrouped.dataSource = self;
        _baseTabeleviewGrouped.showsVerticalScrollIndicator = NO;
        [_baseTabeleviewGrouped setSeparatorColor:CODColorLine];
        [_baseTabeleviewGrouped setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        //        [self.view addSubview:_baseTabeleviewGrouped];
    }
    return _baseTabeleviewGrouped;
    
}


-(UITableView *)baseTabeleviewPlain{
    if (_baseTabeleviewPlain ==nil) {
        _baseTabeleviewPlain = [[UITableView alloc]initWithFrame:(CGRect){0,0,SCREENWIDTH,SCREENHEIGHT - KTabBarNavgationHeight}  style:UITableViewStylePlain];
        _baseTabeleviewPlain.delegate = self;
        _baseTabeleviewPlain.dataSource = self;
        _baseTabeleviewPlain.showsVerticalScrollIndicator = NO;
        [_baseTabeleviewPlain setSeparatorColor:CODColorLine];
        //        [self.view addSubview:_baseTabeleviewPlain];
        [_baseTabeleviewPlain setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
        [_baseTabeleviewPlain setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return _baseTabeleviewPlain;
}

-(NSMutableDictionary *)recode_input_dic
{
    if (!_recode_input_dic) {
        _recode_input_dic = [[NSMutableDictionary alloc]init];
    }return _recode_input_dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




@interface SingleTitleTableHeadVW ()

/** lab */
@property (nonatomic,strong)UILabel *tleLab;
/** 底部分割线 */
@property (nonatomic,strong)UIView *lineVW;

@end

@implementation SingleTitleTableHeadVW

+(instancetype )headrViewWithTableView:(UITableView *)tableView andReuseID:(NSString *)identifier{
    static NSString *ID = @"SingleTitleHeader";
    SingleTitleTableHeadVW *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier == nil ? ID : identifier];
    if (headView == nil) {
        headView = [[SingleTitleTableHeadVW alloc]initWithReuseIdentifier:identifier == nil ? ID : identifier];
    }return headView;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.tleLab = [UILabel GetLabWithFont:XFONT_SIZE(16) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
        [self addSubview:self.tleLab];
        [self.tleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.lineVW = [UIView getAViewWithFrame:CGRectZero andBgColor:CODColorLine];
        [self addSubview:self.lineVW];
        [self.lineVW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(.8);
        }];
        [self.lineVW setHidden:YES];
    }return self;
}



#pragma mark - setter
-(void)setTle:(NSString *)tle{
    if (![tle isEqualToString:_tle]) {
        _tle = tle;
        [self.tleLab setText:tle];
    }
}

-(void)setTleColor:(UIColor *)tleColor{
    _tleColor = tleColor;
    [self.tleLab setTextColor:tleColor];
}

-(void)setTleFont:(UIFont *)tleFont{
    _tleFont = tleFont;
    [self.tleLab setFont:tleFont];
}

-(void)setLeft_margin:(CGFloat)left_margin{
    _left_margin = left_margin;
    [self.tleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(left_margin);
    }];
}

-(void)setIsHiddenBotomLineVW:(BOOL)isHiddenBotomLineVW{
    _isHiddenBotomLineVW = isHiddenBotomLineVW;
    [self.lineVW setHidden:isHiddenBotomLineVW];
}

@end


