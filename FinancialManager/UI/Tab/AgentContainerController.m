//
//  AgentContainerController.m
//  FinancialManager
//
//  Created by xnkj on 28/08/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AgentContainerController.h"
#import "BundSearchViewController.h"
#import "AgentViewController.h"
#import "ProductViewController.h"
#import "BundListViewController.h"
#import "NewInsuranceViewController.h" //新保险页面

@interface SwitchView: UIView

@property(nonatomic, assign) CGSize intrinsicContentSize;
@end

@implementation SwitchView

@end

@interface AgentContainerController ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL finishedInit;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFirstIn;
@property (nonatomic, strong) NSArray * buttonArray;
@property (nonatomic, strong) NSArray * rankCtrlArray;
@property (nonatomic, strong) BundSearchViewController * bundSearchCtrl;

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet SwitchView * switchView;
@property (nonatomic, weak) IBOutlet UIButton * agentButton;
@property (nonatomic, weak) IBOutlet UIButton * p2pButton;
@property (nonatomic, weak) IBOutlet UIButton * bundButton;
@property (nonatomic, weak) IBOutlet UIButton * insuranceButton;
@property (nonatomic, weak) IBOutlet UILabel  * cursorView;
@end

@implementation AgentContainerController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    // 新手引导
    [self guidePage];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0,safeAreaInsets(self.view).bottom, 0);
        }];
    }
}

///////////
#pragma mark - 自定义方法
////////////////////////////////

//初始化
- (void)initView
{
    self.newNavigationBarColor = [UIColor whiteColor];
    [self.switchView setIntrinsicContentSize:CGSizeMake(287, 42)];
    self.navigationItem.titleView = self.switchView;
    
    self.isFirstIn = true;
    [self createRankView];
    self.finishedInit = true;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

// 新手引导
- (void)guidePage
{
    CGFloat blankY = 20.f;
    if (Device_Is_iPhoneX) {
        blankY += 23.f;
    }

    CGRect blank = CGRectMake(SCREEN_FRAME.size.width / 2 + 70.f, blankY, 70.f, 45.f);
    
    CGFloat imageY = 65.f;
    if (Device_Is_iPhoneX) {
        imageY += 23.f;
    }
    CGRect image = CGRectMake((SCREEN_FRAME.size.width - 257.f) / 2.f + 20.f, imageY, 257.f, 76.f);
    
    //XN_USER_AGENTDETAIL_USER_GUIDE
    if ([_LOGIC canShowGuildViewAt:self withKey:XN_USER_AGENT_CONTAINER_INSURANCE])
    {
        NSArray *a = @[
                       [[UIBezierPath bezierPathWithRoundedRect:blank cornerRadius:5] bezierPathByReversingPath]
                       ];
        
        NSArray *b = @[
                       [UIImage imageNamed:@"XN_USER_AGENT_CONTAINER_INSURANCE.png"],
                       ];
        
        NSArray *c = @[
                       [NSValue valueWithCGRect:image],
                       ];
        
        NewUserGuildController * userGuildController = [[NewUserGuildController alloc]initWithNibName:@"NewUserGuildController" bundle:nil masksPathArray:a guildImagesArray:b guildImageLocationArray:c];
        
        [userGuildController setClickCompleteBlock:^{
            
            [_LOGIC saveValueForKey:XN_USER_AGENT_CONTAINER_INSURANCE Value:@"0"];
            
            [[AppFramework getGlobalHandler] removePopupView];
        }];
        
        [_KEYWINDOW addSubview:userGuildController.view];
        [self addChildViewController:userGuildController];
        
        __weak UIWindow * tmpWindow = [[UIApplication sharedApplication] keyWindow];
        [userGuildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpWindow);
        }];
        
        [AppFramework getGlobalHandler].currentPopup = userGuildController.view;
        return;
    }
}

//TODO:- 构建滑动容器
- (void)createRankView
{
    
    BaseViewController * ctrl = nil;
    __weak UIViewController * lastCtrl = nil;
    __weak UIScrollView * tmpScrollView = self.scrollView;
    weakSelf(weakSelf)
    for(NSInteger index = 0 ; index < self.rankCtrlArray.count; index ++)
    {
        
        ctrl = [self.rankCtrlArray objectAtIndex:index];
        [self.scrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (index == 0)
                make.leading.mas_equalTo(tmpScrollView.mas_leading);
            else if(index == weakSelf.rankCtrlArray.count - 1)
            {
                make.leading.mas_equalTo(lastCtrl.view.mas_trailing);
                make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            }
            else
                make.leading.mas_equalTo(lastCtrl.view.mas_trailing);
            
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.equalTo(tmpScrollView);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
        }];
        lastCtrl = ctrl;
    }
    
    [self.scrollView layoutIfNeeded];
    [self clickRankButton:self.buttonArray[self.selectedIndex]];
}

