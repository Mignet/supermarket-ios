//
//  AccountCenterCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIPasswordManageCell.h"

@interface MIPasswordManageCell()

@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) UILabel     * upLineLabel;
@property (nonatomic, strong) UILabel     * bottomLineLabel;
@end

@implementation MIPasswordManageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 更新内容
- (void)updateContent:(NSString *)params desc:(NSString *)descString AtIndex:(NSInteger )index TotalIndex:(NSInteger )totalIndex
{
    __weak UIView * tmpView = self.contentView;
    
    if (index == 0) {
        [self.contentView addSubview:self.upLineLabel];
        [self.upLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.top.trailing.equalTo(tmpView);
            make.height.mas_equalTo(@(0.5));
        }];
    }
    
    [self.contentView addSubview:self.bottomLineLabel];
    [self.bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpView.mas_leading).offset(24);
        make.trailing.equalTo(tmpView);
        make.bottom.mas_equalTo(tmpView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(@(0.5));
        make.width.mas_equalTo(SCREEN_FRAME.size.width - 24);
    }];
    
    if (index == totalIndex - 1) {
        
        [self.bottomLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.trailing.equalTo(tmpView);
            make.bottom.mas_equalTo(tmpView.mas_bottom).offset(0.5);
            make.height.mas_equalTo(@(0.5));
        }];
    }
    
    [self.titleLabel setText:params];
    self.descLabel.text = descString;
}

//////////////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - upLineLabel
- (UILabel *)upLineLabel
{
    if (!_upLineLabel) {
        
        _upLineLabel = [[UILabel alloc]init];
        [_upLineLabel setBackgroundColor:UIColorFromHex(0xdcdcdc)];
    }
    return _upLineLabel;
}

#pragma mark - bottomLineLabel
- (UILabel *)bottomLineLabel
{
    if (!_bottomLineLabel) {
        
        _bottomLineLabel = [[UILabel alloc]init];
        [_bottomLineLabel setBackgroundColor:UIColorFromHex(0xdcdcdc)];
    }
    return _bottomLineLabel;
}
@end
