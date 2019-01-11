//
//  StoreGoodsCommentCell.m
//  WGC
//
//  Created by Tang on 2018/4/12.
//  Copyright © 2018年 EndureTang. All rights reserved.
//

#import "StoreGoodsCommentCell.h"

#import "CommonImageCollectVW.h"

#import "MyCommentImfoMode.h"
#import "StarEvaluationView.h"

@interface StoreGoodsCommentCell()

/** 头像 */
@property (nonatomic,strong)UIImageView *headIcon;
/** 昵称 */
@property (nonatomic,strong)UILabel *nameLab;
/** 时间 */
@property (nonatomic,strong)UILabel *timeLab;
/** 评价内容 */
@property (nonatomic,strong)UILabel *contentLab;
/** 图片集合视图 */
@property (nonatomic,strong)CommonImageCollectVW *imgVW;

/** 星级视图 */
@property (nonatomic,strong) StarEvaluationView *starVW;

@end

@implementation StoreGoodsCommentCell

+ (StoreGoodsCommentCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier
{
    static NSString *ID = @"StoreGoodsCommentCellIdentifier";
    StoreGoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ? identifier : ID];
    if (cell == nil) {
        cell = [[StoreGoodsCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ? identifier : ID];
        kCellNoneSelct(cell);
    }
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initVariable];
        [self setMainUI];
        
    }return self;
}

-(void)initVariable{
    self.headIcon = [UIImageView getImageViewWithFrame:CGRectZero andImage:kGetImage(@"place_default_avatar") andBgColor:nil];
    self.nameLab = [UILabel GetLabWithFont:kFont(15) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
    self.timeLab = [UILabel GetLabWithFont:kFont(14) andTitleColor:CODHexColor(0x919191) andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
    self.contentLab = [UILabel GetLabWithFont:kFont(16) andTitleColor:CODColor333333 andTextAligment:NSTextAlignmentLeft andBgColor:nil andlabTitle:nil];
    [self.contentLab setNumberOfLines:0];
    
    self.imgVW = [[CommonImageCollectVW alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    self.imgVW.height = self.imgVW.bounds.size.height;
    
    self.starVW = [StarEvaluationView evaluationViewWithChooseStarBlock:^(StarEvaluationView *starview, NSUInteger count) {
        
    }];
    self.starVW.spacing = 0.1;
    self.starVW.starCount = 0;
    self.starVW.tapEnabled = NO;
    
}

-(void)setMainUI{
    self.headIcon.frame = CGRectMake(15, 15, 40, 40);
    [self.headIcon setLayWithCor:20 andLayerWidth:0 andLayerColor:nil];
    [self addSubview:self.headIcon];
    
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame)+8, 15,SCREENWIDTH - CGRectGetMaxX(self.headIcon.frame)+8, 15);
    [self addSubview:self.nameLab];
    
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame)+8, CGRectGetMaxY(self.nameLab.frame) + 5,80, 15);
    [self addSubview:self.timeLab];
    
    self.contentLab.frame = CGRectMake(15, CGRectGetMaxY(self.timeLab.frame) + 12, SCREENWIDTH - 30, [self getCurentLabelTestHieght:self.contentLab].height);
    [self addSubview:self.contentLab];
    
    self.imgVW.y = CGRectGetMaxY(self.contentLab.frame) + 18;
    [self addSubview:self.imgVW];
    
    [self addSubview:self.starVW];
    [self.starVW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.nameLab.mas_bottom);
        make.width.offset(75);
        make.height.offset(20);
    }];
}

#pragma mark - Private Func
-(CGSize )getCurentLabelTestWidth:(UILabel *)lab{
    CGSize textSize = kGetTextSize(lab.text,MAXFLOAT, 20, lab.font.pointSize);
    return textSize;
}

-(CGSize )getCurentLabelTestHieght:(UILabel *)lab{
    CGSize textSize = kGetTextSize(lab.text,SCREENWIDTH - 30,MAXFLOAT, lab.font.pointSize);
    return textSize;
}

#pragma mark - setter
-(void)setImfo_mode:(MyCommentImfoMode *)imfo_mode
{
    _imfo_mode = imfo_mode;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kFORMAT(@"%@",imfo_mode.avatar)]] placeholderImage:kGetImage(@"place_default_avatar")];
    self.nameLab.text = kFORMAT(@"%@",imfo_mode.nickname);
    self.timeLab.text = kFORMAT(@"%@",imfo_mode.add_time);
    self.starVW.starCount = [kFORMAT(@"%@",imfo_mode.score) intValue];
    self.contentLab.text = kFORMAT(@"%@",imfo_mode.content);
    self.contentLab.height = [self getCurentLabelTestHieght:self.contentLab].height;
    
    self.imgVW.y = CGRectGetMaxY(self.contentLab.frame) + 15;
    //TODO评论图片赋值
//    NSMutableArray *ImgArr = [NSMutableArray new];
//    [ImgArr removeAllObjects];
//    [imfo_mode.images enumerateObjectsUsingBlock:^(NSMutableDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [ImgArr addObject:obj[@"url"]];
//    }];
    self.imgVW.imgArr = imfo_mode.images;
    imfo_mode.rowHeight = CGRectGetMaxY(self.imgVW.frame) + 10;
    
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
