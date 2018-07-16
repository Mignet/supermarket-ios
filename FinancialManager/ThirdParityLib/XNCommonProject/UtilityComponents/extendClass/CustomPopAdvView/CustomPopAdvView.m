//
//  CustomPopAdvView.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomPopAdvView.h"
#import "UIImageView+WebCache.h"

#define fMainViewHeight 377.0f
#define fMainViewWidth 270.0f
#define fImageViewHeight 323.0f
#define fCancelButtonSize 30.0f

@interface CustomPopAdvView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *imageBackgroundButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, copy) NSString *linkUrlString;

@end

@implementation CustomPopAdvView

- (id)initWithImageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl
{
    self = [super init];
    if (self)
    {
        self.imageUrlString = imageUrl;
        self.linkUrlString = linkUrl;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlString] placeholderImage:[UIImage imageNamed:@"XN_Pop_Default_icon"]];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setImage:[UIImage imageNamed:@"XN_Common_Cancel_White_icon"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.imageView];
    [self.mainView addSubview:self.cancelButton];
    
    weakSelf(weakSelf)
    __weak UIView *weakMainView = self.mainView;
    __weak UIImageView *weakImageView = self.imageView;
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-50);
        make.width.mas_equalTo(fMainViewWidth);
        make.height.mas_equalTo(fMainViewHeight);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakMainView.mas_top);
        make.left.mas_equalTo(weakMainView.mas_left);
        make.right.mas_equalTo(weakMainView.mas_right);
        make.height.mas_equalTo(fImageViewHeight);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakImageView.mas_bottom).offset(24);
        make.centerX.mas_equalTo(weakMainView.mas_centerX);
        make.width.mas_equalTo(fCancelButtonSize);
        make.height.mas_equalTo(fCancelButtonSize);
    }];
    
}

#pragma mark - 展示区域
- (void)showInView:(UIViewController *)controller
{
    if (controller)
    {
        [controller.view addSubview:self];
    }
    else
    {
        [_KEYWINDOW addSubview:self];
    }
    [self tapgestureRecognizerAnimate];
}

#pragma mark - 隐藏view
- (void)hiddenPopAdvView
{
    [self cancelClick];
}

#pragma mark - 取消操作
- (void)cancelClick
{
    if (self.block)
        self.block();
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
        CGRect originRect = weakSelf.frame;
        originRect.origin.y = SCREEN_FRAME.size.height;
        weakSelf.frame = originRect;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakSelf.alpha = 1;
            
            CGRect originRect = weakSelf.frame;
            originRect.origin.y = 0;
            weakSelf.frame = originRect;
            
            for (UIView *view in weakSelf.subviews)
            {
                [view removeFromSuperview];
            }
            [weakSelf removeFromSuperview];
        }
    }];
}

#pragma mark - 点击空白地方,进入详情页
- (void)tapgestureRecognizerAnimate
{
    //点击空白地方,进入详情页
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intoViewController)];
    [self.imageView addGestureRecognizer:tapGesture];
    self.imageView.userInteractionEnabled = YES;
}

#pragma mark - 进入详情页
- (void)intoViewController
{
    if (self.block)
       self.block();
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoDetailViewController:)])
    {
        [self.delegate gotoDetailViewController:self.linkUrlString];
    }
}

//点击回
- (void)setClickPopAdViewBlock:(void(^)())block
{
    if (block) {
    
        self.block = block;
    }
}

@end
