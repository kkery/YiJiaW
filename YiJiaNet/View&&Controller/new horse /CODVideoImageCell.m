//
//  CODVideoImageCell.m
//  YiJiaNet
//
//  Created by KUANG on 2019/1/31.
//  Copyright © 2019年 JIARUI. All rights reserved.
//

#import "CODVideoImageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "UIImage+COD.h"

static CGFloat const kcodHeight = 220;// 顶部图高度

@interface CODVideoImageCell () <UIScrollViewDelegate>
{
    BOOL isReadToPlay;
    BOOL isEndPlay;
    BOOL isCliakVIew;
    NSInteger imgIndex;
}

@property (nonatomic,strong) UIScrollView * scrolView;
@property (nonatomic,strong) UILabel *indexLab;//当前播放页数
@property (nonatomic,strong) UIButton *videoBtn;//切换到视频
@property (nonatomic,strong) UIButton *imgBtn;//切换到图片
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation CODVideoImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        
         [self initialControlUnit];
    }
    return self;
}

-(void)initialControlUnit
{
    isEndPlay = NO;
    _scrolView = [[UIScrollView alloc]init];
    _scrolView.pagingEnabled  = YES;
    _scrolView.delegate = self;
    _scrolView.showsVerticalScrollIndicator = NO;
    _scrolView.showsHorizontalScrollIndicator = NO;
    _scrolView.userInteractionEnabled = YES;
    [self.contentView addSubview:_scrolView];
    self.scrolView.frame = CGRectMake(0, 0, SCREENWIDTH, kcodHeight);
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playShowAndHidden)];
//    [self.scrolView addGestureRecognizer:tap];
    
    _playBtn = [[UIButton alloc]init];
    _playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playBtn setImage:[UIImage imageNamed:@"icon_video"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateSelected];
    [self.contentView addSubview:_playBtn];
    self.playBtn.frame = CGRectMake((SCREENWIDTH - 60)/2.0, (kcodHeight - 60)/2.0, 60, 60);
    
    _indexLab = [[UILabel alloc]init];
    _indexLab.textColor = [UIColor whiteColor];
    _indexLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _indexLab.font = [UIFont systemFontOfSize:11];
    _indexLab.textAlignment = 1;
    _indexLab.layer.cornerRadius = 24/2;
    _indexLab.layer.masksToBounds = YES;
    [self.indexLab setHidden:YES];
    [self.contentView addSubview:self.indexLab];
    self.indexLab.frame = CGRectMake(SCREENWIDTH - 50, kcodHeight - 45, 40, 24);
    
    _videoBtn = [[UIButton alloc]init];
    [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_videoBtn setBackgroundColor:CODColorTheme];
    _videoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _videoBtn.layer.cornerRadius = 24/2;
    _videoBtn.layer.masksToBounds = YES;
    self.videoBtn.tag = 1;
    [self.contentView addSubview:_videoBtn];
    self.videoBtn.frame = CGRectMake((SCREENWIDTH/2) - 70, kcodHeight - 45, 60, 24);
    
    _imgBtn = [[UIButton alloc]init];
    [_imgBtn setTitle:@"图片" forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _imgBtn.layer.cornerRadius = 24/2;
    _imgBtn.layer.masksToBounds = YES;
    self.imgBtn.tag = 2;
    [self.contentView addSubview:_imgBtn];
    self.imgBtn.frame = CGRectMake((SCREENWIDTH/2)+ 10, kcodHeight - 45, 60, 24);
    
    
    [self.videoBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setWithIsVideo:(TSDETAILTYPE)type andDataArray:(NSArray *)array
{
    self.dataArray = array;
    
    self.scrolView.contentSize = CGSizeMake(self.dataArray.count*SCREENWIDTH, 200);
    self.type = type;
    if (type == TSDETAILTYPEVIDEO) {
        [self.playBtn setHidden:NO];
        [self.videoBtn setHidden:NO];
        [self.imgBtn setHidden:NO];
    }else{
        [self.playBtn setHidden:YES];
        [self.videoBtn setHidden:YES];
        [self.imgBtn setHidden:YES];
    }
    for (int i = 0; i < _dataArray.count; i ++) {
        if (type == TSDETAILTYPEVIDEO) {
            if (i == 0) {
                self.placeholderImg = [[UIImageView alloc] init];
                self.placeholderImg.contentMode = UIViewContentModeScaleAspectFill;
                self.placeholderImg.userInteractionEnabled = YES;
                self.placeholderImg.frame = CGRectMake(0, 0, SCREENWIDTH, kcodHeight);
                self.placeholderImg.image = kGetImage(@"place_comper_detail");

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *coverImage = [UIImage getThumImageWithVideoURL:self.dataArray[0]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (coverImage) {
                            self.placeholderImg.image = coverImage;
                        }
                    });
                });
                [self.scrolView addSubview:self.placeholderImg];
            }
            else {
                UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, kcodHeight)];
                img.userInteractionEnabled = YES;
                [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"icon_video"]];
                [self.scrolView addSubview:img];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
                [img addGestureRecognizer:tap];
