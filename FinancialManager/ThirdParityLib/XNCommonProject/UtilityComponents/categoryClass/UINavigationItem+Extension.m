 //
//  UINavigationItem+Extension.m
//  GXQApp
//
//  Created by 振增 黄 on 14-5-6.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "UINavigationItem+Extension.h"
#import "NSString+common.h"


#define MESSAGEREMINDVIEW @"MESSAGEREMINDVIEW"
#define MESSAGEREMINDMESSAGECOUNT @"MESSAGEREMINDMESSAGECOUNT"
#define MESSAGEREMINDMEESAGEVIEW @"MESSAGEREMINDMEESAGEVIEW"

#define REDPACKETSELECTCUSTOMERVIEW @"REDPACKETSELECTCUSTOMERVIEW"

#define INVITEDIMAGEVIEW @"INVITEDIMAGEVIEW"


@interface IconBtn : UIButton
@property (nonatomic ,assign) CGRect imageViewFrame;

- (id)initWithimageViewFrame:(CGRect)rect;
@end

@implementation IconBtn
- (instancetype)initWithimageViewFrame:(CGRect)rect
{
    if(self = [super init]){
        self.imageViewFrame = rect;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return self.imageViewFrame;
}

@end

@implementation UINavigationItem (Extension)

- (void)addBackButtonItemWithTarget:(id)target action:(SEL)action {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 44);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(11, 0, 11, 27)];
    [backButton setImage:[UIImage imageNamed:@"XN_Common_back_btn"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_press.png"] forState:UIControlStateSelected];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    
    self.leftBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)addShareButtonItemWithTarget:(id)target action:(SEL)action {
    [self addShareButtonItemWithTarget:target action:action WithAnimation:NO];
}

- (void)addShareButtonItemWithTarget:(id)target action:(SEL)action WithAnimation:(BOOL)animation
{
    UIButton * shareBtn = [[UIButton alloc]init];
    [shareBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(0, 0, 40, 44);
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(11, 10, 11, 10)];
    
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [shareBtn setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.rightBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:shareBtn]];
}

- (void)addMessageButtonItemWithTarget:(id)target action:(SEL)action hasUnReadStatus:(BOOL)unReadMsg {
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    if (unReadMsg) {
        
        shareButton.frame = CGRectMake(0, 0, 29, 23);
        
        [shareButton setImage:[UIImage imageNamed:@"icon_message_hint_normal"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"icon_message_hint_press"] forState:UIControlStateHighlighted];
        [shareButton setImage:[UIImage imageNamed:@"icon_message_hint_press"] forState:UIControlStateSelected];
    }
    else {
        
        shareButton.frame = CGRectMake(0, 0, 24, 18);
        
        [shareButton setImage:[UIImage imageNamed:@"icon_message_normal"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"icon_message_press"] forState:UIControlStateHighlighted];
        [shareButton setImage:[UIImage imageNamed:@"icon_message_press"] forState:UIControlStateSelected];
    }
    //selected = !selected;
    
    [shareButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
}

- (void)addMessageButtonItemWithTarget1:(id)target action:(SEL)action {
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 44, 44);
    [shareButton setImage:[UIImage imageNamed:@"common_message_normal"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"common_message_press"] forState:UIControlStateHighlighted];
    [shareButton setImage:[UIImage imageNamed:@"common_message_press"] forState:UIControlStateSelected];
    
    [shareButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
}

#pragma mark - 提现明细
- (void)addDeportDetailWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"提现记录" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 编辑
- (void)addEditItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"编辑" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 设置已读
- (void)addReadAllMsgItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"标记全部已读" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 充值明细
- (void)addRechargeDetailWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"充值记录" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 提交
- (void)addCommitButtonItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"提交" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)addRightBarItemWithTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitleColor:color forState:UIControlStateNormal];
    
    CGFloat width = [title sizeOfStringWithFont:15 InRect:CGSizeMake(1000, 44)].width;
    
    backButton.frame = CGRectMake(10, 0, width, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)addRightBarItemWithImage:(NSString *)imageName frame:(CGRect )frame target:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:frame];
    UIImage * imageIcon = [UIImage imageNamed:imageName];
    [backButton setBackgroundImage:imageIcon forState:UIControlStateNormal];
    [backButton setBackgroundImage:imageIcon forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = (frame.origin.x + frame.size.width) - SCREEN_FRAME.size.width;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)addRightBarItemWithButtonArray:(NSArray *)btnArray frameArray:(NSArray *)frameArray target:(id)target action:(NSArray *)actionArray
{
    UIButton * btn = nil;
    UIBarButtonItem * spaceItem = nil;
    NSMutableArray * barButtonItemsArray = [NSMutableArray array];
    for (NSInteger index = 0 ; index < btnArray.count; index ++) {
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:[[frameArray objectAtIndex:index] CGRectValue]];
        [btn setBackgroundImage:[UIImage imageNamed:[btnArray objectAtIndex:index]] forState:UIControlStateNormal];
        [btn addTarget:target action:NSSelectorFromString([actionArray objectAtIndex:index]) forControlEvents:UIControlEventTouchUpInside];
        
        spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = ([[frameArray objectAtIndex:index] CGRectValue].origin.x + [[frameArray objectAtIndex:index] CGRectValue].size.width) - SCREEN_FRAME.size.width;
        
        [barButtonItemsArray addObject:spaceItem];
        [barButtonItemsArray addObject:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    }
    
    self.rightBarButtonItems = barButtonItemsArray;
}

