//
//  DispatchRedPacketContainerViewController.m
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CouponContainerViewController.h"
#import "RedPacketViewController.h"
#import "LevelCouponViewController.h"
#import "ComissionCouponViewController.h"

#import "CustomScrollPanView.h"
#import "UINavigationItem+Extension.h"

#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define DEFAULTTAG 0x111111
#define DEFAULTTITLEHEIGHT 50.0f
#define NEWWIDTH (SCREEN_FRAME.size.width / self.titleArray.count)
#define DEFAULTTITLEWIDTH (self.titleArray.count>=4?80 * (SCREEN_FRAME.size.width / 320):NEWWIDTH)

@interface CouponContainerViewController ()<UIScrollViewDelegate,XNMyInformationModuleObserver>

@property (nonatomic, assign) NSInteger             redPacketCount;
@property (nonatomic, assign) NSInteger             levelCouponCount;
@property (nonatomic, assign) NSInteger             comissionCouponCount;
@property (nonatomic, assign) CouponType          currentCouponType;
@property (nonatomic, strong) NSMutableArray      * titleArray;
@property (nonatomic, strong) NSArray             * contentCtrlArray;
@property (nonatomic, strong) NSMutableArray      * titleObjArray;

@property (nonatomic, strong) UIView              * cursorView;
@property (nonatomic, strong) UIView              * screenEdgePanGestureView;

@property (nonatomic, weak) IBOutlet UIScrollView * titleContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * headContainerScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView * contentContainerScrollView;
@end

@implementation CouponContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentRedPacketType:(CouponType)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.currentCouponType = type;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.currentCouponType = MyRedPacketType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
}

//////////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    self.title = @"我的优惠券";
    [self.navigationItem addRightBarItemWithTitle:@"使用说明" titleColor:[UIColor whiteColor] target:self action:@selector(couponExpain)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRedPacket) name:XN_RED_PACKET_DISPATCH_SUCCESS object:nil];
    
    [self buildView];
    
    //网络请求
    [[XNMyInformationModule defaultModule] addObserver:self];
    [[XNMyInformationModule defaultModule] requestCouponCount];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//构建视图
- (void)buildView
{
    [self.headContainerScrollView addSubview:self.cursorView];
    [self.titleContainerScrollView setContentSize:CGSizeMake(DEFAULTTITLEWIDTH * self.titleArray.count, 0)];
    
    weakSelf(weakSelf)
    //构建title
    UIButton * titleButton = nil;
    UIButton * lastTitleButton = nil;
    for (NSInteger i = 0; i < self.titleArray.count; i++ ) {
        
        titleButton = [[UIButton alloc]initWithFrame:CGRectMake(i *  DEFAULTTITLEWIDTH, 0, DEFAULTTITLEWIDTH, DEFAULTTITLEHEIGHT)];
        [titleButton setTag:i+DEFAULTTAG];
        [titleButton setBackgroundColor:[UIColor whiteColor]];
        [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleButton setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [titleButton setTitleColor:i==self.currentCouponType?JFZ_COLOR_BLUE:JFZ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleContainerScrollView addSubview:titleButton];
        [self.titleObjArray addObject:titleButton];
        
        __weak UIScrollView * tmpTitleScrollView = self.titleContainerScrollView;
        __weak UIButton     * tmpLastButton = lastTitleButton;
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
            {
                make.leading.mas_equalTo(tmpTitleScrollView.mas_leading);
            }else if(i == [weakSelf.titleArray  count] - 1)
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
                make.trailing.mas_equalTo(tmpTitleScrollView.mas_trailing);
            }else
            {
                make.leading.mas_equalTo(tmpLastButton.mas_trailing);
            }
            
            make.top.mas_equalTo(tmpTitleScrollView.mas_top);
            make.bottom.mas_equalTo(tmpTitleScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH);
        }];
        lastTitleButton = titleButton;
        
        if (i == self.currentCouponType) {
            
            tmpLastButton = lastTitleButton;
            __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
            [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(tmpLastButton.mas_centerX);
                make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
                make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.5);
                make.height.mas_equalTo(@(2));
            }];
        }

    }
    
    //构建内容视图
    UIViewController * lastCtrl = nil;
    for (NSInteger i = 0 ; i < self.contentCtrlArray.count ; i ++ ) {
        
        UIViewController * ctrl = [self.contentCtrlArray objectAtIndex:i];
        ctrl.view.frame = CGRectMake(i * SCREEN_FRAME.size.width , 0, SCREEN_FRAME.size.width, self.contentContainerScrollView.frame.size.height);
        [self.contentContainerScrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        
        __weak UIViewController * tmpLastCtrl = lastCtrl;
        __weak UIScrollView     * tmpCtrlContainerScrollView = self.contentContainerScrollView;
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0)
                make.leading.mas_equalTo(tmpCtrlContainerScrollView.mas_leading);
            else if(i == weakSelf.contentCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(tmpCtrlContainerScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(tmpLastCtrl.view.mas_trailing);
            
            make.top.mas_equalTo(tmpCtrlContainerScrollView.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(tmpCtrlContainerScrollView);
            make.bottom.mas_equalTo(tmpCtrlContainerScrollView.mas_bottom);
        }];
        lastCtrl = ctrl;
    }
    [self.contentContainerScrollView layoutIfNeeded];
    
    [self.contentContainerScrollView setContentOffset:CGPointMake(self.currentCouponType * SCREEN_FRAME.size.width, 0)];
}

