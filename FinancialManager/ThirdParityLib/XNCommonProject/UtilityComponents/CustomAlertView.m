 //
//  CustomAlertView.m
//  FinancialManager
//
//  Created by xnkj on 17/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView()

@property (nonatomic, copy) cancelBlock cancel;
@property (nonatomic, copy) otherBlock other;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * cancelTitle;
@property (nonatomic, strong) NSString * otherTitle;

@property (nonatomic, weak) id<CustomAlertViewDelegate> delegate;
@end

@implementation CustomAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CustomAlertViewDelegate>)delegate cancelBtn:(NSString *) cancelTitle cancelComplete:(cancelBlock)cancel otherBtn:(NSString *)otherTitle otherComplete:(otherBlock)other
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    if (self) {
        
        self.windowLevel = UIWindowLevelAlert + 1000;
        
        if (cancel)
        self.cancel = [cancel copy];
        if (other)
        self.other = [other copy];
       
        self.title = title;
        self.message = message;
        self.cancelTitle = cancelTitle;
        self.otherTitle = otherTitle;
        
        self.delegate = delegate;
        
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        
        [self createView];
    }
    return self;
}

#pragma mark - 创建弹出内容
- (void)createView
{
    UIView * customPopView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 270, 106)];
    
    UIView * shadowBgView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [shadowBgView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    
    UIImageView * customPopBackgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0 , 270, 106)];
    [customPopBackgroundImg setImage:[UIImage imageNamed:@"xn_popview_bg.png"]];
    [customPopView.layer setMasksToBounds:YES];
    [customPopView.layer setCornerRadius:10.0f];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 270, 60)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setText:self.title];
    
    UILabel * subTitleLabel = nil;
    
    subTitleLabel = [[UILabel alloc]init];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setTextColor:[UIColor blackColor]];
    [subTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [subTitleLabel setText:self.message];
    [subTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [subTitleLabel setNumberOfLines:0];
    
    UILabel * seperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(0 , 45, 270, 0.5)];
    [seperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 46 , 135, 45)];
    [okBtn setTitleColor:MONEYCOLOR forState:UIControlStateNormal];
    [okBtn setTitle:self.otherTitle forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL cancelExist = NO;
    UIButton * cancelBtn = nil;
    UILabel * middleSeperatorLine = nil;
    if ([NSObject isValidateInitString:self.cancelTitle]) {
        
        cancelExist = YES;
        cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(135 , 46 , 135, 45)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        
        middleSeperatorLine = [[UILabel alloc]initWithFrame:CGRectMake(134.5, 45, 0.5, 60)];
        [middleSeperatorLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    [customPopView addSubview:customPopBackgroundImg];
    [customPopView addSubview:titleLabel];
    [customPopView addSubview:subTitleLabel];
    [customPopView addSubview:seperatorLine];
    [customPopView addSubview:okBtn];
    
    if (cancelExist)
    {
        [customPopView addSubview:middleSeperatorLine];
        [customPopView addSubview:cancelBtn];
    }
    
    __weak UIView * tmpCustomPopView = customPopView;
    [customPopBackgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tmpCustomPopView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
        make.top.mas_equalTo(tmpCustomPopView.mas_top);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.height.mas_equalTo(@(60));
    }];
    
    CGFloat height = 13;
    CGSize size = [subTitleLabel sizeThatFits:CGSizeMake(211, 2000)];
    if (![NSObject isValidateInitString:self.message]) {
        
        height = size.height;
    }
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(30);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(52);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing).offset(-30);
        make.height.mas_equalTo(height + 25);
    }];

    height = 52 + height + 36;

    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(tmpCustomPopView);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(0.5);
    }];
    
    height = height + 0.5;
    
    if (cancelExist){
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpCustomPopView.mas_leading);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(135.0));
            make.height.mas_equalTo(@(45));
        }];
        
        [middleSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(tmpCustomPopView.mas_centerX);
            make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
            make.width.mas_equalTo(@(0.5));
            make.height.mas_equalTo(@(45));
        }];
    }
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpCustomPopView.mas_leading).offset(cancelExist?135.0:0);
        make.trailing.mas_equalTo(tmpCustomPopView.mas_trailing);
        make.top.mas_equalTo(tmpCustomPopView.mas_top).offset(height);
        make.height.mas_equalTo(@(45));
    }];
    
    height = height + 45;
    
    //显示
    [shadowBgView addSubview:customPopView];
    [self addSubview:shadowBgView];
    
    weakSelf(weakSelf)
    __weak UIView * tmpView =shadowBgView;
    [customPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(tmpView);
        make.width.mas_equalTo(@(270.0));
        make.height.mas_equalTo(height);
    }];
    
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
}

#pragma mark - 确定
- (void)clickOk
{
    if([self.delegate respondsToSelector:@selector(customAlertViewDidOk)])
    {
        [self.delegate customAlertViewDidOk];
    }
}

#pragma mark -取消
- (void)clickCancel
{
    if([self.delegate respondsToSelector:@selector(customAlertViewDidCancel)])
    {
        [self.delegate customAlertViewDidCancel];
    }
}


- (void)show{
    
    [self makeKeyAndVisible];
}
@end