#pragma mark - 添加一个回话
- (void)addConversationItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"新建互动" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 佣金说明
- (void)addComissionDescWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(12, 0, 100, 44);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(12, 80, 12, 0)];
    [backButton setImage:[UIImage imageNamed:@"redPacket_rule.png"] forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 全选
- (void)selectAllWithTarget:(id)target title:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 80, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 添加消息提醒
- (void)addMessageRemindItemWithTarget:(id)target action:(SEL)action
{
    UIView * messageRemindContainerView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, 33, 41)];
    [messageRemindContainerView setBackgroundColor:[UIColor clearColor]];
    
    //添加邮箱图片
    UIImageView * mailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 33, 34)];
    [mailImageView setImage:[UIImage imageNamed:@"messagecenter_mail_white_icon.png"]];
   
    //MESSAGEREMINDVIEW
    objc_setAssociatedObject(target, MESSAGEREMINDVIEW, mailImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIView * itemView = objc_getAssociatedObject(target, MESSAGEREMINDVIEW);
    [messageRemindContainerView addSubview:mailImageView];
    /*
    //添加消息数目
    UIView * messageCountView = [[UIView alloc]initWithFrame:CGRectMake(17, 3, 20, 20)];
    
    UIImageView * messageCountBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [messageCountBackgroundImageView setImage:[UIImage imageNamed:@"messagecenter_count_icon.png"]];
    [messageCountView addSubview:messageCountBackgroundImageView];
    
    UILabel * messageCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [messageCountLabel setTextAlignment:NSTextAlignmentCenter];
    [messageCountLabel setFont:[UIFont systemFontOfSize:12]];
    [messageCountLabel setTextColor:UINavigationItemMessageCountTextColor];
    [messageCountView addSubview:messageCountLabel];
    
    objc_setAssociatedObject(self, MESSAGEREMINDMESSAGECOUNT, messageCountLabel, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, MESSAGEREMINDMEESAGEVIEW, messageCountView, OBJC_ASSOCIATION_RETAIN);
    
    [messageRemindContainerView addSubview:messageCountView];
    */
    //事件驱动
    UIButton * clickMessageButton = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0, 66, 30)];
    [clickMessageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [messageRemindContainerView addSubview:clickMessageButton];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 5;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:messageRemindContainerView]];
}

#pragma mark - 拍照
- (void)addTakePictureItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"ChangeUserPictureViewController.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 0, 22, 4);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 添加选择客户的数量项
- (void)addSelectCustomerCountItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"确定" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(12, 0, 100, 44);
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, REDPACKETSELECTCUSTOMERVIEW, backButton, OBJC_ASSOCIATION_RETAIN);
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 红包规则说明
- (void)addRedPacketDispatchRuleItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(12, 0, 100, 44);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(12, 80, 12, 0)];
    [backButton setImage:[UIImage imageNamed:@"redPacket_rule.png"] forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.rightBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

#pragma mark - 标题带有解释按钮
- (void)addTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    float fWith = title.length * 16 + 20;
    float fLeft = (view.frame.size.width - fWith) / 2;

    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.text = title;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_Explain_White_fill_icon.png"]];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:titleLabel];
    [view addSubview:imageView];
    [view addSubview:button];
    
    __weak UIView *weakView = view;
    __weak UILabel *weakTitleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakView.mas_top);
        make.leading.mas_equalTo(weakView.mas_leading).offset(fLeft);
        make.bottom.mas_equalTo(weakView.mas_bottom);
    }];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakView.mas_top).offset(10);
        make.left.mas_equalTo(weakTitleLabel.mas_right).offset(4);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakView);
    }];

    self.titleView = view;

}

