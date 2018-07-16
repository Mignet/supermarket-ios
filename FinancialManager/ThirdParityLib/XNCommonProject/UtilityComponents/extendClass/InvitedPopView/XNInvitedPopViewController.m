//
//  XNInvitedPopViewController.m
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "XNInvitedPopViewController.h"

@interface XNInvitedPopViewController ()<XNInvitedPopViewDelegate>

@property (nonatomic, assign) id<XNInvitedPopViewDelegate> delegate;

@property (nonatomic, strong) XNInvitedPopView * invitedPopView;

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *iconsArray;

@end

@implementation XNInvitedPopViewController

- (id)initWithDelegate:(id)delegate titlesArray:(NSArray *)titles AndIconsArray:(NSArray *)icons
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.delegate = delegate;
        self.titlesArray = titles;
        self.iconsArray = icons;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshServiceIcon) name:XN_UNREAD_SERVICE_ICON object:nil];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////
#pragma mark - Custom Method
///////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    [self hide];
    
    UIButton * existButton = [[UIButton alloc]init];
    [existButton setBackgroundColor:[UIColor clearColor]];
    [existButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:existButton];
    
    weakSelf(weakSelf)
    [existButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.invitedPopView];
    
    
    [self.invitedPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(0);
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing).offset(-12);
        make.width.mas_equalTo(@(111));
        make.height.mas_equalTo(@(self.titlesArray.count * 44 + 7));
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 取消
- (IBAction)tapAction:(id)sender
{
    [self hide];
}

#pragma mark - 显示
- (void)show
{
    [self.view setHidden:NO];
}

#pragma mark - 隐藏
- (void)hide
{
    [self.view setHidden:YES];
}

#pragma mark - 更新未读图标
- (void)refreshServiceIcon
{
    [self.invitedPopView refreshTableView];
}

////////////////////////
#pragma mark - Protocol
///////////////////////////////////////

#pragma mark - InvitedPopViewDelegte
- (void)XNInvitedPopViewDidSelectedAtIndex:(NSInteger)index
{
    [self hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XNInvitedPopViewDidSelectedAtIndex:)]) {
        
        [self.delegate XNInvitedPopViewDidSelectedAtIndex:index];
    }
}

////////////////////////
#pragma mark - setter/etter
///////////////////////////////////////

#pragma mark - XNInvitedPopView
- (XNInvitedPopView *)invitedPopView
{
    if (!_invitedPopView) {
        _invitedPopView = [[XNInvitedPopView alloc]initWithFrame:CGRectMake(0, 0, 107, 60) titleDataSource:self.titlesArray iconDataSource:self.iconsArray];
        _invitedPopView.delegate = self;
    }
    return _invitedPopView;
}

@end
