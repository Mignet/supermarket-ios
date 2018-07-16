//
//  MICheckBankCardInfoController.m
//  FinancialManager
//
//  Created by xnkj on 31/07/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MICheckBankCardInfoController.h"
#import "CustomerServiceController.h"
#import "CoreTextLabel.h"

#import "XNGetUserBindBankCardInfoMode.h"
#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface MICheckBankCardInfoController ()

@property (nonatomic, strong) CustomerServiceController * phoneCtrl;

@property (nonatomic, weak) IBOutlet UIView * headerBindStatusView;

@property (nonatomic, weak) IBOutlet UILabel * bankNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * bankNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel * phoneLabel;

@property (nonatomic, weak) IBOutlet UILabel * userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * userIdentifyLabel;
@property (nonatomic, weak) IBOutlet UIView  * bindBankInfoView;
@property (nonatomic, weak) IBOutlet UIView  * userInfoView;

@property (nonatomic, weak) IBOutlet UIButton           * remindBtn;
@property (nonatomic, weak) IBOutlet UIView             * remindView;

@property (nonatomic, weak) IBOutlet UIButton           * remind4Btn;
@property (nonatomic, weak) IBOutlet UIView             * remind4View;

@property (nonatomic, weak) IBOutlet UIScrollView * containerScrollView;
@end

@implementation MICheckBankCardInfoController

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
    [[XNAddBankCardModule defaultModule] removeObserver:self];
}

#pragma mark - 自定义方法汇总
//初始化
- (void)initView
{
    self.title = @"实名认证及银行卡管理";
    
    //请求绑卡信息
    [[XNAddBankCardModule defaultModule] addObserver:self];
    [[XNAddBankCardModule defaultModule] getUserBindBankCardInfo];
    [self.view showGifLoading];
    
    //组件视图
    [self showUI];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//拼装UI
- (void)showUI
{
    [self.containerScrollView addSubview:self.headerBindStatusView];
    [self.containerScrollView addSubview:self.bindBankInfoView];
    [self.containerScrollView addSubview:self.userInfoView];
    
    if (IOS_IPHONE5OR4_SCREEN) {
        
        [self.containerScrollView addSubview:self.remind4View];
    }else{
    
        [self.containerScrollView addSubview:self.remindView];
    }
    
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    [self.headerBindStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpScrollView.mas_top);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(@(145));
        make.width.mas_equalTo(tmpScrollView.mas_width);
    }];
    
    __weak UIView * tmpView = self.headerBindStatusView;
    [self.bindBankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(156);
    }];
    
    tmpView = self.bindBankInfoView;
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(@(104));
    }];
    
    tmpView = self.userInfoView;
    
    CGFloat width = 0.0f;
    if (IOS_IPHONE5OR4_SCREEN) {
        
        width = 320.0f;
        
        //更新电话号
        [self.remind4Btn setTitle:[[[XNCommonModule defaultModule]  configMode] serviceTelephone] forState:UIControlStateNormal];
        
        CGFloat interval = SCREEN_FRAME.size.height - 279 - 156 - 10 - 45 - 64;
        interval = interval < 20? 20:interval;
        [self.remind4View mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(tmpScrollView);
            make.top.mas_equalTo(tmpView.mas_bottom).offset(interval);
            make.height.mas_equalTo(@(45));
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(-10);
        }];
    }else
    {
        width = 375.0f;
        
        //更新电话号
        [self.remindBtn setTitle:[[[XNCommonModule defaultModule] configMode] serviceTelephone] forState:UIControlStateNormal];
        
        CGFloat interval = SCREEN_FRAME.size.height - 279 - 156 - 20 - 45 - 64;
        [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(tmpView.mas_bottom).offset(interval);
            make.height.mas_equalTo(@(45));
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(-20);
        }];
    }
}

//打电话
- (IBAction)clickPhone:(id)sender
{
    [self.view addSubview:self.phoneCtrl.view];
    [self.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

//更新信息
- (void)updateData
{
    CGFloat height = 104;
    if ([NSObject isValidateInitString:[[[XNAddBankCardModule defaultModule] userBindCardInfoMode] bankName]]) {
    
        height = 156;
        
        self.bankNameLabel.text = [[[XNAddBankCardModule defaultModule] userBindCardInfoMode] bankName];
    }
    self.bankNumberLabel.text = [[[[XNAddBankCardModule defaultModule] userBindCardInfoMode] bankCard] convertToOtherSecurityBankCardNumber];
    self.phoneLabel.text = [[[[XNAddBankCardModule defaultModule] userBindCardInfoMode] userPhoneNumber] convertToSecurityPhoneNumber];
    self.userNameLabel.text = [[[[XNAddBankCardModule defaultModule] userBindCardInfoMode] userName] convertToSecurityUserName];
    self.userIdentifyLabel.text = [[[[XNAddBankCardModule defaultModule] userBindCardInfoMode] idCard] convertToSecurityUserIdentifyLastFourNumber];
    
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    __weak UIView * tmpView = self.headerBindStatusView;
    [self.bindBankInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(15);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(height);
    }];
    
    tmpView = self.userInfoView;
    
    CGFloat width = 0.0f;
    if (IOS_IPHONE5OR4_SCREEN) {
        
        width = 320.0f;
        
        CGFloat interval = SCREEN_FRAME.size.height - 279 - 156 - 10 - 45 - 64;
        interval = interval < 20? 20:interval;
        [self.remind4View mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(tmpScrollView);
            make.top.mas_equalTo(tmpView.mas_bottom).offset(interval);
            make.height.mas_equalTo(@(45));
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(-10);
        }];
    }else
    {
        width = 375.0f;
        
        CGFloat interval = SCREEN_FRAME.size.height - 279 - 156 - 20 - 45 - 64;
        [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(tmpScrollView);
            make.top.mas_equalTo(tmpView.mas_bottom).offset(interval);
            make.height.mas_equalTo(@(45));
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(-20);
        }];
    }

    
    [self.containerScrollView layoutIfNeeded];
}

#pragma mark  - 回调信息
//绑卡信息
- (void)XNAccountModuleGetBindBankCardInfoDidReceive:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    
    [self updateData];
}

- (void)XNAccountModuleGetBankCardInfoDidFailed:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////
#pragma mark - setter/getter
//////////////////////////////

#pragma mark - phoneCtrl
- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}
@end
