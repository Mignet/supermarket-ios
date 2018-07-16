//
//  ZSDSetPasswordView.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "PasswordView.h"

@interface PasswordView ()<UITextFieldDelegate>

@end

@implementation PasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            
            if ([note.object isEqual:self.passwordTextField])
            {
                [self setDotWithCount:self.passwordTextField.text.length];
            }
            
        }];
        
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        
        if ([note.object isEqual:self.passwordTextField])
        {
            [self setDotWithCount:self.passwordTextField.text.length];
        }
    }];
    
    [self initView];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {    
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            
            if ([note.object isEqual:self.passwordTextField])
            {
                [self setDotWithCount:self.passwordTextField.text.length];
            }
        }];
        
        [self initView];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

////////////////
#pragma mark - Custom Method
////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.passwordTextField];
    
    weakSelf(weakSelf)
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.top.trailing.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - 激活
-(void)fieldBecomeFirstResponder
{
    [self.passwordTextField becomeFirstResponder];
}

#pragma mark - 完成输入
- (void)finishedInput
{
    if ([_delegate respondsToSelector:@selector(passwordView:inputPassword:)]) {
        
        [_delegate passwordView:self inputPassword:_passwordTextField.text];
    }
}

#pragma mark - 清空内容
- (void)clearUpPassword
{
    _passwordTextField.text = @"";
}

#pragma mark - 绘制密码
- (void)setDotWithCount:(NSInteger)count
{
    
}

/////////////////
#pragma mark - Protocol
///////////////////////////

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 6)
    {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordTextField becomeFirstResponder];
}

/////////////////
#pragma mark - setter/getter
///////////////////////////////////////

#pragma mark -
- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _passwordTextField.hidden = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _passwordTextField;
}

@end
