//
//  UIImageButton.m
//  Lhlc
//
//  Created by ancye.Xie on 16/05/03.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UIGridViewButton.h"

#define ICON_SIZE 20

@interface UIGridViewButton()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation UIGridViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
        
    }
    return self;
}

- (void)initView
{
//    self.backgroundColor = WHITE_COLOR;
//    self.layer.borderColor = COMMON_LINE_COLOR.CGColor;
    self.layer.borderWidth = 0.25;
    
    _iconImageView = [UIImageView new];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
//    _contentLabel.textColor = BLACK_COLOR;
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:12];
//    _descLabel.textColor = COMMON_GREY_WORD;
    
    
    [self addSubview:_iconImageView];
    [self addSubview:_contentLabel];
    [self addSubview:_descLabel];
    
    weakSelf(weakSelf)
    __weak __typeof(&*_iconImageView)weakIconImageView = _iconImageView;
    __weak __typeof(&*_contentLabel)weakContentLabel = _contentLabel;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(23);
        make.left.equalTo(weakSelf.mas_left).offset(34);
        make.size.mas_equalTo(CGSizeMake(ICON_SIZE, ICON_SIZE));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakIconImageView.mas_top).offset(-3);
        make.left.equalTo(weakIconImageView.mas_right).offset(15);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakContentLabel.mas_bottom).offset(5);
        make.left.equalTo(weakContentLabel.mas_left);
    }];
    
}

#pragma mark - 展示数据
- (void)showDatas:(NSString *)image title:(NSString *)title text:(NSString *)text
{
    _iconImageView.image = [UIImage imageNamed:image];
    _contentLabel.text = title;
    _descLabel.text = text;
}

@end
