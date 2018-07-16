//
//  SignViewController.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/10.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignViewController.h"
#import "SignCalendarViewController.h"
#import "YetSignViewController.h"
#import "SignRecordViewController.h"
#import "SignRecordViewController.h"
#import "RecommendViewController.h"

#import "SignAnimationView.h"
#import "SignCalendarModule.h"

#import "UserSignMsgModel.h"
#import "SignShareModel.h"
#import "SignShareInfoModel.h"

#import "YetSignSuperView.h"
#import "SignShareSucceeView.h"
#import "SignShareAwardView.h"

#import "UINavigationBar+Background.h"
#import "UINavigationItem+Extension.h"

#import "WeChatManager.h"
#import "QQManager.h"

#import "XNUserInfo.h"
#import "XNUserModule.h"


#define SCALE (SCREEN_FRAME.size.width / 375.f)
#define BG_SCROLLVIEW_SCALE ((742.f * SCREEN_FRAME.size.width) / 375)

@interface SignViewController () <SignAnimationViewDelegate, YetSignSuperViewDelegate, RecommendViewControllerDelegate, SignShareSucceeViewDelegate, SignShareAwardViewDelegate>

@property (nonatomic, strong) NSMutableArray *animationImgArr;
@property (nonatomic, strong) SignAnimationView *signAnimationView;
@property (nonatomic, strong) RecommendViewController *recommendVC;

@property (nonatomic, strong) SignShareSucceeView *shareSucceeView;
@property (nonatomic, strong) SignShareAwardView  *signShareAwardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;

@property (weak, nonatomic) IBOutlet UIImageView *coinImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coinImgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coinImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supSignViewHeight;

@property (weak, nonatomic) IBOutlet UIView *supSignView;
@property (weak, nonatomic) IBOutlet UIView *supView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *signDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *supScrollView;

@property (nonatomic, strong) YetSignSuperView *yetSignSuperView;

/*** 签到分享的参数字典 **/
@property (nonatomic, strong) NSMutableDictionary *shareDic;

/*** 分享的金额 **/
@property (nonatomic, copy) NSString *shareDesc;

@end

@implementation SignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取签到信息
    [[SignCalendarModule defaultModule] userSignMessage];
}

