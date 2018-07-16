//
//  SignShareSucceeView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/21.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignShareSucceeView.h"
#import "SignShareModel.h"

@interface SignShareSucceeView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *oneMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoMsgLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;

@property (nonatomic, retain) UIControl *overlayView;


@end

@implementation SignShareSucceeView

+ (instancetype)signShareSucceeView
{
    SignShareSucceeView *succeeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SignShareSucceeView class]) owner:nil options:nil] firstObject];
    
    if (SCREEN_FRAME.size.width > 360) {
        succeeView.width = SCREEN_FRAME.size.width - 100.f;
    } else {
        succeeView.width = SCREEN_FRAME.size.width - 70.f;
    }
    
    succeeView.height = 320.f;
    return succeeView;
}

- (void)show:(UIView *)view
{
    //UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    [view addSubview:self.overlayView];
    [view addSubview:self];
    
    self.center = CGPointMake(view.bounds.size.width/2.0f,
                              view.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#pragma mark - animations
- (void)fadeIn {
    
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut {
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)BtnClick:(UIButton *)sender
{
    if (sender == self.closeBtn) {
        [self dismiss];
    }
    
    if (sender == self.drawBtn) {
        
        if ([self.delegate respondsToSelector:@selector(signShareSucceeViewDid:)]) {
            [self.delegate signShareSucceeViewDid:self];
            
            [self dismiss];
        }
    }
    
    if (sender == self.checkBtn) {
        
        if ([self.delegate respondsToSelector:@selector(checkSignShareSucceeViewDid:)]) {
            [self.delegate checkSignShareSucceeViewDid:self];
            
            //[self dismiss];
        }
    }
}

/////////////////////////
#pragma mark - setter / getter
//////////////////////////

- (UIControl *)overlayView {
    
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.7];
    }
    return _overlayView;
}


@end
