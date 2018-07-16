//
//  ProductHomeSectionView.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/27/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "ProductHomeSectionView.h"

@interface ProductHomeSectionView ()

@property (nonatomic, strong) UILabel *sepLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UILabel *bottomSepLabel;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation ProductHomeSectionView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.sepLabel];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.iconImageView];
        [self.bottomView addSubview:self.titleLabel];
        [self.bottomView addSubview:self.moreLabel];
        [self.bottomView addSubview:self.moreImageView];
        [self.bottomView addSubview:self.bottomSepLabel];
        [self.bottomView addSubview:self.moreButton];
        
        weakSelf(weakSelf)
        __weak UILabel *weakSepLabel = self.sepLabel;
        __weak UIView *weakBottomView = self.bottomView;
        __weak UIImageView *weakIconImageView = self.iconImageView;
        __weak UIImageView *weakMoreImageView = self.moreImageView;
        
        [self.sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left);
            make.right.mas_equalTo(weakSelf.contentView.mas_right);
            make.top.mas_equalTo(weakSelf.contentView.mas_top);
            make.height.mas_equalTo(0.5);
            
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left);
            make.right.mas_equalTo(weakSelf.contentView.mas_right);
            make.top.mas_equalTo(weakSepLabel.mas_bottom);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakBottomView.mas_left).offset(15);
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakIconImageView.mas_right).offset(6);
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
            make.height.mas_equalTo(21);
        }];
        
        [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
            make.right.mas_equalTo(weakBottomView.mas_right).offset(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(14);
        }];
        
        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakBottomView.mas_centerY);
            make.right.mas_equalTo(weakMoreImageView.mas_left).offset(-6);
            make.height.mas_equalTo(15);
        }];
        
        [self.bottomSepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakBottomView.mas_left);
            make.right.mas_equalTo(weakBottomView.mas_right);
            make.bottom.mas_equalTo(weakBottomView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakBottomView);
        }];
    }
    
    return self;
}

- (void)showSectionIcon:(NSString *)iconName title:(NSString *)title moreTitle:(NSString *)moreTitle clickMore:(clickMore)more
{
    self.moreImageView.hidden = YES;
    if (more)
    {
        self.moreImageView.hidden = NO;
        self.moreOption = nil;
        self.moreOption = [more copy];
    }
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = title;
    self.moreLabel.text = moreTitle;
}

- (void)clickMore
{
    if (self.moreOption)
    {
        self.moreOption();
    }
}

/////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - sepLabel
- (UILabel *)sepLabel
{
    if (!_sepLabel)
    {
        _sepLabel = [[UILabel alloc] init];
        _sepLabel.backgroundColor = JFZ_LINE_COLOR_GRAY;
    }
    return _sepLabel;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

#pragma mark -iconImageView
- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
 
#pragma mark -titleLabel
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHex(0x3e4446);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

#pragma mark - moreLabel
- (UILabel *)moreLabel
{
    if (!_moreLabel)
    {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.textColor = UIColorFromHex(0xa2a2a2);
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.font = [UIFont systemFontOfSize:12];
    }
    return _moreLabel;
}

#pragma mark -moreImageView
- (UIImageView *)moreImageView
{
    if (!_moreImageView)
    {
        _moreImageView = [[UIImageView alloc] init];
        _moreImageView.image = [UIImage imageNamed:@"XN_MyInfo_AccountManager_go_icon_in"];
    }
    return _moreImageView;
}

#pragma mark -bottomSepLabel
- (UILabel *)bottomSepLabel
{
    if (!_bottomSepLabel)
    {
        _bottomSepLabel = [[UILabel alloc] init];
        _bottomSepLabel.backgroundColor = JFZ_LINE_COLOR_GRAY;
    }
    return _bottomSepLabel;
}

#pragma mark - moreButton
- (UIButton *)moreButton
{
    if (!_moreButton)
    {
        _moreButton = [[UIButton alloc]init];
        [_moreButton setBackgroundColor:[UIColor clearColor]];
        [_moreButton addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