//                [SVProgressHUD showWithStatus:@""];
            }
            
            if (_dataArray.count > 1) {
                self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count - 1];
                self.indexLab.hidden = YES;
                self.videoBtn.selected = YES;
                self.imgBtn.selected = NO;
            }
        }else{//全图片
            UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, kcodHeight)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"icon_video"]];
            img.userInteractionEnabled = YES;
            [self.scrolView addSubview:img];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
            [img addGestureRecognizer:tap];
            
            self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count];
            self.indexLab.hidden = NO;
            self.videoBtn.selected = YES;
            self.imgBtn.selected = YES;
        }
    }
}


#pragma mark - action
-(void)playClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPlayButtonDidClick:)]) {
        [self.delegate cellPlayButtonDidClick:self];
    }
}

- (void)changeBtnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        self.videoBtn.selected = YES;
        self.imgBtn.selected = NO;
        self.videoBtn.backgroundColor = CODColorTheme;
        self.imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        
        if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
            
            [self.scrolView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self scrollViewDidEndDecelerating:self.scrolView];
        }
    }
    else{
        if (self.dataArray.count < 2) {
            return;
        }
        self.videoBtn.selected = NO;
        self.imgBtn.selected = YES;
        
        self.videoBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.imgBtn.backgroundColor = CODColorTheme;
        if (self.scrolView.contentOffset.x < SCREENWIDTH) {
            if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
                [self.scrolView setContentOffset:CGPointMake(SCREENWIDTH, 0) animated:NO];
                [self scrollViewDidEndDecelerating:self.scrolView];
            }
        }
    }
    return;
}

-(void)imgTapClick
{
    if ([self.delegate respondsToSelector:@selector(videoView:didSelectItemAtIndexPath:)]) {
        if (self.type == TSDETAILTYPEVIDEO) {
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex];
        }else{
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex+1];
        }
    }
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    imgIndex = index;
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < SCREENWIDTH) {
            self.indexLab.hidden = YES;
            [self.playBtn setHidden:NO];
        }
        else{
            self.indexLab.hidden = NO;
            [self.playBtn setHidden:YES];
        }
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index,(int)self.dataArray.count - 1];
    }else{
        self.indexLab.hidden = NO;
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)self.dataArray.count];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < SCREENWIDTH) {
            self.videoBtn.selected = YES;
            self.imgBtn.selected = NO;
            self.videoBtn.backgroundColor = CODColorTheme;
            self.imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        } else{
            self.videoBtn.selected = NO;
            self.imgBtn.selected = YES;
            self.videoBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
            self.imgBtn.backgroundColor = CODColorTheme;
            [self.playBtn setSelected:NO];
        }
    }else{
        return;
    }
    
}

+ (CGFloat)heightForRow {
    return kcodHeight;
}
@end
