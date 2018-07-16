//
//  MFProductListContainerController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIMessageContainerController.h"
#import "MIMyMsgController.h"
#import "MIAnnounceController.h"

#import "ScrollViewExitView.h"

#import "UINavigationItem+Extension.h"

#import "Masonry.h"

#import "XNMessageModule.h"
#import "XNMessageModuleObserver.h"

#define DEFAULTTITLEWIDTH (SCREEN_FRAME.size.width / 2)
#define DEFAULTTITLEHEIGHT 50.0f

@interface MIMessageContainerController ()<UIScrollViewDelegate,XNMessageModuleObserver,MIAnnounceControllerDelegate>

@property (nonatomic, assign) BOOL             isFinishEdited;
@property (nonatomic, assign) NSInteger        announceCount;
@property (nonatomic, assign) NSInteger        myMsgCount;
@property (nonatomic, strong) NSArray        * titleArray;
@property (nonatomic, strong) NSMutableArray * titleTabArray;
@property (nonatomic, strong) NSArray        * listCtrlArray;
@property (nonatomic, strong) NSMutableArray * listContentArray;
@property (nonatomic, assign) NSInteger nSelectedTabBtn; //选中的消息类型
@property (nonatomic, strong) ScrollViewExitView * scrollExitView;

@property (nonatomic, weak) IBOutlet UILabel      * announceCountLabel;
@property (nonatomic, weak) IBOutlet UIView       * announceCountView;
@property (nonatomic, weak) IBOutlet UILabel      * myMsgCountLabel;
@property (nonatomic, weak) IBOutlet UIView       * myMsgCountView;

@property (nonatomic, strong) UIView * cursorView;
@property (nonatomic, weak) IBOutlet UIScrollView * titleContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * titleTabScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * listScrollView;
@end

@implementation MIMessageContainerController

- (instancetype)initWithMessageType:(NSInteger)nSelectedTabBtn
{
    self = [super initWithNibName:@"MIMessageContainerController" bundle:nil];
    if (self)
    {
        _nSelectedTabBtn = nSelectedTabBtn;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[XNMessageModule defaultModule] getUnReadMsgCount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMessageModule defaultModule] removeObserver:self];
}

///////////////////////////
#pragma mark - Custom Methods
/////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    [self setTitle:@"消息中心"];
    self.isFinishEdited = YES;
    
    [self.scrollExitView scrollView:self.listScrollView didLeftScrollNavigationController:self.navigationController];

    self.announceCount = 0;
    self.myMsgCount = 0;
    
    [[XNMessageModule defaultModule] addObserver:self];
    //获取未读消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unReadMsgCount) name:XN_UNREAD_MESSAGE_COUNT object:nil];
    
    
    [self createUI];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 创建ui
