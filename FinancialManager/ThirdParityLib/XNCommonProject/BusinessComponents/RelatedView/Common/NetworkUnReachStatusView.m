//
//  NetworkUnReachStatusView.m
//  FinancialManager
//
//  Created by xnkj on 10/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "NetworkUnReachStatusView.h"

@interface NetworkUnReachStatusView()

@property (nonatomic, strong) UIImageView * statusImageView;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UILabel     * subTitleLabel;
@property (nonatomic, strong) UIButton    * touchButton;
@end

@implementation NetworkUnReachStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:UIColorFromHex(0xefefef)];
    
        [self addSubview:self.statusImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.touchButton];
        
        weakSelf(weakSelf)
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(weakSelf);
            make.height.mas_equalTo(@(21));
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
        }];
        
        __weak UILabel * tmpTitleLabel = self.titleLabel;
        [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf);
            make.bottom.mas_equalTo(tmpTitleLabel.mas_top);
            make.width.mas_equalTo(@(110.5));
            make.height.mas_equalTo(@(121.5));
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(tmpTitleLabel.mas_bottom);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(21));
        }];
       
        __weak UILabel * tmpSubTitleLabel = self.subTitleLabel;
        [self.touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(tmpSubTitleLabel.mas_bottom).offset(12);
            make.width.mas_equalTo(@(87));
            make.height.mas_equalTo(@(27));
        }];
    }
    return self;
}

//设置重试网络块
- (void)setNetworkRetryOperation:(RetryNetworkBlock)block
{
    if (block) {
        
        self.retryNetworkBlock = block;
    }
}

//设置图片和标题
- (void)setNetworkUnReachStatusImage:(NSString *)iconName title:(NSString *)title
{
    [self.statusImageView setImage:[UIImage imageNamed:iconName]];
    [self.titleLabel setText:title];
}

//点击重试
- (void)retryNetwork
{
    if (self.retryNetworkBlock) {
        
        self.retryNetworkBlock();
    }
}

//////////////
#pragma mark - setter/getter
//////////////////////////////////

- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        
        _statusImageView = [[UIImageView alloc]init];
        [_statusImageView setImage:[UIImage imageNamed:@"network_error.png"]];
    }
    return _statusImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:UIColorFromHex(0x999999)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:@"网络加载失败"];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc]init];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [_subTitleLabel setTextColor:UIColorFromHex(0xc1c0c0)];
        [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_subTitleLabel setText:@"请再次刷新或检查网络"];
    }
    return _subTitleLabel;
}

- (UIButton *)touchButton
{
    if (!_touchButton) {
        
        _touchButton = [[UIButton alloc]init];
        [_touchButton setBackgroundImage:[UIImage imageNamed:@"network_retry.png"] forState:UIControlStateNormal];
        [_touchButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_touchButton setTitleColor:UIColorFromHex(0x4e8cef) forState:UIControlStateNormal];
        [_touchButton setTitle:@"刷新" forState:UIControlStateNormal];

        [_touchButton addTarget:self
                         action:@selector(retryNetwork) forControlEvents:UIControlEventTouchUpInside];
        [_touchButton setBackgroundColor:[UIColor clearColor]];
    }
    return _touchButton;
}

@end
