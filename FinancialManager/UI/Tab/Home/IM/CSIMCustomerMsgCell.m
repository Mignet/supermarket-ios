//
//  CSIMMsgCell.m
//  FinancialManager
//
//  Created by xnkj on 15/12/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "CSIMCustomerMsgCell.h"
#import "EMTextMessageBody.h"
#import "EMImageMessageBody.h"
#import "UIImageView+WebCache.h"
#import "UIResponder+Router.h"
#import "ConvertToCommonEmoticonsHelper.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface CSIMCustomerMsgCell()

@property (nonatomic, strong) UILabel     * timeLabel;
@property (nonatomic, strong) UIImageView * timeBgImageView;
@property (nonatomic, strong) UIView      * timeView;

@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIImageView * indicateImageView;
@property (nonatomic, strong) UIImageView * msgImageView;
@property (nonatomic, strong) UILabel     * msgLabel;
@property (nonatomic, strong) UIImageView *msgPictureImageView;
@property (nonatomic, strong) UIView      * msgView;

@property (nonatomic, strong) EMMessage *emMessage;

@end

@implementation CSIMCustomerMsgCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 刷新内容
- (void)refreshMsgContent:(EMMessage *)content avatorImageString:(NSString *)avatorImageString isService:(BOOL)isService
{
    @autoreleasepool{
        self.emMessage = content;
        
        [self.timeView removeFromSuperview];
        [self.headerImageView removeFromSuperview];
        [self.msgView removeFromSuperview];
        
        [self.contentView addSubview:self.timeView];
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.msgView];
        
        //是客服，则显示客服的默认头像
        if (isService)
        {
            [self.headerImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"XN_CS_IM_Chat_Service_Avator.png"]];
        }
        else
        {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[_LOGIC getImagePathUrlWithBaseUrl:avatorImageString]] placeholderImage:[UIImage imageNamed:@"XN_CS_IM_Chat_CustomerHeaderImg.png"]];
        }
        
        self.height = 0.0f;
        
        [self.timeLabel setText:[NSString stringFromDate:[NSDate dateWithTimeIntervalSince1970:(content.timestamp / 1000)] formater:@"YYYY-MM-dd HH:mm:ss"]];
        [self.timeLabel sizeToFit];
        CGSize timeSize = self.timeLabel.frame.size;
        
        
        __weak UIView * tmpView = self.contentView;
        [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(tmpView.mas_top).offset(16);
            make.centerX.mas_equalTo(tmpView.mas_centerX);
            make.width.mas_equalTo(timeSize.width + 12);
            make.height.mas_equalTo(@(18));
        }];
        
        [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(12);
            make.top.mas_equalTo(tmpView.mas_top).offset(36 + 16);
            make.width.mas_equalTo(@(32));
            make.height.mas_equalTo(@(32));
        }];
        
        EMMessageBody * msgBody = content.body;
        CGSize size;
        //文字
        if (msgBody.type == EMMessageBodyTypeText)
        {
            self.msgPictureImageView.hidden = YES;
            self.msgLabel.hidden = NO;
        
            EMTextMessageBody *chatText = (EMTextMessageBody *)content.body;
            //表情映射
            NSString *contentString = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:[chatText text]];
            
            [self.msgLabel setText:contentString];
            size = [self.msgLabel sizeThatFits:CGSizeMake(SCREEN_FRAME.size.width - 138, 2000)];
        }
        else if(msgBody.type == EMMessageBodyTypeImage)
        {
            self.msgPictureImageView.hidden = NO;
            self.msgLabel.hidden = YES;
            //图片
            EMImageMessageBody *imageBody = (EMImageMessageBody *)content.body;
            
            NSURL *url = [NSURL URLWithString:imageBody.remotePath];
            [self.msgPictureImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"XN_CS_IM_Chat_Default_image.png"]];
            
            size = [self heightForImageWithOrgSize:imageBody.size];
        }

        [self.msgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(50);
            make.top.mas_equalTo(tmpView.mas_top).offset(34 + 16);
            make.width.mas_equalTo(size.width + 29);
            make.height.mas_equalTo(size.height + 24);
        }];
        
        self.height = 50 + size.height + 24 + 16;
    }
}

//图片高度
- (CGSize)heightForImageWithOrgSize:(CGSize)orgSize
{
    CGSize size = orgSize;
    
    if (size.width <= IMAGE_SIZE && size.height <= IMAGE_SIZE)
    {
        return size;
    }
    
    if (size.width == 0 || size.height == 0)
    {
        size.width = IMAGE_SIZE;
        size.height = IMAGE_SIZE;
    }
    else if (size.width > size.height)
    {
        CGFloat height =  IMAGE_SIZE / size.width  *  size.height;
        size.height = height;
        size.width = IMAGE_SIZE;
    }
    else
    {
        CGFloat width = IMAGE_SIZE / size.height * size.width;
        size.width = width;
        size.height = IMAGE_SIZE;
    }
    
    return size;
}

