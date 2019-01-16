//
//  MessageTypeTableViewCell.m
//  YiJiaNet
//
//  Created by KUANG on 2018/12/27.
//  Copyright © 2018年 JIARUI. All rights reserved.
//

#import "MessageTypeTableViewCell.h"
#import "UIView+COD.h"

@interface MessageTypeTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *detailLable;

@property (nonatomic, strong) UILabel *badgeView;

@end

@implementation MessageTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        [self.contentView addSubview:self.iconImageView];
        
        self.titleLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor333333;
            label.font = kFont(17);
            label;
        });
        [self.contentView addSubview:self.titleLable];
        
        self.detailLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = CODColor999999;
            label.font = kFont(12);
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.contentView addSubview:self.detailLable];

        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.offset(0);
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
        }];
        [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)setType:(MessageType)type{
    _type = type;
    NSString *imageName, *titleStr;
    switch (_type) {
        case MessageTypeSystem:
            imageName = @"message_system";
            titleStr = @"系统消息";
            break;
        case MessageTypeOrder:
            imageName = @"message_appointment";
            titleStr = @"预约消息";
            break;
        case MessageTypeActivity:
            imageName = @"message_appointment";
            titleStr = @"活动消息";
            break;
        default:
            break;
    }
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.titleLable.text = titleStr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSString *badgeTip = @"";
    if (_unreadCount > 0) {
        if (_unreadCount > 99) {
            badgeTip = @"99+";
        } else {
            badgeTip = kFORMAT(@"%@",@(_unreadCount));
        }
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
    
        self.detailLable.text = @"暂无数据";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self.contentView addBadgeTip:badgeTip withCenterPosition:CGPointMake(SCREENWIDTH-25, 40)];
}

+ (CGFloat)heightForRow {
    return 80;
}

//- (void)setFrame:(CGRect)frame {
//    frame.origin.y += 10;
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}

@end
