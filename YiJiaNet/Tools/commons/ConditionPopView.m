//
//  ConditionPopView.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/3.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "ConditionPopView.h"

@interface ConditionPopView()<UITableViewDelegate,UITableViewDataSource>

/** 选项列表*/
@property (nonatomic,strong)UITableView *opitionTable;
/** 数据*/
@property (nonatomic,strong)NSMutableArray *dataArr;

/** 当前选中的下标 */
@property (nonatomic,assign) NSInteger curent_select_index;
/** 当前key */
@property (nonatomic, copy) NSString *key_imfo;

/** 父视图 */
@property (nonatomic,strong)UIView *addVW;

/** 是否是处于展示状态(仅内部可读可写) */
@property (nonatomic,assign,readwrite) BOOL isShow;

@end

@implementation ConditionPopView


-(instancetype)initWithFrame:(CGRect)frame supView:(UIView *)vw{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
        [self initVariable];
        [self addSubview:self.opitionTable];
        self.addVW = vw;
        
    }return self;
}

-(void)initVariable{
    self.recodeIndexDic = [[NSMutableDictionary alloc]init];
    self.dataArr = [[NSMutableArray alloc]init];
    self.key_imfo = [[NSString alloc]init];
}


#pragma mark - UI Event
-(void)showWithData:(NSArray *)data opitionKey:(NSString *)key
{
    [self.addVW addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        if ((45*proportionH * data.count) >= SCREENHEIGHT/2) {
            self.opitionTable.height = SCREENHEIGHT/2;
        } else {
            self.opitionTable.height = 45 * data.count;
        }
    } completion:^(BOOL finished) {
        self.key_imfo = key;
        
//        if (![self.dataArr isEqual:data]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:data];
//        }
        
        if ([[self.recodeIndexDic allKeys] containsObject:key]) {
            if ([self.recodeIndexDic[key] integerValue] < self.dataArr.count) {
                self.curent_select_index = [self.recodeIndexDic[key] integerValue];
            }else{
                self.curent_select_index = 0;
            }
        }else{
            self.curent_select_index = 0;
        }
        [self.opitionTable reloadData];
        
        self.isShow = YES;
    }];
}


-(void)dismiss{
    [UIView animateWithDuration:.25 animations:^{
        self.opitionTable.height = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isShow = NO;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches.anyObject.view isEqual:self]) {
        [self dismiss];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        kCellNoneSelct(cell);
        
        [cell.textLabel setFont:XFONT_SIZE(16)];
    }
    if ([self.dataArr[indexPath.row] isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.dataArr[indexPath.row]];
    }
    [cell.textLabel setTextColor:indexPath.row == self.curent_select_index ? CODColorTheme : CODColor333333];
    [cell setAccessoryView:indexPath.row == self.curent_select_index ? [[UIImageView alloc]initWithImage:kGetImage(@"check_sel")] : [[UIImageView alloc]initWithImage:nil]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curent_select_index = indexPath.row;
    self.recodeIndexDic[self.key_imfo] = kFORMAT(@"%ld",indexPath.row);
    if (self.SelectBlock) {
        self.SelectBlock(self.key_imfo, indexPath.row,self.dataArr[self.curent_select_index]);
    }
    [self dismiss];
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


#pragma mark - lazyload
-(UITableView *)opitionTable
{
    if (!_opitionTable) {
        _opitionTable = [UITableView GetTableWithFrame:CGRectMake(0, 0, SCREENWIDTH,0) andVC:self andBgColor:[UIColor whiteColor] andStyle:UITableViewStyleGrouped andHeadVW:nil andFootVW:nil andWhetherNeedSepLine:YES andSepLineColor:kLightGrayBgColor];
    }return _opitionTable;
}

@end
