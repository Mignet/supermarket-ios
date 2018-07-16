//
//  MFProductRecommendCellHeader.m
//  FinancialManager
//
//  Created by xnkj on 13/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MFProductRecommendCellHeader.h"

@interface MFProductRecommendCellHeader()

@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation MFProductRecommendCellHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (self.titleLabel.constraints.count <= 0) {
         
            [self.contentView addSubview:self.titleLabel];
            
            __weak UIView * tmpView = self.contentView;
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(tmpView.mas_leading).offset(15);
                make.centerY.equalTo(tmpView);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(16);
            }];
        }
    }
    return self;
}

- (void)refreshTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

#pragma mark - setter/getter

//titleLabel
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:UIColorFromHex(0x6c6e6d)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _titleLabel;
}

@end
