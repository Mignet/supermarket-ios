//
//  CSImportCustomerCell.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CSCustomerHeader.h"

@interface CSCustomerHeader()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView  * containerView;
@end

@implementation CSCustomerHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.containerView];
        
        weakSelf(weakSelf)
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(weakSelf.mas_leading);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(@(44));
        }];
    }
    return self;
}

- (void)refreshTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}


- (UIView *)containerView
{
    if (!_containerView) {
        
        _containerView = [[UIView alloc]init];
        //[_containerView setBackgroundColor:UIColorFromHex(0xf9f9f9)];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * upLine = [[UILabel alloc]init];
        [upLine setBackgroundColor:[UIColor redColor]];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.titleLabel setTextColor:UIColorFromHex(0x4F5960)];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setText:@""];
        
        UILabel * bottomLine = [[UILabel alloc]init];
        [bottomLine setBackgroundColor:UIColorFromHex(0xefefef)];
        
        [_containerView addSubview:upLine];
        [_containerView addSubview:self.titleLabel];
        [_containerView addSubview:bottomLine];
         
        __weak UIView * tmpContainerView = _containerView;
        [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(tmpContainerView.mas_leading);
            make.top.mas_equalTo(tmpContainerView.mas_top);
            make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
            make.height.mas_equalTo(0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(tmpContainerView.mas_leading).offset(12);
            make.top.mas_equalTo(tmpContainerView.mas_top);
            make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
            make.bottom.mas_equalTo(tmpContainerView.mas_bottom);
        }];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(tmpContainerView.mas_leading);
            make.bottom.mas_equalTo(tmpContainerView.mas_bottom);
            make.trailing.mas_equalTo(tmpContainerView.mas_trailing);
            make.height.mas_equalTo(0.5);

        }];
    }
    
    return _containerView;
}
@end
