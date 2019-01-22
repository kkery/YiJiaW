//
//  CODPublishCommentViewController.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/16.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODPublishCommentViewController.h"
#import "CODTextView.h"
#import "StarEvaluationView.h"
#import "ChoosePhotos.h"
#import "XWXImageVwIteam.h"
#import "ImageBrowserViewController.h"
#import "CODComentSuccViewController.h"
CGFloat const kLineImageCount = 4;

@interface CODPublishCommentViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,ChoosePhotosDelegate>

/** 商家星级视图 */
@property (nonatomic,strong) StarEvaluationView *starVW;

@property (nonatomic, strong) UICollectionView *ImgCollect;

/** 选中的图片 */
@property (nonatomic, copy) NSMutableArray *SelectPhoto;
/** 选中的相册资信息 */
@property (nonatomic, copy) NSMutableArray *SelectAserts;
/**item宽度*/
@property (nonatomic,assign)CGFloat ItemWidth;

/** 头视图 */
@property (nonatomic,strong)UIView *headView;
@property(nonatomic,strong) UIImageView *headImg;
@property (nonatomic , strong) CODTextView *textVw;
@property (nonatomic, strong) UILabel *countLab;

/** 请求参数*/
@property (nonatomic,strong)NSMutableDictionary *parDic;

@end

@implementation CODPublishCommentViewController
#pragma mark - 懒加载
-(NSMutableArray *)SelectPhoto{
    if (!_SelectPhoto) {
        _SelectPhoto = [[NSMutableArray alloc] init];
    }return _SelectPhoto;
}

-(NSMutableArray *)SelectAserts{
    if (!_SelectAserts) {
        _SelectAserts = [[NSMutableArray alloc]init];
    }return _SelectAserts;
}

-(UICollectionView *)ImgCollect
{
    if (!_ImgCollect) {
        UICollectionViewFlowLayout *lout = [[UICollectionViewFlowLayout alloc]init];
        lout.minimumLineSpacing = IS_IPHONE_5 ? 7 : 10;
        lout.minimumInteritemSpacing = IS_IPHONE_5 ? 7 : 10;
        lout.sectionInset = IS_IPHONE_5 ? UIEdgeInsetsMake(12.5, 10, 12.5, 10) :  UIEdgeInsetsMake(15, 12.5, 15, 12.5);
        lout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat SingleWidth = 0;
        SingleWidth = (SCREENWIDTH - (IS_IPHONE_5 ? 20 : 25) - (lout.minimumLineSpacing*3))/kLineImageCount;
        lout.itemSize = CGSizeMake(SingleWidth, SingleWidth);
        self.ItemWidth = SingleWidth;
        
        _ImgCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110) collectionViewLayout:lout];
        _ImgCollect.backgroundColor = [UIColor whiteColor];
        _ImgCollect.dataSource = self;
        _ImgCollect.delegate = self;
        _ImgCollect.bounces=NO;
        _ImgCollect.showsVerticalScrollIndicator = NO;
        
        // 注册Iteam
        //        [_ImgCollect registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        [_ImgCollect registerClass:[XWXImageVwIteam class] forCellWithReuseIdentifier:@"XWXImageVwIteam"];
        
        
    }return _ImgCollect;
}


- (CODTextView *)textVw
{
    if (!_textVw) {
        _textVw = [[CODTextView alloc] init];
        _textVw.backgroundColor= kLightGrayBgColor;
        _textVw.placeholder = @"装修公司满足你的期待吗？请说说吧";
        [_textVw setLayWithCor:6 andLayerWidth:0 andLayerColor:nil];
        _textVw.font = XFONT_SIZE(14);
        _textVw.delegate = self;
    } return _textVw;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIView *toplineVw = [UIView getAViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10) andBgColor:kLightGrayBgColor];
        [_headView addSubview:toplineVw];
        
        UILabel *tipLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODColor333333 andTextAligment:1 andBgColor:nil andlabTitle:@"为装修公司评分"];
        tipLab.frame = CGRectMake(10, 30, SCREENWIDTH-20, 20);
        [_headView addSubview:tipLab];

        self.starVW = [StarEvaluationView evaluationViewWithChooseStarBlock:^(StarEvaluationView *starview, NSUInteger count) {
            self.parDic[@"score"] = kFORMAT(@"%ld",count);
        }];
        self.starVW.spacing = 0.5;
        self.starVW.starCount = 0;
        self.starVW.tapEnabled = YES;
        
        [_headView addSubview:self.starVW];
        [_headView addSubview:self.textVw];
        
        [self.starVW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLab.mas_bottom).offset(20);
            make.centerX.offset(0);
            make.width.offset(SCREENWIDTH-80*proportionW);
            make.height.offset(40);
        }];
        
        [self.textVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.starVW.mas_bottom).offset(30);
            make.centerX.offset(0);
            make.width.offset(SCREENWIDTH-15);
            make.height.offset(160);
        }];
        
        self.countLab = [UILabel GetLabWithFont:XFONT_SIZE(14) andTitleColor:[UIColor darkGrayColor] andTextAligment:2 andBgColor:nil andlabTitle:kFORMAT(@"0/%@",@(200))];
        [_headView addSubview:self.countLab];
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.textVw.mas_bottom).offset(-5);
            make.right.equalTo(self.textVw.mas_right).offset(-5);
        }];
        
    } return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发布评论";
    // Do any additional setup after loading the view.
    self.parDic = [NSMutableDictionary new];
    self.parDic[@"score"] = @"0";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itmWithTitle:@"发布" SelectTitle:@"发布" Font:XFONT_SIZE(14) textColor:ThemeColor selectedTextColor:ThemeColor target:self action:@selector(FaBuBtnAction)];

    self.baseTabeleviewGrouped.frame = (CGRect){0,0,SCREENWIDTH,SCREENHEIGHT - KTabBarNavgationHeight};
    kNoneSepLine(self.baseTabeleviewGrouped);
    [self.baseTabeleviewGrouped setBackgroundColor:kLightGrayBgColor];
    self.baseTabeleviewGrouped.tableHeaderView = self.headView;
    self.baseTabeleviewGrouped.bounces = NO;
    [self.view addSubview:self.baseTabeleviewGrouped];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 行数
    NSInteger totalCount = self.SelectPhoto.count + 1;
    NSInteger num = totalCount/4;
    if (totalCount % 4 > 0) {
        num += 1;
    }
    CGFloat TotalHeight = (IS_IPHONE_5 ? 12.5 : 15) * 2 + (num - 1)*(IS_IPHONE_5 ? 7 : 10) + num * self.ItemWidth;
    return TotalHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier  = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    [cell addSubview:self.ImgCollect];
    [self.ImgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.SelectPhoto.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWXImageVwIteam *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XWXImageVwIteam" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item==self.SelectPhoto.count) {
        [cell.imageView setImage:kGetImage(@"evaluation_add")];
        cell.deleteBtn.hidden=YES;
    }else{
        cell.imageView.image = self.SelectPhoto[indexPath.item];
        //        cell.asset = self.SelectAserts[indexPath.item];
        cell.deleteBtn.hidden=NO;
        cell.deleteBtn.tag = indexPath.item+100;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==self.SelectPhoto.count) {
        [self AddPhotosBtnClicked];
    }else{
        [self.view endEditing:YES];
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:indexPath.row imagesBlock:^NSArray *{
            return self.SelectPhoto;
        }];
    }
}