//选中按钮
- (IBAction)clickRankButton:(UIButton *)sender
{
    // self.agentButton,self.p2pButton,self.bundButton,self.insuranceButton
    if (sender == self.agentButton) {
        [XNUMengHelper umengEvent:@"T_1_1"];
    } else if (sender == self.p2pButton) {
        [XNUMengHelper umengEvent:@"T_2_1"];
    } else if (sender == self.bundButton) {
        [XNUMengHelper umengEvent:@"T_3_1"];
    } else if (sender == self.insuranceButton) {
        [XNUMengHelper umengEvent:@"T_4_1"];
    }
    
    NSInteger index = 0;
    for (UIButton * btn in self.buttonArray) {
        
        if([sender isEqual:btn])
        {
            if ([self.bundButton isEqual:sender]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:XN_DEFAULT_TYPE_FUND_LIST_NOTIFICATION object:@{@"isFirstIn":[NSNumber numberWithBool:self.isFirstIn]}];
                self.isFirstIn = false;
                [self.navigationItem addRightBarItemWithImage:@"XN_Bund_Filter_Right_icon@2x.png"
                                                        frame:CGRectMake(SCREEN_FRAME.size.width - 20 - 8, 24,20, 20)
                                                       target:self
                                                       action:@selector(clickFilterAction:)];
            }else
            {
                [self.navigationItem removeRightButton];
                [self.bundSearchCtrl.view removeFromSuperview];
                self.bundSearchCtrl = nil;
            }
            
            [sender setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
            [self.scrollView setContentOffset:CGPointMake(SCREEN_FRAME.size.width * index, 0)];
            
            __weak UIButton * tmpSender = sender;
            [self.cursorView mas_remakeConstraints:^(MASConstraintMaker *make) {
               
                make.centerX.equalTo(tmpSender);
                make.top.mas_equalTo(tmpSender.mas_bottom).offset(4);
                make.width.mas_equalTo(42);
                make.height.mas_equalTo(2);
            }];
            
            [self.switchView layoutIfNeeded];
        }else
        {
            [btn setTitleColor:UIColorFromHex(0xcbdfff) forState:UIControlStateNormal];
        }
        
        index = index + 1;
    }
}

//过滤
- (void)clickFilterAction:(UIButton *)sender
{
    if (!self.bundSearchCtrl) {
        
        BundListViewController * ctrl = self.rankCtrlArray[2];
        
        self.bundSearchCtrl = [[BundSearchViewController alloc]initWithNibName:@"BundSearchViewController"
                                                                        bundle:nil
                                                            selectedPeriodType:ctrl.selectedPeriodTypeString
                                                          selectedPeriodString:ctrl.selectedPeriodValueString
                                                        selectedFundTypeString:ctrl.selectedFundTypeString
                                                   selectedFundTypeValueString:ctrl.selectedFundTypeValueString];
        weakSelf(weakSelf)
        [self.bundSearchCtrl setInitClickExitSearchBlock:^{
            
            [weakSelf.bundSearchCtrl.view removeFromSuperview];
            weakSelf.bundSearchCtrl = nil;
        }];
        
        [self.view addSubview:self.bundSearchCtrl.view];
        [self.bundSearchCtrl addObserver];
        
        [self.bundSearchCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.edges.equalTo(weakSelf.view);
        }];
    }
}

//滑动到指定控制器
- (void)selectedAtIndex:(NSInteger)index
{
    if(self.finishedInit){
        
        [self clickRankButton:self.buttonArray[index]];
    }else
    {
        self.selectedIndex = index;
    }
}

#pragma mark - 刷新首页
- (void)switchToHomePageRefresh
{
    if (self.bundSearchCtrl) {
        
        [self.bundSearchCtrl.view removeFromSuperview];
        self.bundSearchCtrl = nil;
    }
}

#pragma makr - 切换到猎财
- (void)switchToLeiCaiRefresh
{
    if (self.bundSearchCtrl) {
        
        [self.bundSearchCtrl.view removeFromSuperview];
        self.bundSearchCtrl = nil;
    }
}

#pragma mark - 刷新我的
- (void)switchToMyInfoRefresh
{
    if (self.bundSearchCtrl) {
        
        [self.bundSearchCtrl.view removeFromSuperview];
        self.bundSearchCtrl = nil;
    }
}

////////////
#pragma mark - scrollViewDelegate
/////////////////////////////////

//scrollviewdelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / SCREEN_FRAME.size.width;
    
    [self clickRankButton:self.buttonArray[pageIndex]];
}

////////////
#pragma mark - setter/getter
////////////////////////////////

//buttonArray
- (NSArray *)buttonArray
{
    if (!_buttonArray) {
        
        _buttonArray = [[NSArray alloc]initWithObjects:self.agentButton,self.p2pButton,self.bundButton,self.insuranceButton, nil];
    }
    return _buttonArray;
}

//rankCtrlArray
- (NSArray *)rankCtrlArray
{
    if (!_rankCtrlArray) {
        
        //平台
        AgentViewController *agentCtrl = [[AgentViewController alloc]initWithNibName:@"AgentViewController" bundle:nil];
        
        //网贷
        ProductViewController *productCtrl = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil];
        
        //基金
        BundListViewController *bundListCtrl = [[BundListViewController alloc]initWithNibName:@"BundListViewController" bundle:nil];
        
        //保险
        NewInsuranceViewController *newInsuranceCtrl = [[NewInsuranceViewController alloc] init];
        
        _rankCtrlArray = [[NSArray alloc]initWithObjects:agentCtrl,productCtrl,bundListCtrl,newInsuranceCtrl, nil];
    
    }
    
    return _rankCtrlArray;
}



@end
