//
//  XWXShareView.m
//  HHShopping
//
//  Created by mac on 2017/11/15.
//  Copyright © 2017年 嘉瑞科技有限公司 - 许得诺言. All rights reserved.
//

#define self_ViewH 235
#import "TWHImgTitleBtn.h"
#import "XWXShareView.h"
#import <UMShare/UMShare.h>// 友盟

//#import <UMSocialCore/UMSocialCore.h>//友盟分享
//#import <UShareUI/UShareUI.h>

@interface XWXShareView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

/*底部弹出视图*/
@property(nonatomic,strong) UIControl * coverView;
@property(nonatomic,strong) UIView *whiteView;

/** 标题 */
@property(nonatomic,strong) UILabel *titleLab;
/** UICollectionView视图*/
@property (nonatomic,strong)UICollectionView *opiCollect;
/** 尾部取消 */
@property(nonatomic,strong) UIButton *dissBtn;

/** cell */
@property(nonatomic,strong) TWHImgTitleBtn *imgVwBtn;

@end

@implementation XWXShareView
static NSString *const ShopingBeanItemID = @"shopingBeanItemIdentifier";

#pragma mark - 懒加载
+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static XWXShareView* share;
    dispatch_once(&onceToken, ^{
        share = [[XWXShareView alloc] init];
    });
    return share;
}

+ (void)showShareView
{
    XWXShareView *sha = [[XWXShareView alloc] init];
    [sha show];
}

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
        _whiteView.backgroundColor = SepLineColor;
        _whiteView.userInteractionEnabled = YES;
        //设置上半部圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _whiteView.bounds;
        maskLayer.path = maskPath.CGPath;
        _whiteView.layer.mask = maskLayer;
    }
    return _whiteView;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        [_titleLab SetlabTitle:@"分享到" andFont:IS_IPHONE_5 ?kFont(15):kFont(17) andTitleColor:[UIColor blackColor] andTextAligment:1 andBgColor:[UIColor whiteColor]];
        
    }return _titleLab;
}
-(UICollectionView *)opiCollect
{
    if (!_opiCollect) {
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        //        fl.itemSize = CGSizeMake(ShopingBeanItemW,IS_IPHONE_5?30:40);
        //        fl.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //        fl.minimumLineSpacing = 5;
        //        fl.minimumInteritemSpacing = 5;
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _opiCollect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        [_opiCollect setDataSource:self];
        [_opiCollect setDelegate:self];
        [_opiCollect setBackgroundColor:SepLineColor];
        [_opiCollect setShowsVerticalScrollIndicator:NO];
        [_opiCollect setShowsHorizontalScrollIndicator:NO];
        _opiCollect.backgroundColor = SepLineColor;
        
        // 不可滑动
        _opiCollect.scrollEnabled = NO;
        
        // 注册cell、item
        [_opiCollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ShopingBeanItemID];
        
    }return _opiCollect;
}

- (UIButton *)dissBtn
{
    if (!_dissBtn) { // 取消
        _dissBtn = [[UIButton alloc] init];
        [_dissBtn SetBtnTitle:@"取消" andTitleColor:[UIColor blackColor] andFont:IS_IPHONE_5 ?kFont(15):kFont(17) andBgColor:CODHexColor(0xF5F5F5) andBgImg:nil andImg:nil andClickEvent:@selector(removeMain) andAddVC:self];
    } return _dissBtn;
}

