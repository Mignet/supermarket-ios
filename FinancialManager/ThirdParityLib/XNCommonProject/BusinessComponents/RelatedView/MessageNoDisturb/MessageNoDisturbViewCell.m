//
//  MessageNoDisturbViewCell.m
//  Lhlc
//
//  Created by ancye.Xie on 3/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MessageNoDisturbViewCell.h"

@interface MessageNoDisturbViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, assign) BOOL isPlatformflag; //平台消息免打扰是否开启：0-不开启 1-开启免打扰

@end

@implementation MessageNoDisturbViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //初始化
        [self initView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    
    _switchButton = [UIButton new];
    _switchButton.selected = NO;
    [_switchButton setImage:[UIImage imageNamed:@"XN_Off_icon"] forState:UIControlStateNormal];
    [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor blackColor];//UIColorFromHex(0x969696);
    _descLabel.backgroundColor = UIColorFromHex(0xeeeff3);
    _descLabel.text = @"      开启后,收到平台通知时您的手机将不会震动与发出提示音";
    
    [self addSubview:_titleLabel];
    [self addSubview:_switchButton];
    [self addSubview:_descLabel];
    
    weakSelf(weakSelf)
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(24);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(49);
    }];
    
    __weak UILabel *weakTitleLabel = _titleLabel;
    
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakTitleLabel.mas_centerY).offset(2);
        make.right.equalTo(weakSelf.mas_right).offset(- 12);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(35);
    }];
    
    float fHeight = 28;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakTitleLabel.mas_bottom);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo(fHeight + 5);
    }];
    
}

- (void)showDatas:(NSInteger)nRow title:(NSString *)titleString isOpenMsgNoDisturb:(BOOL)isOpenMsgNoDisturb
{
    _titleLabel.text = titleString;
    _switchButton.tag = nRow;
    _switchButton.selected = isOpenMsgNoDisturb;
    _isPlatformflag = isOpenMsgNoDisturb;
    
    if (_switchButton.selected)
    {
        [_switchButton setImage:[UIImage imageNamed:@"XN_On_icon"] forState:UIControlStateNormal];
    }
    else
    {
        [_switchButton setImage:[UIImage imageNamed:@"XN_Off_icon"] forState:UIControlStateNormal];
    }

    
}

- (void)switchButtonClick:(id)sender
{
    UIButton *btn = sender;
    NSLog(@"btn.tag:%ld", btn.tag);
    _switchButton.selected = !_switchButton.selected;
    if (_switchButton.selected)
    {
        [_switchButton setImage:[UIImage imageNamed:@"XN_On_icon"] forState:UIControlStateNormal];
    }
    else
    {
        [_switchButton setImage:[UIImage imageNamed:@"XN_Off_icon"] forState:UIControlStateNormal];
    }
    _isPlatformflag = _switchButton.selected;

    if ([_delegate respondsToSelector:@selector(switchButtonPressed:isPlatformflag:)])
    {
        [_delegate switchButtonPressed:btn.tag isPlatformflag:_isPlatformflag];
    }
    
}

@end
