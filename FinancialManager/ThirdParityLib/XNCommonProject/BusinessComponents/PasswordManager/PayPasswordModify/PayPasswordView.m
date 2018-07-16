//
//  PayPasswordView.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "PayPasswordView.h"
#import "UIView+CornerRadius.h"

#define PASSWORDIMAGEVIEWTAGE 0x11111

@interface PayPasswordView()

@property (nonatomic, assign) CGSize passwordAreaSize;
@property (nonatomic, strong) NSMutableArray * passwordIndicatorArrary;
@end

@implementation PayPasswordView

- (id)initWithPayPasswordViewWithFrame:(CGRect)frame CellSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.passwordAreaSize = size;
        [self initSubView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.passwordAreaSize = CGSizeMake(40, 44);
    [self initSubView];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.passwordAreaSize = CGSizeMake(40, 44);
        [self initSubView];
    }
    
    return self;
}

- (BOOL)willDealloc
{
    return NO;
}

/////////////////
#pragma mark - Custom Method
//////////////////////////////////////

#pragma mark - 初始化
- (void)initSubView
{
    weakSelf(weakSelf)
     UIView * lastUnInputPasswordView = nil;
    UIView *unInputPasswordView = nil;
    UIImageView * passwordImageView = nil;
    for (int i = 0; i < 6; i++)
    {
        unInputPasswordView = [[UIView alloc]init];
        [unInputPasswordView drawRoundCornerWithRectSize:self.passwordAreaSize backgroundColor:[UIColor whiteColor] borderWidth:0.5 borderColor:UIColorFromHex(0xc8c8c8) radio:0];
        
        passwordImageView = [[UIImageView alloc]init];
        [passwordImageView setTag:PASSWORDIMAGEVIEWTAGE];
        [unInputPasswordView addSubview:passwordImageView];
        
        __weak UIView * tmpUnInputPasswordView = unInputPasswordView;
        [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(tmpUnInputPasswordView);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        [self addSubview:unInputPasswordView];
        [unInputPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(weakSelf.mas_leading).offset((weakSelf.frame.size.width - weakSelf.passwordAreaSize.width * 6) / 2 + 2.5);
            else
                make.leading.mas_equalTo(lastUnInputPasswordView.mas_trailing).offset(-1);
            make.top.mas_equalTo(weakSelf.mas_top);
            make.size.mas_equalTo(weakSelf.passwordAreaSize);
        }];
        
        lastUnInputPasswordView = unInputPasswordView;
        
        [self.passwordIndicatorArrary addObject:unInputPasswordView];
    }
}

#pragma mark - 输入密码
- (void)setDotWithCount:(NSInteger)count
{
    UIImageView * passwordImageView = nil;
    for (UIView *passwordView in self.passwordIndicatorArrary)
    {
        passwordImageView = (UIImageView *)[passwordView viewWithTag:PASSWORDIMAGEVIEWTAGE];
        
        [passwordImageView setImage:nil];
    }
    
    for (int i = 0; i< count; i++)
    {
        passwordImageView = (UIImageView *)[[self.passwordIndicatorArrary objectAtIndex:i] viewWithTag:PASSWORDIMAGEVIEWTAGE];
     
        [passwordImageView setImage:[UIImage imageNamed:@"password_input_dot.png"]];
    }
    
    if (self.passwordTextField.text.length >= 6) {
        
        [self performSelector:@selector(finishedInput) withObject:nil afterDelay:1];
    }
}

#pragma mark - 清空内容
- (void)clearUpPassword
{
    [super clearUpPassword];
    
    [self setDotWithCount:0];
}

#pragma mark - 键盘显示
- (void)showKeyboard
{
    [self fieldBecomeFirstResponder];
}

////////////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - passwordIndicatorArrary
- (NSMutableArray *)passwordIndicatorArrary
{
    if (!_passwordIndicatorArrary) {
        
        _passwordIndicatorArrary = [[NSMutableArray alloc]init];
    }
    return _passwordIndicatorArrary;
}
@end
