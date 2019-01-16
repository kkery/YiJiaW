//
//  GetMultipleImagesTableViewCell.m
//  PenTW
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 许得诺言. All rights reserved.
//

#import "GetMultipleImagesTableViewCell.h"

//获取多张图片
#import "ChoosePhotos.h"
#import "ImageBrowserViewController.h"
#import "XWXImageVwIteam.h"
@interface GetMultipleImagesTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,ChoosePhotosDelegate>

@property(nonatomic,strong) UIViewController* navClass;

//
@property (nonatomic, strong) UICollectionView *ImgCollect;
/** 选中的图片 */
@property (nonatomic, strong) NSMutableArray *SelectPhoto;
/**item宽度*/
@property (nonatomic,assign)CGFloat ItemWidth;



@end


@implementation GetMultipleImagesTableViewCell

-(NSMutableArray *)SelectPhoto{
    if (!_SelectPhoto) {
        _SelectPhoto = [[NSMutableArray alloc]init];
    }return _SelectPhoto;
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
        SingleWidth = (SCREENWIDTH - (IS_IPHONE_5 ? 40 : 45) - (lout.minimumLineSpacing*3))/4;
        lout.itemSize = CGSizeMake(SingleWidth, SingleWidth);
        self.ItemWidth = SingleWidth;
        
        _ImgCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, IS_IPHONE_5 ? 95 : 105) collectionViewLayout:lout];
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


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier superClass:(UIViewController *)parkClass
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.navClass = parkClass;
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:self.ImgCollect];
        [self.ImgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        
        
    }return self;
}

-(void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
  
    self.SelectPhoto = dataArr;
    
    [self.ImgCollect reloadData];
}


#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.SelectPhoto.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    XWXImageVwIteam *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XWXImageVwIteam" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //    cell.videoImageView.hidden = YES;
    if (indexPath.item==self.SelectPhoto.count) {
        [cell.imageView setImage:kGetImage(@"technician_upload")];
        cell.deleteBtn.hidden=YES;
    }else{
//        cell.imageView.image = self.SelectPhoto[indexPath.item];
        //        cell.asset = self.SelectAserts[indexPath.item];
        cell.deleteBtn.hidden=NO;
        cell.deleteBtn.tag = indexPath.item+100;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        id image = self.SelectPhoto[indexPath.item];
        
        if ([image isKindOfClass:[NSDictionary class]]) {
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:kFORMAT(@"http://jxcb.0791jr.com%@",image[@"url"])] placeholderImage:kGetImage(@"all_default_Bgimg")];
        } else {
            
            cell.imageView.image = self.SelectPhoto[indexPath.item];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.item == self.SelectPhoto.count) {
        [self AddPhotosBtnClicked];
    }else{
        [self endEditing:YES];
        
        NSMutableArray* arr = [NSMutableArray new];
        [self.SelectPhoto enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                UIImageView* imgV = [[UIImageView alloc] init];
                [imgV sd_setImageWithURL:[NSURL URLWithString:kFORMAT(@"http://jxcb.0791jr.com%@",obj[@"url"])] placeholderImage:kGetImage(@"all_default_Bgimg")];
                [arr addObject:imgV.image];
            } else {
                [arr addObject:obj];
            }
        }];
        
        [ImageBrowserViewController show:self.navClass type:PhotoBroswerVCTypeZoom index:indexPath.row imagesBlock:^NSArray *{
            return arr;
        }];
    }
}

#pragma mark - 控制添加图片的个数
-(void)AddPhotosBtnClicked
{
    if (self.SelectPhoto.count >= 9) {
//        [NSString selfAlertController:@"最多只能上传9张图片!" andUIController:self.navClass];
        [self.navClass  showAlertOnlyConfirmStyleWithTitle:@"最多只能上传9张图片!" Mesage:nil Determine:^(id determine) {
        }];
        
    }else{
        ChoosePhotos *cp = [ChoosePhotos SharedChoseImg];
//        ChoosePhotos *cp = [[ChoosePhotos alloc]init];
        cp.ExistSelectPhotos = self.SelectPhoto;
        [cp showActionSheetInFatherViewController:self.navClass delegate:self andMaxCount:9-self.SelectPhoto.count];
    }
}
#pragma mark - 选取图片的数组的代理实现
-(void)getImage:(NSMutableArray *)images andAserts:(NSMutableArray *)aserts
{
    [self.SelectPhoto addObjectsFromArray:images];
    [self.ImgCollect reloadData];
    [self DealWithDataChangeAndFrameChange];
}
#pragma mark - 删除图片的方法实现
- (void)deleteBtnClik:(UIButton *)sender
{
    if (self.deleteNetWorkImgIDBlock) {
        self.deleteNetWorkImgIDBlock(self.SelectPhoto,sender.tag);
    }
}

-(void)DealWithDataChangeAndFrameChange
{
    NSInteger totalCount = self.SelectPhoto.count + 1;
    NSInteger num = totalCount/4;
    if (totalCount % 4 > 0) {
        num += 1;
    }
    
    CGFloat TotalHeight = (IS_IPHONE_5 ? 12.5 : 15) * 2 + (num - 1)*(IS_IPHONE_5 ? 7 : 10) + num * self.ItemWidth;
    self.ImgCollect.height = TotalHeight;
    
    if (self.getImageNumBlock) {
        self.getImageNumBlock(self.SelectPhoto, TotalHeight);
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
