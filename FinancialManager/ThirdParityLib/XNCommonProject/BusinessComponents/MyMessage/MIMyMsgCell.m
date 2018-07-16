//
//  CSRedeemCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIMyMsgCell.h"

#import "XNPrivateMsgItemMode.h"

@interface MIMyMsgCell()

@property (nonatomic, strong) UILabel        * timeLabel;
@property (nonatomic, strong) UILabel        * contentLabel;
@property (nonatomic, strong) UILabel        * upSeperatorLineLabel;
@property (nonatomic, strong) UILabel        * downSeperatorLineLabel;

@property (nonatomic, weak) IBOutlet UIImageView * selectImageView;
@property (nonatomic, weak) IBOutlet UIView  * containerView;
@end

@implementation MIMyMsgCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.upSeperatorLineLabel];
    [self.contentView addSubview:self.downSeperatorLineLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContent:(XNPrivateMsgItemMode *)params isSelected:(BOOL)selected canEdit:(BOOL)edited firstCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell
{
    
    [self.timeLabel setText:params.startTime];
    [self.contentLabel setText:params.content];
    [self.timeLabel setTextColor:[UIColor blackColor]];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    if (params.isRead) {
        
        [self.timeLabel setTextColor:UIColorFromHex(0xc8c8c8)];
        [self.contentLabel setTextColor:UIColorFromHex(0xc8c8c8)];
    }
    
    [self.selectImageView setHidden:edited?NO:YES];
    [self.selectImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_unChecked.png"]];
    if (selected) {
        
        [self.selectImageView setImage:[UIImage imageNamed:@"XN_Home_Invite_checked.png"]];
    }

    if (isFirstCell) {
       
        [self.upSeperatorLineLabel setHidden:NO];
    }else
    {
        [self.upSeperatorLineLabel setHidden:YES];
    }

    //开始进行约束
    [self layoutView:params canEdit:edited firstCell:isFirstCell lastCell:isLastCell];
}

#pragma mark - 进行layout
- (void)layoutView:(XNPrivateMsgItemMode *)params canEdit:(BOOL)edited firstCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell
{
    __weak UIView * tmpView = self.containerView;
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if (edited) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(58);
        }else
        {
            make.leading.mas_equalTo(tmpView.mas_leading).offset(24);
        }
        
        make.top.mas_equalTo(tmpView.mas_top).offset(12);
        make.trailing.mas_equalTo(tmpView.mas_trailing).offset(-12);
        make.height.mas_equalTo(18);
    }];
    
    __weak UILabel * tmpTimeLabel = self.timeLabel;
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if (edited) {
            
            make.leading.mas_equalTo(tmpView.mas_leading).offset(58);
        }else
            make.leading.mas_equalTo(tmpView.mas_leading).offset(24);
        make.trailing.mas_equalTo(tmpView.mas_trailing).offset(-12);
        make.top.mas_equalTo(tmpTimeLabel.mas_bottom);
        make.bottom.mas_equalTo(tmpView.mas_bottom).offset(- 2);
    }];

    if (isFirstCell) {
        
        [self.upSeperatorLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpView.mas_leading);
            make.trailing.mas_equalTo(tmpView.mas_trailing);
            make.top.mas_equalTo(tmpView.mas_top);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    [self.downSeperatorLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpView.mas_leading).offset(isLastCell?0:24);
        make.trailing.mas_equalTo(tmpView.mas_trailing);
        make.bottom.mas_equalTo(tmpView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(0.5);
    }];
}

///////////////////
#pragma mark - setter/getter
/////////////////////////////////////////////

#pragma mark - timeLabel
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _timeLabel;
}

#pragma makr - contentLabel
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
    
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        if (IOS10_OR_LATER) {
            
            [_contentLabel setAdjustsFontForContentSizeCategory:YES];
        }
    }
    return _contentLabel;
}

#pragma mark - upSeperatorLineLabel
- (UILabel *)upSeperatorLineLabel
{
    if (!_upSeperatorLineLabel) {
        
        _upSeperatorLineLabel = [[UILabel alloc]init];
        [_upSeperatorLineLabel setBackgroundColor:UIColorFromHex(0xc8c8c8)];
    }
    return _upSeperatorLineLabel;
}

#pragma mark - upSeperatorLineLabel
- (UILabel *)downSeperatorLineLabel
{
    if (!_downSeperatorLineLabel) {
        
        _downSeperatorLineLabel = [[UILabel alloc]init];
        [_downSeperatorLineLabel setBackgroundColor:UIColorFromHex(0xc8c8c8)];
    }
    return _downSeperatorLineLabel;
}

@end
