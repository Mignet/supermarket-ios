//
//  AccountCenterCell.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "AccountCenterCell.h"
#import "UIView+CornerRadius.h"

@interface AccountCenterCell()

@property (nonatomic, weak) IBOutlet UIView *contentsView;
@property (nonatomic, weak) IBOutlet UIImageView * iconImageView;
@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel     * descLabel;
@property (nonatomic, weak) IBOutlet UIImageView * headerImageView;

@property (nonatomic, weak) IBOutlet UIView *exitView;
@property (nonatomic, weak) IBOutlet UILabel *exitLabel;

@property (nonatomic, strong) UILabel     * upLineLabel;
@property (nonatomic, strong) UILabel     * bottomLineLabel;
@end

@implementation AccountCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更新内容
- (void)updateContent:(NSDictionary *)params AtIndex:(NSInteger )index TotalIndex:(NSInteger )totalIndex
{
    self.contentsView.hidden = NO;
    self.exitView.hidden = YES;
    __weak UIView * tmpView = self.contentView;
    if (index == 0)
    {
        [self.contentView addSubview:self.upLineLabel];
        [self.upLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.top.trailing.equalTo(tmpView);
            make.height.mas_equalTo(@(0.5));
        }];
    }
    
    [self.contentView addSubview:self.bottomLineLabel];
    [self.bottomLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpView.mas_leading).offset(24);
        make.trailing.equalTo(tmpView);
        make.bottom.mas_equalTo(tmpView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(@(0.5));
        make.width.mas_equalTo(SCREEN_FRAME.size.width - 24);
    }];
    
    [self.titleLabel setText:[params objectForKey:@"title"]];
    
    [self.iconImageView setHidden:NO];
    if ([[params objectForKey:@"IconHide"] boolValue])[self.iconImageView setHidden:YES];
    
    [self.headerImageView setHidden:YES];
    [self.descLabel setText:[params objectForKey:@"valueTitle"]];
    [self.descLabel setTextColor:[params objectForKey:@"color"]];
    
    
    if (index == totalIndex - 1)
    {
        self.contentsView.hidden = YES;
        self.exitView.hidden = NO;
        [self.exitLabel setText:[params objectForKey:@"title"]];
        
        [self.bottomLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.trailing.equalTo(tmpView);
            make.bottom.mas_equalTo(tmpView.mas_bottom).offset(0.5);
            make.height.mas_equalTo(@(0.5));
        }];
    }
    
    

}

//////////////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - upLineLabel
- (UILabel *)upLineLabel
{
    if (!_upLineLabel) {
        
        _upLineLabel = [[UILabel alloc]init];
        [_upLineLabel setBackgroundColor:UIColorFromHex(0xe9e9e9)];
    }
    return _upLineLabel;
}

#pragma mark - bottomLineLabel
- (UILabel *)bottomLineLabel
{
    if (!_bottomLineLabel) {
        
        _bottomLineLabel = [[UILabel alloc]init];
        [_bottomLineLabel setBackgroundColor:UIColorFromHex(0xe9e9e9)];
    }
    return _bottomLineLabel;
}
@end