- (void)dealloc
{
    [[SignCalendarModule defaultModule] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////
#pragma mark - custom method
//////////////////////////////////

- (void)initView
{
    //添加网络请求观察者
    [[SignCalendarModule defaultModule] addObserver:self];
    
    self.supViewHeight.constant = BG_SCROLLVIEW_SCALE;
    [self.supScrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    
    [self.view addSubview:self.recommendVC.view];
    
    //weakSelf(weakSelf)
    [self.recommendVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];

    
    //适配比例
    self.coinImgViewWidth.constant = 106.f * SCALE;
    self.coinImgViewHeight.constant = 103.f * SCALE;
    self.supSignViewHeight.constant = 220.f * SCALE;
    
    if (@available(iOS 11.0, *)) {
        
        self.supScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
       
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /*** 添加分享是否成功通知 **/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSucceed) name:Sign_Share_Succeed object:nil];
}

#pragma mark - 分享成功回调
- (void)shareSucceed
{
    // 1. 弹出神秘奖励
    [self.shareSucceeView show:self.view];
}

// 活动规则
- (IBAction)ruleClick
{
    // https://preliecai.toobei.com/pages/message/signRule.html
    
    NSString * url = [_LOGIC getWebUrlWithBaseUrl:@"/pages/message/signRule.html"];
    UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:url requestMethod:@"GET"];
    [webViewController setNeedNewSwitchViewAnimation:YES];
    [_UI pushViewControllerFromRoot:webViewController animated:YES];
}

// 返回按钮
- (IBAction)backClick
{
    [_UI popViewControllerFromRoot:YES];
}

// 日历
- (IBAction)calendarClick
{
    SignCalendarViewController *signCalendarVC = [[SignCalendarViewController alloc] init];
    [signCalendarVC setNeedNewSwitchViewAnimation:YES];
    [_UI pushViewControllerFromRoot:signCalendarVC animated:YES];
}

// 签到
- (IBAction)signClick
{
    [XNUMengHelper umengEvent:@"S_7_2"];
    
    // 请求签到接口
    [[SignCalendarModule defaultModule] userSign];
  
    // 开启签到动画
    //[self.signAnimationView startAnimation];
}

// 查看签到奖励记录
- (IBAction)checkSignRecordClick
{
    SignRecordViewController *signRecordVC = [[SignRecordViewController alloc] init];
    [signRecordVC setNeedNewSwitchViewAnimation:YES];
    [_UI pushViewControllerFromRoot:signRecordVC animated:YES];
}

// 成功签到之后 视图更新变化
- (void)succeedSignChangeView:(BOOL)isShare
{
    [self.supSignView removeFromSuperview];
    [self.bgimageView setImage:[UIImage imageNamed:@"sign_succeed_bg_img.png"]];
    [self.supView addSubview:self.yetSignSuperView];
    
    [UIView animateWithDuration:1.5 animations:^{
        self.yetSignSuperView.alpha = 1;
    } completion:^(BOOL finished) {
        if (isShare) {
            [self.recommendVC show:SignShareShow];
        }
    }];
}

/////////////////////////////////
#pragma mark - protocol method
//////////////////////////////////

// 签到领红包弹出视图
- (void)signAnimationViewDid:(SignAnimationView *)animationView btnClickType:(SignAnimationViewBtnClickType)clickType
{
    [self.signAnimationView animationHide];
    
    if (clickType == Share_Btn_Click) { // 分享
        
        [self succeedSignChangeView:YES];
        // 获取分享信息
        [[SignCalendarModule defaultModule] shareMessage];
        
    } else if (clickType == Close_Btn_Click) { // 关闭
        
        [self succeedSignChangeView:NO];
    }
    
    // 签到领红包弹窗出现后 （点击关闭，或者分享按钮再获取一次签到信息数据）
    [[SignCalendarModule defaultModule] userSignMessage];
}

- (void)signAnimationViewHidden:(SignAnimationView *)signAnimationView
{
    [self.signAnimationView removeFromSuperview];
}

- (void)yetSignSuperViewDid:(YetSignSuperView *)yetSignSuperView ClickType:(YetSignSuperViewClickType)clickType
{
    if (clickType == YetSign_Share_Type) { // 签到分享
        
        // 获取分享信息
        [[SignCalendarModule defaultModule] shareMessage];
        
    } else if (clickType == YetSign_Check_Type) { // 查看累积奖金
        
        SignRecordViewController *signRecordVC = [[SignRecordViewController alloc] init];
        [signRecordVC setNeedNewSwitchViewAnimation:YES];
        [_UI pushViewControllerFromRoot:signRecordVC animated:YES];
    }
}

// 分享视图协议方法
- (NSDictionary *)recommendViewControllerSignDid:(RecommendViewController *)controller shareType:(RecommendViewControllerType)clickType
{
    if (clickType == RSignShareWeChatF) { //微信好友
        
        /**** 拼接签到分享的参数 **/
        NSString *shareTitle = @"猎财大师签到,领现金奖励"; //平台名称
        NSString *shareDesc = [NSString stringWithFormat:@"我在猎财大师签到已领%@元现金，你也跟我一起来吧！天天签到,天天领现金", self.shareDesc];
       
        NSString * userName = [[[XNUserModule defaultModule] userMode] userName];
        NSString * mobile = [[[XNUserModule defaultModule] userMode] mobile];
        NSString *shareLink = [NSString new];
        
        if ([NSObject isValidateObj:userName]) {
            
            // https://preliecai.toobei.com/pages/guide/sign.html?recommendCode=xxxx&name=xxxx
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, userName]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, userName]];
            
        } else {
            
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, mobile]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, mobile]];
        }
        
        NSString *shareImgurl = @"https://image.toobei.com/dfa3e35be331f6ec67566130f67820b9?f=png";
        return @{@"shareLink":shareLink,
                 @"shareTitle":shareDesc, //
                 @"shareDesc":shareTitle, // shareTitle
                 @"shareImgurl":shareImgurl
                 };
    
    } else if (clickType == RSignShareWeChatC) { //微信朋友圈
        
        //self.isShare = YES;
        
        /**** 拼接签到分享的参数 **/
        NSString *shareTitle = @"猎财大师签到,领现金奖励"; //平台名称
        NSString *shareDesc = [NSString stringWithFormat:@"我在猎财大师签到已领%@元现金，你也跟我一起来吧！天天签到,天天领现金", self.shareDesc];
        
        NSString * userName = [[[XNUserModule defaultModule] userMode] userName];
        NSString * mobile = [[[XNUserModule defaultModule] userMode] mobile];
        
        NSString *shareLink = [NSString new];
        if ([NSObject isValidateObj:userName]) {
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, userName]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, userName]];
            
        } else {
            
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, mobile]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, mobile]];
        }
        
        NSString *shareImgurl = @"https://image.toobei.com/dfa3e35be331f6ec67566130f67820b9?f=png";
        
        
        return @{@"shareLink":shareLink,
                 @"shareTitle":shareDesc, //
                 @"shareDesc":shareTitle,   // shareTitle
                 @"shareImgurl":shareImgurl
                 };
        
    } else if (clickType == RSignShareQQF) { // QQ好友
        
        //self.isShare = YES;
        
        /**** 拼接签到分享的参数 **/
        NSString *shareTitle = @"猎财大师签到,领现金奖励"; //平台名称
        NSString *shareDesc = [NSString stringWithFormat:@"我在猎财大师签到已领%@元现金，你也跟我一起来吧！天天签到,天天领现金", self.shareDesc];
        
        NSString * userName = [[[XNUserModule defaultModule] userMode] userName];
        NSString * mobile = [[[XNUserModule defaultModule] userMode] mobile];
        
        NSString *shareLink = [NSString new];
        if ([NSObject isValidateObj:userName]) {
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, userName]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, userName]];
            
        } else {
            
            //shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/user/inviteRegister.html?recommendCode=%@&name=%@&source=forSign", mobile, mobile]];
            
            shareLink = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"/pages/guide/sign.html?recommendCode=%@&name=%@", mobile, mobile]];
            
        }
        
        NSString *shareImgurl = @"https://image.toobei.com/dfa3e35be331f6ec67566130f67820b9?f=png";
        
        return @{@"shareLink":shareLink,
                 @"shareTitle":shareDesc, // shareDesc
                 @"shareDesc":shareTitle,   // shareTitle
                 @"shareImgurl":shareImgurl
                 };
    }
    
    return nil;
    
}