#pragma mark - 控制添加图片的个数
-(void)AddPhotosBtnClicked
{
    if (self.SelectPhoto.count >= 9) {
        [SVProgressHUD cod_showWithInfo:@"最多只能上传9张图片!"];
    }else{
        ChoosePhotos *cp = [ChoosePhotos SharedChoseImg];
        cp.ExistSelectPhotos = self.SelectPhoto;
        cp.ExistSelectAserts = self.SelectAserts;
        [cp showActionSheetInFatherViewController:self delegate:self andMaxCount:9];
    }
}


#pragma mark - 选取图片的数组的代理实现
-(void)getImage:(NSMutableArray *)images andAserts:(NSMutableArray *)aserts
{
    [self.SelectPhoto removeAllObjects];
    [self.SelectPhoto addObjectsFromArray:images];
    [self.SelectAserts removeAllObjects];
    [self.SelectAserts addObjectsFromArray:aserts];
    [self.ImgCollect reloadData];
    
    [self DealWithDataChangeAndFrameChange];
}

#pragma mark - 删除图片的方法实现
- (void)deleteBtnClik:(UIButton *)sender
{
    [self.SelectPhoto removeObjectAtIndex:sender.tag-100];
    [self.SelectAserts removeObjectAtIndex:sender.tag-100];
    
    [self.ImgCollect reloadData];
    
    [self DealWithDataChangeAndFrameChange];
}

-(void)DealWithDataChangeAndFrameChange
{
    NSInteger con = kLineImageCount;
    NSInteger totalCount = self.SelectPhoto.count + 1;
    NSInteger num = totalCount/kLineImageCount;
    if (totalCount % con > 0) {
        num += 1;
    }
    
    CGFloat TotalHeight = (IS_IPHONE_5 ? 12.5 : 15) * 2 + (num - 1)*(IS_IPHONE_5 ? 7 : 10) + num * self.ItemWidth;
    self.ImgCollect.height = TotalHeight;
    
    [self.baseTabeleviewGrouped reloadData];
    
}

// 发布
- (void)FaBuBtnAction
{
    if ([self.parDic[@"score"] isEqualToString:@"0"]) {
        [SVProgressHUD cod_showWithInfo:@"请选择星级"];
    } else {
        // 发表
        self.parDic[@"content"] = self.textVw.text;
        self.parDic[@"user_id"] = COD_USERID;
        self.parDic[@"id"] = self.paramId;

        [SVProgressHUD cod_showWithStatu:@"评价发布中..."];
        NSMutableDictionary *imgDic = [[NSMutableDictionary alloc]init];
        imgDic[@"img"] = self.SelectPhoto;
        
        [[CODNetWorkManager shareManager] AFPostData:@"m=App&c=Setting&a=evaluation" Parameters:self.parDic ImageDatas:imgDic AndSucess:^(id object) {
            if ([object[@"code"] integerValue] == 200) {
                [SVProgressHUD cod_showWithSuccessInfo:@"评价成功"];
                CODComentSuccViewController *succeVC = [[CODComentSuccViewController alloc] init];
                [self.navigationController pushViewController:succeVC animated:YES];
            } else {
                [SVProgressHUD cod_showWithErrorInfo:object[@"message"]];
            }
        } failed:^(NSError *error) {
            [SVProgressHUD cod_showWithErrorInfo:@"网络错误，请重试"];
        }];
    }
}


#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 拦截换行 改为收键盘
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 200)
    {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:200];
        
        if (rangeIndex.length == 1)//字数超限
        {
            textView.text = [str substringToIndex:200];
            //防止粘贴时字数超限,不走textViewDidChange方法,重新计算字数
            self.countLab.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, @(200)];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
            textView.text = [str substringWithRange:rangeRange];
        }
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 200)
    {
        textView.text = [textView.text substringToIndex:200];
    }
    self.countLab.text = [NSString stringWithFormat:@"%lu/%@", (unsigned long)textView.text.length, @(200)];
}


@end