#pragma mark-初始化UI
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    UIView *linetopVw = [[UIView alloc] init];
    linetopVw.backgroundColor = [UIColor whiteColor];
    UIView *leftVw = [[UIView alloc] init];
    leftVw.backgroundColor = [UIColor whiteColor];
    UIView *rightVw = [[UIView alloc] init];
    rightVw.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.whiteView];
    [self.whiteView addSubview:linetopVw];
    [linetopVw addSubview:leftVw];
    [linetopVw addSubview:self.titleLab];
    [linetopVw addSubview:rightVw];
    [self.whiteView addSubview:self.opiCollect];
    [self.whiteView addSubview:self.dissBtn];
    
    [linetopVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.whiteView);
        make.height.offset(60);
    }];
    [leftVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(linetopVw).offset(12);
        make.right.equalTo(self.whiteView.mas_centerX).offset(-50);
        make.width.equalTo(self.whiteView.mas_width).offset(-SCREENWIDTH/2-80);
        make.height.offset(3);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftVw);
        make.centerX.equalTo(self.whiteView);
    }];
    [rightVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftVw);
        make.left.equalTo(self.whiteView.mas_centerX).offset(50);
        make.width.equalTo(leftVw.mas_width);
        make.height.offset(3);
    }];
    
    [self.opiCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linetopVw.mas_bottom);
        make.left.right.equalTo(self.whiteView);
        make.height.offset(120);
    }];

    [self.dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.whiteView);
        make.top.equalTo(self.opiCollect.mas_bottom).offset(0);
    }];
    
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopingBeanItemID forIndexPath:indexPath];

    self.imgVwBtn = [[TWHImgTitleBtn alloc] init];
    self.imgVwBtn.BtnStyle = ImgTop;
    self.imgVwBtn.Space  = 10.0;
    self.imgVwBtn.tag = 100+indexPath.item;
    [self.imgVwBtn SetBtnTitle:@[@"微信",@"微信朋友圈",@"QQ好友",@"QQ空间"][indexPath.item] andTitleColor:[UIColor blackColor] andFont:kFont(14) andBgColor:[UIColor whiteColor] andBgImg:nil andImg:@[kGetImage(@"share_weixin"),kGetImage(@"share_pengyouquan"),kGetImage(@"share_qq"),kGetImage(@"share_qqkongjian")][indexPath.item] andClickEvent:@selector(imgVwBtnClicked:) andAddVC:self];
    [self.imgVwBtn setImage:@[kGetImage(@"share_weixin"),kGetImage(@"share_pengyouquan"),kGetImage(@"share_qq"),kGetImage(@"share_qqkongjian")][indexPath.item] forState:1];


    [cell addSubview:self.imgVwBtn];
    [self.imgVwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    return cell;
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH/4, 120);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    XWXLog(@"%ld",(long)indexPath.item)
    [self removeMain];
}

- (void)imgVwBtnClicked:(TWHImgTitleBtn *)sender
{
    if (sender.tag == 100) {
        if ([kUserCenter objectForKey:klogin_WeChat] != nil) {
            // 微信
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession withDic:self.dic];
        }else {
            [SVProgressHUD cod_showWithInfo:@"您还未安装微信"];
        }
        
    } else if (sender.tag == 101) {
        
        if ([kUserCenter objectForKey:klogin_WeChat] != nil) {
            // 朋友圈
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine withDic:self.dic];
        }else {
            [SVProgressHUD cod_showWithInfo:@"您还未安装微信"];
        }
        
    } else if (sender.tag == 102) {
        
        if ([kUserCenter objectForKey:klogin_QQ] != nil) {
            // QQ
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ withDic:self.dic];
        } else {
            [SVProgressHUD cod_showWithInfo:@"您还未安装QQ"];
        }
        
    } else {
        if ([kUserCenter objectForKey:klogin_QQ] != nil) {
            // QQ空间
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone withDic:self.dic];
        } else {
            [SVProgressHUD cod_showWithInfo:@"您还未安装QQ"];
        }
        
    }
 
    [self removeMain];
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
         // 如果使用单例就不能置空控件，否则会展现nil的（但在主控制器使用创建对象的形式展现的话，最好要置空控件即nil）
//         self.coverView = nil;
//         self.whiteView = nil;
         [self removeFromSuperview];
         
     }];
}

// 网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withDic:(NSDictionary *)dic
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dic[@"share_title"] descr:dic[@"share_content"] thumImage:[UIImage imageNamed:@"icon_logo"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://yjw.0791jr.com/download/index.html";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.navSelf completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];

}

//抱错误或成功
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    
}


@end
