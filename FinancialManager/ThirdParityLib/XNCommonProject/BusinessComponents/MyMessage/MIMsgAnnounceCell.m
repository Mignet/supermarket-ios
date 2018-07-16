//
//  CSPurchaseCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIMsgAnnounceCell.h"

#import "XNCommonMsgItemMode.h"

@interface MIMsgAnnounceCell()

@property (nonatomic, strong) UILabel        * upSeperatorLineLabel;
@property (nonatomic, strong) UILabel        * downSeperatorLineLabel;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;;
@property (nonatomic, weak) IBOutlet UILabel * timeLabel;
@end

@implementation MIMsgAnnounceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新内容
- (void)updateContent:(XNCommonMsgItemMode *)params firstCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell
{
    
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.timeLabel setTextColor:[UIColor blackColor]];
    if (params.isRead) {
        
        [self.titleLabel setTextColor:UIColorFromHex(0xc8c8c8)];
        [self.timeLabel setTextColor:UIColorFromHex(0xc8c8c8)];
    }
    
    [self.titleLabel setText:params.content];
    [self.timeLabel setText:params.startTime];
    
    [self.upSeperatorLineLabel removeFromSuperview];
    [self.downSeperatorLineLabel removeFromSuperview];
    
    weakSelf(weakSelf)
    if (isFirstCell) {
        
        [self.contentView addSubview:self.upSeperatorLineLabel];
        
        [self.upSeperatorLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(weakSelf.contentView.mas_leading);
            make.trailing.mas_equalTo(weakSelf.contentView.mas_trailing);
            make.top.mas_equalTo(weakSelf.contentView.mas_top);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    [self.contentView addSubview:self.downSeperatorLineLabel];
    
    [self.downSeperatorLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.contentView.mas_leading).offset(isLastCell?0:24);
        make.trailing.mas_equalTo(weakSelf.contentView.mas_trailing);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(0.5);
    }];
}

//////////////
#pragma mark - setter/getter
/////////////////////////////////

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