// 标题带有向下图标的按钮
- (void)addDownTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    float fWith = title.length * 16 + 20;
    float fLeft = (view.frame.size.width - fWith) / 2;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.text = title;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XN_Explain_White_fill_icon.png"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:titleLabel];
    [view addSubview:imageView];
    [view addSubview:button];
    
    __weak UIView *weakView = view;
    __weak UILabel *weakTitleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakView.mas_top);
        make.leading.mas_equalTo(weakView.mas_leading).offset(fLeft);
        make.bottom.mas_equalTo(weakView.mas_bottom);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakView.mas_top).offset(10);
        make.left.mas_equalTo(weakTitleLabel.mas_right).offset(4);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakView);
    }];
    
    self.titleView = view;
}

#pragma mark - 移除
- (void)removeRightButton
{
    self.rightBarButtonItem = nil;
    self.rightBarButtonItems = nil;
}

#pragma mark - 移除返回按钮
- (void)removeLeftButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(9, 0, 9, 27)];
    [backButton setImage:[UIImage imageNamed:@"menu_bar_bg.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"menu_bar_bg.png"] forState:UIControlStateSelected];
    
    //设置图像位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -8;
    
    self.leftBarButtonItems = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];//
//    [self setHidesBackButton:YES];
//    [self setLeftBarButtonItem:nil];
//    [self setLeftBarButtonItems:nil];
}

#pragma mark - 显示返回按钮
- (void)showLeftButton:(id)target action:(SEL)action
{
    if (self.leftBarButtonItem == nil && self.leftBarButtonItems == nil)
    {
        [self addBackButtonItemWithTarget:target action:action];
    }
}

//////////////////
#pragma mark - 对item上内容进行操作
/////////////////////////////////////////////////

#pragma mark - 刷新消息数
- (void)refreshMessageRemindItemWithMessageCount:(NSString *)messageCount forTarget:(id)target
{
    /*
    UILabel * messageCountLabel = objc_getAssociatedObject(self, MESSAGEREMINDMESSAGECOUNT);
    UIView  * messageCountView = objc_getAssociatedObject(self, MESSAGEREMINDMEESAGEVIEW);
    [messageCountView setHidden:NO];
    */
    UIImageView * mailImageView = objc_getAssociatedObject(target, MESSAGEREMINDVIEW);
    if (![NSObject isValidateObj:messageCount] || ![NSObject isValidateInitString:messageCount] || [messageCount isEqualToString:@"0"]) {
        
//        [messageCountView setHidden:YES];
        [mailImageView setImage:[UIImage imageNamed:@"messagecenter_mail_white_icon@2x.png"]];
        [mailImageView removeShakeAnimation];
    }
    else
    {
        [mailImageView setImage:[UIImage imageNamed:@"messagecenter_mail_white_unread_icon@2x.png"]];
        [mailImageView shakeAnimationForDuration:3];
    }
//    [messageCountLabel setText:messageCount];
    
}

#pragma mark - 刷新被选择的客户数量
- (void)refreshSelectCustomerCountItemWithCustomerCount:(NSString *)customerCount forTarget:(id)target
{
    UIButton * selectCustomButton = objc_getAssociatedObject(target, REDPACKETSELECTCUSTOMERVIEW);
    
    if (![NSObject isValidateObj:customerCount] || ![NSObject isValidateInitString:customerCount] || ![customerCount isEqualToString:@"0"]) {
        
        [selectCustomButton setTitle:[NSString stringWithFormat:@"确定(%@)",customerCount] forState:UIControlStateNormal];
    }else
    {
        [selectCustomButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

#pragma mark - 刷新item上邀请的图标
- (void)refreshServiceImage:(BOOL)isUnReadMsg forTarget:(id)target
{
    UIImageView *inviteImageView = objc_getAssociatedObject(target, INVITEDIMAGEVIEW);
    if (isUnReadMsg)
    {
        //如果未读
        inviteImageView.frame = CGRectMake(5, 11, 24, 24);
        [inviteImageView setImage:[UIImage imageNamed:@"invited_enter_unread_icon.png"]];
    }
    else
    {
        //已读
        inviteImageView.frame = CGRectMake(7, 11, 22, 22);
        [inviteImageView setImage:[UIImage imageNamed:@"invited_enter_icon.png"]];
    }
}

//获取对应试图
- (UIView *)getItemViewWithTag:(NSString *)tagStr forTarget:(id)target
{
     UIView * itemView = objc_getAssociatedObject(target, (__bridge const void *)(tagStr));
    
    return itemView;
}
@end