- (void)createUI
{
    [self.titleContainerScrollView addSubview:self.cursorView];
    [self.titleContainerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width / 4 * self.titleArray.count, 0)];
    
    //添加滑动标题
    UIButton * btn = nil;
    UIButton * lastBtn = nil;
    weakSelf(weakSelf);
    for (int i = 0 ; i < self.titleArray.count; i++) {
        
        //根据需求写死的
        __weak UIScrollView * tmpTitleScrollView = self.titleTabScrollView;
        if (i == 0) {
            
            [self.titleTabScrollView addSubview:self.myMsgCountView];
            [self.myMsgCountView setHidden:YES];
            
            [self.myMsgCountView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading).offset(SCREEN_FRAME.size.width * 1/4 + 20);
                make.top.mas_equalTo(tmpTitleScrollView.mas_top).offset(10);
                make.width.height.mas_equalTo(20);
            }];
        }else
        {
            [self.titleTabScrollView addSubview:self.announceCountView];
            [self.announceCountView setHidden:YES];
            
            [self.announceCountView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading).offset(SCREEN_FRAME.size.width * 3/4 + 20);
                make.top.mas_equalTo(tmpTitleScrollView.mas_top).offset(10);
                make.width.height.mas_equalTo(20);
            }];
        }
        
        btn = [[UIButton alloc]initWithFrame:CGRectMake(i * DEFAULTTITLEWIDTH, 0, DEFAULTTITLEWIDTH, DEFAULTTITLEHEIGHT)];
        [btn setTag:i];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i==0?UIColorFromHex(0x02a0f2):UIColorFromHex(0x6c6e6d) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleTabScrollView addSubview:btn];
        [self.titleTabArray addObject:btn];
        
        __weak UIButton     * tmpLastBtn = lastBtn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading);
            else if(i == weakSelf.listCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(tmpLastBtn.mas_trailing);
                make.trailing.mas_equalTo(tmpTitleScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(tmpLastBtn.mas_trailing);
            
            make.top.mas_equalTo(tmpTitleScrollView.mas_top);
            make.bottom.mas_equalTo(tmpTitleScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH);
        }];
        lastBtn = btn;
        
        if (_nSelectedTabBtn == i)
        {
            __weak UIButton * tmpBtn = btn;
            __weak UIScrollView * tmpScrollView = self.titleContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(tmpBtn.mas_centerX);
                make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
                make.width.equalTo(tmpScrollView.mas_width).multipliedBy(0.25);
                make.height.mas_equalTo(@(2));
            }];
        }
    }
    
    //添加滑动内容列表
    UIViewController * ctrl = nil;
    UIViewController * lastCtrl = nil;
    Class classCtrl;
    for (int i = 0 ; i < self.listCtrlArray.count; i++) {
        
        classCtrl = NSClassFromString([self.listCtrlArray objectAtIndex:i]);
        ctrl = [[classCtrl alloc]initWithNibName:[self.listCtrlArray objectAtIndex:i] bundle:nil];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width , 0, SCREEN_FRAME.size.width, self.listScrollView.frame.size.height);
        [self.listScrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        [self.listContentArray addObject:ctrl];
        
        if (i == 1) {
            
            ((MIAnnounceController *)ctrl).delegate = self;
        }
        
        __weak UIViewController * tmpLastCtrl = lastCtrl;
        __weak UIScrollView     * tmpScrollView = self.listScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(tmpScrollView.mas_leading);
            else if(i == weakSelf.listCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
            
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(tmpScrollView);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        }];
        lastCtrl = ctrl;
        
        [self.listScrollView setContentOffset:CGPointMake(_nSelectedTabBtn*SCREEN_FRAME.size.width, 0)];
    }
    
    //添加“编辑”
    [self.navigationItem addEditItemWithTarget:self action:@selector(clickEditAction:)];
    
    UIButton * btnTitle = (UIButton *)([self.navigationItem.rightBarButtonItems lastObject].customView);
    [btnTitle setTitle:self.isFinishEdited?@"编辑":@"完成" forState:UIControlStateNormal];
    [(MIMyMsgController *)[self.listContentArray objectAtIndex:0] canEdit:!self.isFinishEdited];
    [(MIMyMsgController *)[self.listContentArray objectAtIndex:0] loadNewMsg];
}

#pragma mark - 更新UI
- (void)updateUI
{
    //通知
    [self.listScrollView setContentOffset:CGPointMake(_nSelectedTabBtn * SCREEN_FRAME.size.width, 0)];

    //根据需求写死的
    [self.announceCountView setHidden:YES];
    [self.announceCountLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.announceCount]]];
    if (self.announceCount != 0) {
        
        [self.announceCountView setHidden:NO];
    }
    
    [self.myMsgCountView setHidden:YES];
    [self.myMsgCountLabel setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.myMsgCount]]];
    if(self.myMsgCount != 0)
    {
        [self.myMsgCountView setHidden:NO];
    }
    
    //更新公告模块
    if (self.announceCount <= 0)
    {
        [(MIAnnounceController *)[self.listContentArray objectAtIndex:1] setFlagButtonHidden:YES];
    }else
    {
         [(MIAnnounceController *)[self.listContentArray objectAtIndex:1] setFlagButtonHidden:NO];
    }
}

