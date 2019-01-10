//
//  CODAnnouncementCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/24.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "CODAnnouncementCell.h"

#import "SGAdvertScrollView.h"

@interface CODAnnouncementCell()<SGAdvertScrollViewDelegate>

/** 公告资讯滚动视图 */
@property (nonatomic,strong)SGAdvertScrollView *notice_scroll;

@end

@implementation CODAnnouncementCell

+ (CODAnnouncementCell *)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier
{
    static NSString *ID = @"HPAnnouncementCellIdentifier";
    CODAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ? identifier : ID];
    if (cell == nil) {
        cell = [[CODAnnouncementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ? identifier : ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //80
        [self setMainUI];
        
    }return self;
}

-(void)setMainUI{
   
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = kGetImage(@"home_headlines_bg");
//    backImageView.backgroundColor = CODColorTheme;
    [self.contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.offset(-12);
        make.height.equalTo(@51);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:kGetImage(@"home_headlines")];
    [backImageView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView);
        make.left.equalTo(backImageView.mas_left).offset(10);
        make.width.equalTo(@35);
        make.height.equalTo(@15);
    }];
    
    self.notice_scroll = [[SGAdvertScrollView alloc] initWithFrame:CGRectZero];
    self.notice_scroll.advertScrollViewStyle = SGAdvertScrollViewStyleNormal;
    self.notice_scroll.titleFont = kFont(14);
    self.notice_scroll.titleColor = CODColor333333;
    //一行文字滚动
//    self.notice_scroll.signImages = @[@"hp_notice_point", @"hp_notice_point", ];
//    self.notice_scroll.titles = @[@"你敢信吗？中国35个大城市有12个存在楼市泡...",@"你敢信吗？中国35个大城市有12个存在楼市泡..."];
    
    self.notice_scroll.scrollTimeInterval = 3.0;
    
    [self.notice_scroll setDelegate:self];
    
    [backImageView addSubview:self.notice_scroll];
    
    [self.notice_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView);
        make.left.equalTo(icon.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.equalTo(@40);
    }];
}

-(void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index{
    if (self.NoticeScrollBlock) {
        self.NoticeScrollBlock(advertScrollView, index);
    }
}

- (void)setNewstitles:(NSMutableArray *)newstitles {
    _newstitles = newstitles;
    self.notice_scroll.titles = newstitles;
}
- (void)setNewstitlesIcons:(NSMutableArray *)newstitlesIcons {
    _newstitlesIcons = newstitlesIcons;
    self.notice_scroll.signImages = newstitlesIcons;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForRow {
    return 50;
}

@end
