//
//  PasswordTextField.m
//  Lhlc
//
//  Created by ancye.Xie on 2/16/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "PasswordTextField.h"

@interface PasswordTextField()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *hideTimer;
@property (nonatomic, strong) NSTimer *blinkTimer;

@end

@implementation PasswordTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isShowPassword = NO;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.userInteractionEnabled = YES;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.delegate = self;
        
        self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 5, frame.size.width-25, frame.size.height - 12)];
        _hideLabel.backgroundColor = [UIColor whiteColor];
        _hideLabel.hidden = YES;
        
        [self addSubview:_textField];
        [self addSubview:_hideLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)textFieldDidChange:(NSNotification*)notification
{
    UITextField *textField = notification.object;
    if (textField == _textField)
    {
        if (textField.text.length < 1)
        {
            _hideLabel.text = @"";
            _hideLabel.hidden = YES;
        }
        else
        {
            _hideLabel.hidden = NO;
        }
        
        [self stateOfPassord];
        
        NSString *text = textField.text;
        [self hideExceptLastCharacter:text];
        
        [self.hideTimer invalidate];
        self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(hideLastCharacter)
                                                        userInfo:nil
                                                         repeats:NO];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_blinkTimer invalidate];
    //显示textField placeholder
    if (self.textField.text.length < 1)
    {
        _hideLabel.hidden = YES;
    }
}

/**
 *	点击软键盘的return按钮，就隐藏软键盘
 *
 *	@param	textField	<#textField description#>
 *
 *	@return	<#return value description#>
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)hideExceptLastCharacter:(NSString*)string
{
    NSInteger nLength = [_textField.text length];
    
    NSString *str = @"";
    for (NSInteger i = 0; i < nLength - 1; i++)
    {
        str = [str stringByAppendingString:@"●"];
    }
    
    if (_textField.text.length > 0)
    {
        _hideLabel.text = [str stringByAppendingString:[_textField.text substringFromIndex:_textField.text.length - 1]];
    }
    
    [self stateOfPassord];
}

- (void)hideLastCharacter
{
    if (_hideLabel.text.length > 1)
    {
        NSRange range;
        range.location = [_hideLabel.text length] - 1;
        range.length = 1;
        
        _hideLabel.text = [_hideLabel.text stringByReplacingCharactersInRange:range withString:@"●"];
    }
    [self stateOfPassord];
}


- (void)blinkCursor
{
    if (_hideLabel.text.length > 0)
    {
        NSRange range;
        range.location = _hideLabel.text.length - 1;
        range.length = 1;
    }
}

- (void)stateOfPassord
{
    //显示密码
    if (_isShowPassword)
    {
        _hideLabel.hidden = YES;
    }
    else
    {
        //隐藏密码
        _hideLabel.hidden = NO;
    }
}

- (void)dealloc
{
    [_hideTimer invalidate];
    [_blinkTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