#pragma mark - 选中标题操作
- (void)selectedOption:(UIButton *)sender
{
    for (UIButton * btn in self.titleTabArray) {
        
        if ([btn isEqual:sender]) {
            
            [btn setTitleColor:UIColorFromHex(0x02a0f2) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }else
        {
            [btn setTitleColor:UIColorFromHex(0x6c6e6d) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        }
    }
    
    self.nSelectedTabBtn = [self.titleTabArray indexOfObject:sender];
    
    if (self.nSelectedTabBtn == NotificationMessage) {
        
        [self.navigationItem addEditItemWithTarget:self action:@selector(clickEditAction:)];
        
        UIButton * btnTitle = (UIButton *)([self.navigationItem.rightBarButtonItems lastObject].customView);
        [btnTitle setTitle:self.isFinishEdited?@"编辑":@"完成" forState:UIControlStateNormal];
        [(MIMyMsgController *)[self.listContentArray objectAtIndex:0] canEdit:!self.isFinishEdited];
        [(MIMyMsgController *)[self.listContentArray objectAtIndex:0] loadNewMsg];
    }else
    {
        [self.navigationItem removeRightButton];
    }
    
    [self.view layoutIfNeeded];
    
    __weak UIButton * tmpBtn = sender;
    __weak UIScrollView * tmpScrollView = self.titleContainerScrollView;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(tmpBtn.mas_centerX);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        make.width.equalTo(tmpScrollView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(@(2));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
    [self.listScrollView setContentOffset:CGPointMake(self.nSelectedTabBtn*SCREEN_FRAME.size.width, 0)];
}

#pragma mark - 进行编辑
- (void)clickEditAction:(UIButton*)button
{
    self.isFinishEdited = !self.isFinishEdited;
    UIButton * btnTitle = (UIButton *)([self.navigationItem.rightBarButtonItems lastObject].customView);
    [btnTitle setTitle:self.isFinishEdited?@"编辑":@"完成" forState:UIControlStateNormal];
    
    [(MIAnnounceController *)[self.listContentArray objectAtIndex:self.nSelectedTabBtn] canEdit:!self.isFinishEdited];
}

#pragma mark - 未读消息数
- (void)unReadMsgCount
{
    [[XNMessageModule defaultModule] getUnReadMsgCount];
}

- (void)clickBack:(UIButton *)sender
{
    [super clickBack:sender];
    NSInteger nCount = self.announceCount + self.myMsgCount;
    NSString *totalCount = [NSString stringWithFormat:@"%ld", nCount];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:totalCount forKey:@"totalCount"];
    //通知消息数目的变化
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_MESSAGECENTER_UNREAD_MESSAGE_COUNT object:nil userInfo:dic];
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - 公告消息回调
- (void)MIAnnounceControllerDidRead
{
    self.announceCount = self.announceCount - 1 >= 0?self.announceCount - 1:0;
    
    [self updateUI];
}

#pragma mark - 公告消息回调
- (void)MIAnnounceControllerDidReadAll
{
   [[XNMessageModule defaultModule] getUnReadMsgCount];
}

#pragma mark - 未读消息请求回调
- (void)XNMessageModuleUnreadMsgCountDidReceive:(XNMessageModule *)module
{
    self.announceCount = [[[module unReadMsgMode] objectForKey:XN_MYINFO_MYMESSAGECENTER_UNREADMSG_BULLETIONMSGCOUNT] integerValue];
    self.myMsgCount = [[[module unReadMsgMode] objectForKey:XN_MYINFO_MYMESSAGECENTER_UNREADMSG_PERSIONMSGCOUNT] integerValue];
    
    [self updateUI];
}

- (void)XNMessageModuleUnreadMsgCountDidFailed:(XNMessageModule *)module
{
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];

}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SCREEN_FRAME.size.width;
    
    
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark -cursorView
- (UIView *)cursorView
{
    if (!_cursorView) {
        
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width / 4, 2)];
        [_cursorView setBackgroundColor:MONEYCOLOR];
    }
    return _cursorView;
}

#pragma mark - titleArray
- (NSArray *)titleArray
{
    if (!_titleArray) {
        
        _titleArray = [[NSArray alloc] initWithObjects:@"通知",@"公告", nil];
    }
    return _titleArray;
}

#pragma mark - titleTabArray
- (NSMutableArray *)titleTabArray
{
    if (!_titleTabArray) {
        
        _titleTabArray = [[NSMutableArray alloc]init];
    }
    return _titleTabArray;
}

#pragma mark - listCtrlArray
- (NSArray *)listCtrlArray
{
    if (!_listCtrlArray) {
        
        _listCtrlArray = [[NSArray alloc]initWithObjects:@"MIMyMsgController",@"MIAnnounceController",nil];
    }
    return _listCtrlArray;
}

#pragma mark - listContentArray
- (NSMutableArray *)listContentArray
{
    if (!_listContentArray) {
        
        _listContentArray = [[NSMutableArray alloc]init];
    }
    return _listContentArray;
}

#pragma mark - scrollExitView
- (ScrollViewExitView *)scrollExitView
{
    if (!_scrollExitView) {
        
        _scrollExitView = [[ScrollViewExitView alloc] init];
    }
    return _scrollExitView;
}

@end