//更新标题
- (void)updateTitle
{
    NSMutableArray * titleComposeArray = [NSMutableArray array];
   
    [titleComposeArray addObject:[NSString stringWithFormat:@"%@ (%@)",self.titleArray[0], [NSNumber numberWithInteger:self.redPacketCount]]];
    [titleComposeArray addObject:[NSString stringWithFormat:@"%@ (%@)",self.titleArray[1], [NSNumber numberWithInteger:self.levelCouponCount]]];
    [titleComposeArray addObject:[NSString stringWithFormat:@"%@ (%@)",self.titleArray[2], [NSNumber numberWithInteger:self.comissionCouponCount]]];
    
    UIButton * btn = nil;
    for (NSInteger index = 0 ; index < self.titleObjArray.count; index ++) {
        
        btn = [self.titleObjArray objectAtIndex:index];
        [btn setTitle:[titleComposeArray objectAtIndex:index] forState:UIControlStateNormal];
    }
}

//选中操作
- (void)selectedOption:(UIButton *)sender
{
    for (UIButton * titleButton in self.titleObjArray) {
        
        if ([titleButton isEqual:sender]) {
            
            [titleButton setTitleColor:JFZ_COLOR_BLUE forState:UIControlStateNormal];
        }else
        {
            [titleButton setTitleColor:JFZ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
        }
    }
    
    NSInteger index = [self.titleObjArray indexOfObject:sender];
    
    __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
    __weak UIButton * titleButtonTmp = sender;
    [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(titleButtonTmp.mas_centerX);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.5);
        make.height.mas_equalTo(@(2));
    }];
    
    [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
        
        [self.view layoutIfNeeded];
        [self.contentContainerScrollView setContentOffset:CGPointMake(index*SCREEN_FRAME.size.width, 0)];
    }];
}

//刷新红包
- (void)refreshRedPacket
{
   [[XNMyInformationModule defaultModule] requestCouponCount];
    
    RedPacketViewController * redPacketCtrl = (RedPacketViewController *)[self.contentCtrlArray objectAtIndex:0];
    [redPacketCtrl loadDatas];
}

//使用说明
- (void)couponExpain
{
     UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[_LOGIC getWebUrlWithBaseUrl:@"/pages/message/userManual.html"] requestMethod:@"Get"];
    
    [_UI pushViewControllerFromRoot:webCtrl animated:YES];
}

///////////////////
#pragma mark - 组件回调
//////////////////////////////////////

#pragma mark - uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.contentContainerScrollView]) {
        
        NSInteger index = (int)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        
        UIButton * sender = [self.titleObjArray objectAtIndex:index];
        for (UIButton * titleButton in self.titleObjArray) {
            
            if ([titleButton isEqual:sender]) {
                
                [titleButton setTitleColor:JFZ_COLOR_BLUE forState:UIControlStateNormal];
                
            }else
            {
                [titleButton setTitleColor:JFZ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
            }
        }
        
        [self.view layoutIfNeeded];
        
        __weak UIScrollView * tmpScrollView = self.headContainerScrollView;
        __weak UIButton * btnTmp = sender;
        [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(btnTmp.mas_centerX);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
            make.width.mas_equalTo(DEFAULTTITLEWIDTH * 0.5);
            make.height.mas_equalTo(@(2));
        }];
        
        [UIView animateWithDuration:VIEWANIMATIONDURATION animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
}

///////////////////
#pragma mark - 网络回调
//////////////////////////////////////

//优惠券数量
- (void)XNMyInfoModuleCouponCountDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    self.redPacketCount = [module.redPacketCount integerValue];
    self.levelCouponCount = [module.levelCouponCount integerValue];
    self.comissionCouponCount = [module.comissionCouponCount integerValue];
    
    [self updateTitle];
}

- (void)XNMyInfoModuleCouponCountDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

///////////////////
#pragma mark - 懒加载
//////////////////////////////////////

#pragma mark - titleArray
- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"红包",@"职级券",@"加佣券", nil];
    }
    return _titleArray;
}

#pragma mark - titleObjArray
- (NSMutableArray *)titleObjArray
{
    if (!_titleObjArray) {
        
        _titleObjArray = [[NSMutableArray alloc]init];
    }
    return _titleObjArray;
}

#pragma mark - contentCtrlArray
- (NSArray *)contentCtrlArray
{
    if (!_contentCtrlArray) {
        
        RedPacketViewController  *redPacketCtrl = [[RedPacketViewController alloc]initWithNibName:@"RedPacketViewController" bundle:nil];
       
        LevelCouponViewController * levelCtrl = [[LevelCouponViewController alloc]initWithNibName:@"LevelCouponViewController" bundle:nil];
        
        ComissionCouponViewController * comissionCtrl = [[ComissionCouponViewController alloc]initWithNibName:@"ComissionCouponViewController" bundle:nil];
        
        _contentCtrlArray = [[NSMutableArray alloc]initWithObjects:redPacketCtrl,levelCtrl,comissionCtrl, nil];
    }
    
    return _contentCtrlArray;
}

#pragma mark -cursorView
- (UIView *)cursorView
{
    if (!_cursorView) {
        
        _cursorView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_FRAME.size.width / 4, 2)];
        [_cursorView setBackgroundColor:MONEYCOLOR];
        
    }
    
    return _cursorView;
}

@end