- (void)signShareSucceeViewDid:(SignShareSucceeView *)signShareView
{
    [[SignCalendarModule defaultModule] shareSign];
}

#pragma mark - 查看我的记录
- (void)checkSignShareSucceeViewDid:(SignShareSucceeView *)signShareView
{
    [self checkSignRecordClick];
}


- (void)signShareAwardViewDid:(SignShareAwardView *)signShareAwardView
{
    // 获取签到信息
    [[SignCalendarModule defaultModule] userSignMessage];
}

///////////////////////////
#pragma mark - 网络请求回调
///////////////////////////////

// 用户签到
- (void)userSignDidReceive:(SignCalendarModule *)module
{
    // 签到成功之后开始执行动画
    self.coinImgView.hidden = YES;
    
    // 赋值数据
    self.signAnimationView.userSignModel = module.userSignModel;
    
    [self.signAnimationView startAnimation];
}

- (void)userSignDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    } else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

// 签到信息
- (void)userSignInfoReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if ([module.userSignMsgModel.hasSigned integerValue] == 1) { //今日已签到
        
        self.yetSignSuperView.userSignMsgModel = module.userSignMsgModel;
        [self succeedSignChangeView:NO];
    
    } else {
        
        NSArray *propertyArray = @[@{@"range": @"连续签到",
                                     @"color": UIColorFromHex(0xFFFFFF),
                                     @"font": [UIFont fontWithName:@"DINOT" size:12]},
                                   @{@"range": [NSString stringWithFormat:@"%@", module.userSignMsgModel.consecutiveDays],
                                     @"color": UIColorFromHex(0XFFFFFF),
                                     @"font": [UIFont fontWithName:@"DINOT" size:18]},
                                   @{@"range": @"(天)",
                                     @"color": UIColorFromHex(0XFFFFFF),
                                     @"font": [UIFont fontWithName:@"DINOT" size:12]}
                                   ];
         // 赋值页面上的数据
        NSAttributedString *string = [NSString getAttributeStringWithAttributeArray:propertyArray];
        self.signDayLabel.attributedText = string;
        
        
        // 赋值页面上的数据
        self.signDayLabel.text = [NSString stringWithFormat:@"连续签到%@(天)", module.userSignMsgModel.consecutiveDays];
    }
}

