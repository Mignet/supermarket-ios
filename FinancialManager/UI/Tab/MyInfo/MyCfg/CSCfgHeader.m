//
//  CSImportCustomerCell.m
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CSCfgHeader.h"

@interface CSCfgHeader()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * secondLevelLabel;
@property (nonatomic, strong) UILabel * thirdLevelLabel;
@property (nonatomic, strong) UIView  * containerView;
@end

@implementation CSCfgHeader

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

- (void)refreshTitle:(NSString *)title secondLevel:(NSString *)secondLevelCount thirdLevel:(NSString *)thirdLevelCount
{
    [self.titleLabel setText:title];
    
    NSArray *propertyArray = @[@{@"range": @"二级(",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:13]},
                               @{@"range": secondLevelCount,
                                 @"color": UIColorFromHex(0x666666),
                                 @"font": [UIFont systemFontOfSize:13]},
                               @{@"range": @"人)",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.secondLevelLabel.attributedText = string;
    
    propertyArray = @[@{@"range": @"三级(",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:13]},
                               @{@"range": thirdLevelCount,
                                 @"color": UIColorFromHex(0x666666),
                                 @"font": [UIFont systemFontOfSize:13]},
                               @{@"range": @"人)",
                                 @"color": UIColorFromHex(0x999999),
                                 @"font": [UIFont systemFontOfSize:14]}];
    
    string = [NSString getAttributeStringWithAttributeArray:propertyArray];
    self.thirdLevelLabel.attributedText = string;
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
        [self.titleLabel setTextColor:UIColorFromHex(0x4f5960)];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [self.titleLabel setText:@""];
        
        self.secondLevelLabel = [[UILabel alloc]init];
        
        UILabel * middleSeperatorLine = [[UILabel alloc]init];
        [middleSeperatorLine setBackgroundColor:UIColorFromHex(0xdddddc)];
        
        self.thirdLevelLabel = [[UILabel alloc]init];
        
        UILabel * bottomLine = [[UILabel alloc]init];
        [bottomLine setBackgroundColor:UIColorFromHex(0xefefef)];
        
        [_containerView addSubview:upLine];
        [_containerView addSubview:self.titleLabel];
        [_containerView addSubview:self.secondLevelLabel];
        [_containerView addSubview:middleSeperatorLine];
        [_containerView addSubview:self.thirdLevelLabel];
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
        
        [self.thirdLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(tmpContainerView.mas_top);
            make.trailing.mas_equalTo(tmpContainerView.mas_trailing).offset(-15);
            make.bottom.mas_equalTo(tmpContainerView.mas_bottom);
        }];
        
        __weak UILabel * tmpLabel = self.thirdLevelLabel;
        [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(tmpContainerView);
            make.width.mas_equalTo(@(0.5));
            make.height.mas_equalTo(@(15));
            make.trailing.mas_equalTo(tmpLabel.mas_leading).offset(- 10);
        }];
        
        tmpLabel = middleSeperatorLine;
        [self.secondLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(tmpContainerView.mas_top);
            make.trailing.mas_equalTo(tmpLabel.mas_leading).offset(- 10);
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
