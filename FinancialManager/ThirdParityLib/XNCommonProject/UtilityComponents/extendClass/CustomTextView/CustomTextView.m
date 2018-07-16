//
//  CustomTextView.m
//  FinancialManager
//
//  Created by xnkj on 11/07/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView()

@property (nonatomic, strong) UILabel * placeHolderLabel;
@end

@implementation CustomTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
     [self initView];
}

//初始化
- (void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    self.placeHolderLabel = [[UILabel alloc]init];
    [self.placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self insertSubview:self.placeHolderLabel atIndex:0];
    weakSelf(weakSelf)
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.mas_leading);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(weakSelf.mas_height);
        make.width.mas_equalTo(weakSelf.mas_width);
    }];
}

//文本修改回调用
- (void)textDidChange
{
    [self.placeHolderLabel setHidden:NO];
    if (self.text.length > 0) {
        
        [self.placeHolderLabel setHidden:YES];
    }
}

- (void)setPlaceHolderTextFont:(UIFont *)placeHolderTextFont
{
    _placeHolderTextFont = placeHolderTextFont;
    
    self.placeHolderLabel.font = placeHolderTextFont;
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor
{
    self.placeHolderLabel.textColor = placeHolderTextColor;
}

- (void)setPlaceHolderStr:(NSString *)placeHolderStr
{
    self.placeHolderLabel.text = placeHolderStr;
    
//    CGFloat height = [placeHolderStr getSpaceLabelHeightForFont:self.placeHolderTextFont withWidth:self.width lineSpacing:6];
//    
//    weakSelf(weakSelf)
//    [self.placeHolderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        
//        make.leading.mas_equalTo(weakSelf.mas_leading);
//        make.top.mas_equalTo(weakSelf.mas_top);
//        make.height.mas_equalTo(height);
//        make.width.mas_equalTo(weakSelf.mas_width);
//    }];
//    
//    [self layoutIfNeeded];
//    
//    [self.placeHolderLabel setYf_contentInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
@end