- (void)userSignInfoDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

// 分享
- (void)userSignShareReceive:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    //奖励类型 0：没有奖励 1：翻倍 2：红包
    if ([module.signShareModel.prizeType integerValue] == 0) {
    
        self.signShareAwardView.awardType = No_Award;
        self.signShareAwardView.signShareModel = module.signShareModel;
        [self.signShareAwardView show];
    }
    
    else if ([module.signShareModel.prizeType integerValue] == 1) { //获取的翻倍奖励金
        
        self.signShareAwardView.awardType = Coin_Award;
        self.signShareAwardView.signShareModel = module.signShareModel;
        [self.signShareAwardView show];
    }
    
    else if ([module.signShareModel.prizeType integerValue] == 2) { //获得一个奖励红包
        
        self.signShareAwardView.awardType = RedBack_Award;
        self.signShareAwardView.signShareModel = module.signShareModel;
        [self.signShareAwardView show];
    }
}

- (void)userSignShareDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];

    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

// 分享信息
- (void)userSignShareInfoReceive:(SignCalendarModule *)module
{
    self.shareDesc = module.signShareInfoModel.shareDesc;
    
    //拿到分享信息里面的金额
    [self.recommendVC show:SignShareShow];
}

- (void)userSignShareInfoDidFailed:(SignCalendarModule *)module
{
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////////////////////////
#pragma mark - getter / setter
//////////////////////////////////

- (SignAnimationView *)signAnimationView
{
    if (!_signAnimationView) {
        _signAnimationView = [SignAnimationView signAnimationView];
        _signAnimationView.frame = self.supView.frame;
        _signAnimationView.delegate = self;
        [self.supView addSubview:_signAnimationView];
    }
    return _signAnimationView;
}

- (YetSignSuperView *)yetSignSuperView
{
    if (!_yetSignSuperView) {
        _yetSignSuperView = [YetSignSuperView yetSignSuperView];
        
        _yetSignSuperView.frame = CGRectMake(0, self.supSignView.mj_y + (self.coinImgView.width / 2.f), SCREEN_FRAME.size.width, 185.f);
        _yetSignSuperView.delegate = self;
    }
    return _yetSignSuperView;
}

- (RecommendViewController *)recommendVC
{
    if (!_recommendVC) {
        _recommendVC = [[RecommendViewController alloc] init];
        _recommendVC.proDelegate = nil;
        _recommendVC.agentDelegate = nil;
        _recommendVC.signDelegate = self;
    }
    return _recommendVC;
}

- (SignShareSucceeView *)shareSucceeView
{
    if (!_shareSucceeView) {
        _shareSucceeView = [SignShareSucceeView signShareSucceeView];
        _shareSucceeView.delegate = self;
    }
    return _shareSucceeView;
}

- (SignShareAwardView *)signShareAwardView
{
    if (!_signShareAwardView) {
        _signShareAwardView = [SignShareAwardView signShareAwardView];
        _signShareAwardView.delegate = self;
    }
    return _signShareAwardView;
}

- (NSMutableDictionary *)shareDic
{
    if (!_shareDic) {
        _shareDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _shareDic;
}


@end