////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)pictureViewPressed:(id)sender
{
    [self routerEventWithName:XN_ROUTER_EVENT_CHAT_PICTURE_TAP userInfo:@{XN_INTERACTION_MESSAGE:self.emMessage}];
}

////////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - timeLabel
- (UILabel * )timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:9]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_timeLabel setTextColor:[UIColor whiteColor]];
    }
    return _timeLabel;
}

#pragma mark - timeBgImageView
- (UIImageView *)timeBgImageView
{
    if (!_timeBgImageView) {
        
        _timeBgImageView = [[UIImageView alloc]init];
        [_timeBgImageView setImage:[UIImage imageNamed:@"XN_CS_IM_Time_bg.png"]];
        [_timeBgImageView.layer setMasksToBounds:YES];
        [_timeBgImageView.layer setCornerRadius:2.5f];
    }
    return _timeBgImageView;
}

#pragma mark - timeView
- (UIView *)timeView
{
    if (!_timeView) {
        
        _timeView = [[UIView alloc]init];
        
        [_timeView addSubview:self.timeBgImageView];
        [_timeView addSubview:self.timeLabel];
        
        __weak UIView * tmpView = _timeView;
        [self.timeBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpView);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tmpView);
        }];
    }
    return _timeView;
}

#pragma mark - headerImageView
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        
        _headerImageView = [[UIImageView alloc]init];
        [_headerImageView setImage:[UIImage imageNamed:@"XN_CS_IM_Chat_CustomerHeaderImg.png"]];
    }
    return _headerImageView;
}

#pragma mark - indicateImageView
- (UIImageView *)indicateImageView
{
    if (!_indicateImageView) {
        
        _indicateImageView = [[UIImageView alloc]init];
        [_indicateImageView setImage:[UIImage imageNamed:@"XN_CS_IM_Chat_CustomerAnswer_left_bg.png"]];
    }
    return _indicateImageView;
}

#pragma mark - contentImageView
- (UIImageView *)msgImageView
{
    if (!_msgImageView) {
        
        _msgImageView = [[UIImageView alloc]init];
        [_msgImageView setImage:[UIImage imageNamed:@"XN_CS_IM_Chat_CustomerAsk_bg.png"]];
        [_msgImageView.layer setMasksToBounds:YES];
        [_msgImageView.layer setCornerRadius:5.0f];
    }
    return _msgImageView;
}

#pragma mark - contentLabel
- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        
        _msgLabel = [[UILabel alloc]init];
        [_msgLabel setTextColor:[UIColor whiteColor]];
        [_msgLabel setFont:[UIFont systemFontOfSize:12]];
        _msgLabel.numberOfLines = 0;
        _msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _msgLabel;
}

#pragma mark - msgPictureImageView
- (UIImageView *)msgPictureImageView
{
    if (!_msgPictureImageView)
    {
        _msgPictureImageView = [[UIImageView alloc] init];
        [_msgPictureImageView.layer setMasksToBounds:YES];
        [_msgPictureImageView.layer setCornerRadius:5.0f];
        _msgPictureImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewPressed:)];
        [_msgPictureImageView addGestureRecognizer:tapGesture];
    }
    return _msgPictureImageView;
}

#pragma mark - contentView
- (UIView *)msgView
{
    if (!_msgView) {
        
        _msgView = [[UIView alloc]init];
        
        [_msgView addSubview:self.indicateImageView];
        [_msgView addSubview:self.msgImageView];
        [_msgView addSubview:self.msgLabel];
        [_msgView addSubview:self.msgPictureImageView];
        
        __weak UIView * tmpView = _msgView;
        [self.indicateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading);
            make.top.mas_equalTo(tmpView.mas_top).offset(12);
            make.width.mas_equalTo(@(5));
            make.height.mas_equalTo(@(7));
        }];
        
        [self.msgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(3);
            make.top.mas_equalTo(tmpView.mas_top);
            make.trailing.mas_equalTo(tmpView.mas_trailing);
            make.bottom.mas_equalTo(tmpView.mas_bottom);
        }];
        
        [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(17);
            make.top.mas_equalTo(tmpView.mas_top).offset(12);
            make.trailing.mas_equalTo(tmpView.mas_trailing).offset(-12);
            make.bottom.mas_equalTo(tmpView.mas_bottom).offset(-12);
        }];
        
        [self.msgPictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(tmpView.mas_leading).offset(3.5);
            make.top.mas_equalTo(tmpView.mas_top).offset(0.5);
            make.trailing.mas_equalTo(tmpView.mas_trailing).offset(-0.5);
            make.bottom.mas_equalTo(tmpView.mas_bottom).offset(-0.5);
        }];

    }
    
    return _msgView;
}

@end
