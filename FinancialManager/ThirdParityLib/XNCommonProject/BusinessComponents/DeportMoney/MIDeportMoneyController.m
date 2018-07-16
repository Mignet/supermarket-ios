//
//  MIDeportMoneyController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIDeportMoneyController.h"
#import "MIDeportStatusController.h"
#import "MIInitPayPwdViewController.h"
#import "MIResetPayPwdController.h"
#import "TradePasswordViewController.h"
#import "CoreTextLabel.h"
#import "CustomerServiceController.h"

#import "JFZTimePickerViewController.h"
#import "MIDeportDetailController.h"
#import "UINavigationItem+Extension.h"

#import "XNWithDrawBankCardInfoMode.h"
#import "DeportMoneyModule.h"
#import "DeportMoneyModuleObserver.h"

#import "XNMyAccountInfoMode.h"
#import "XNAccountModule.h"
#import "XNAccountModuleObserver.h"

#import "XNUserVerifyPayPwdMode.h"
#import "XNUserVerifyPayPwdStatusMode.h"
#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"
#import "XNOpenBankMode.h"

@interface MIDeportMoneyController ()<DeportMoneyModuleObserver,XNAccountModuleObserver,XNPasswordManagerObserver,PasswordViewDelegate,UITextFieldDelegate,TimePickerViewDelegate, XNAddBankCardModuleObserver>

@property (nonatomic, assign) BOOL                          needRefresh;
@property (nonatomic, assign) BOOL                          isShowTradePwdView;
@property (nonatomic, assign) AddressOptionalType           addressOptionalValue;
@property (nonatomic, strong) UITapGestureRecognizer      * tapGesture;
@property (nonatomic, strong) JFZTimePickerViewController * addressCtrl;
@property (nonatomic, strong) TradePasswordViewController * tradePwdViewController; //交易密码
@property (nonatomic, strong) XNOpenBankMode *openBankMode;
@property (nonatomic, strong) CustomerServiceController * phoneCtrl;

@property (nonatomic, strong) NSMutableArray       * provinceAddressArray;
@property (nonatomic, strong) NSMutableArray       * cityAddressArray;
@property (nonatomic, strong) NSDictionary         * selectedProvinceDictionary;
@property (nonatomic, strong) NSDictionary         * selectedCityDictionary;
@property (nonatomic, strong) NSArray              * widthDrawInfoArray;

@property (nonatomic, weak) IBOutlet UIView          * accountInfoView;
@property (nonatomic, weak) IBOutlet UILabel         * accountBalanceLabel;
@property (nonatomic, weak) IBOutlet UITextField     * provinceTextField;
@property (nonatomic, weak) IBOutlet UITextField     * cityTextField;
@property (nonatomic, weak) IBOutlet UITextField     * streetTextField;
@property (nonatomic, weak) IBOutlet UITextField     * withDrawAmountTextField;
@property (nonatomic, weak) IBOutlet UILabel         * intoAccountDateLabel;
@property (nonatomic, weak) IBOutlet UILabel         * withDrawFeeLabel;
@property (nonatomic, weak) IBOutlet UIView          * bankAddressView;
@property (nonatomic, weak) IBOutlet UIView          * withDrawView;
@property (nonatomic, weak) IBOutlet CoreTextLabel   * remindCoreTextLabel;
@property (nonatomic, weak) IBOutlet UIView          * warnRemindView;
@property (nonatomic, weak) IBOutlet UIButton        * nextButton;
@property (nonatomic, weak) IBOutlet UIScrollView    * containerScrollView;
@property (nonatomic, weak) IBOutlet UIView *bankView;
@property (nonatomic, weak) IBOutlet UILabel *bankCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bankNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *bankButton;
@property (nonatomic, weak) IBOutlet UIImageView *bankImageView;

@end

@implementation MIDeportMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.needRefresh) {
        
        self.needRefresh = NO;
        
        //开始加载数据
        [[DeportMoneyModule defaultModule] requestBindBankCardInfo];
        [self.view showGifLoading];
    }
}

- (void)dealloc
{
    [[DeportMoneyModule defaultModule] removeObserver:self];
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"提现";
    [self.navigationItem addDeportDetailWithTarget:self action:@selector(clickDeportDetail)];
    [self.accountBalanceLabel setTextColor:MONEYCOLOR];
    
    NSArray * arr_Property = @[@{@"range": @"为保障资金安全，每位用户仅可添加一张银行卡，资金进出将通过该银行卡进行。绑定成功后不可随意修改。\n如需更换，请联系客服 ",
                                 @"color": UIColorFromHex(0x969696),
                                 @"font": [UIFont systemFontOfSize:12]},
                               @{@"range": [[[XNCommonModule defaultModule] configMode] serviceTelephone],
                                 @"color": UIColorFromHex(0x007aff),
                                 @"font": [UIFont systemFontOfSize:12],
                                 @"clickArea":@"Yes"}];
    [self.remindCoreTextLabel setArr_Property:arr_Property];
    [self.remindCoreTextLabel setClickAbleFontSize:12];
    [self.remindCoreTextLabel setLineSpace:5.0f];
    [self.remindCoreTextLabel setTextAlignment:NSTextAlignmentLeft];
    
    weakSelf(weakSelf)
    [self.remindCoreTextLabel setClickBlock:^{
        
        [weakSelf.view addSubview:weakSelf.phoneCtrl.view];
        [weakSelf.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.view);
        }];
    }];
    
    //密码输入框
    [self.view addSubview:self.tradePwdViewController.view];
    [self addChildViewController:self.tradePwdViewController];
    
    [self.tradePwdViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.view.mas_leading);
        make.trailing.equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(@(120));
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    //添加地址视图
    [self.view addSubview:self.addressCtrl.view];
    [self addChildViewController:self.addressCtrl];
    
    [self.addressCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];

    [self initSubView];
    [self.view layoutIfNeeded];
    
    [[XNAddBankCardModule defaultModule] addObserver:self];
    [[DeportMoneyModule defaultModule] addObserver:self];
    [[XNPasswordManagerModule defaultModule] addObserver:self];
  
    //开始加载数据
    [[DeportMoneyModule defaultModule] requestBindBankCardInfo];
    [self.view showGifLoading];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 初始化界面
- (void)initSubView
{
    [self.containerScrollView addSubview:self.accountInfoView];
    [self.containerScrollView addSubview:self.bankView];
    [self.containerScrollView addSubview:self.bankAddressView];
    [self.containerScrollView addSubview:self.withDrawView];
    [self.containerScrollView addSubview:self.warnRemindView];

    [self.accountInfoView setHidden:YES];
    [self.bankView setHidden:YES];
    [self.bankAddressView setHidden:YES];
    [self.withDrawView setHidden:YES];
    [self.warnRemindView setHidden:YES];
    [self.nextButton setHidden:YES];
}

#pragma mark - 更新银行地址信息
- (void)updateBankAddress
{
    BOOL needBanAddress = NO;
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    
    [self.accountInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpScrollView.mas_top);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(83);
    }];
    
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpScrollView.mas_top).offset(83);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.width.mas_equalTo(tmpScrollView.mas_width);
        make.height.mas_equalTo(98);
    }];
    
    if ([[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_NEEDKAIHUHANG] boolValue])
    {
        [self.bankAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top).offset(181);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            make.width.mas_equalTo(tmpScrollView);
            make.height.mas_equalTo(147);
        }];
        
        self.bankButton.userInteractionEnabled = YES;
        self.bankImageView.hidden = NO;
        needBanAddress = YES;
    }else
    {
        self.bankButton.userInteractionEnabled = NO;
        [self.bankImageView setHidden:YES];
        
        [self.bankAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top).offset(181);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            make.width.mas_equalTo(tmpScrollView);
            make.height.mas_equalTo(0);
        }];
    }
    
    __weak UIView * tmpView = self.bankAddressView;
    [self.withDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(10);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.width.mas_equalTo(tmpScrollView);
        make.height.mas_equalTo(147);
    }];
    
    __weak UIView * tmpWithDrawView = self.withDrawView;
    [self.warnRemindView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.top.mas_equalTo(tmpWithDrawView.mas_bottom).offset(10);
        make.height.mas_equalTo(78);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
    }];
    
    [self.accountInfoView setHidden:NO];
    [self.bankView setHidden:NO];
    [self.bankAddressView setHidden:NO];
    [self.withDrawView setHidden:NO];
    [self.warnRemindView setHidden:NO];
    [self.nextButton setHidden:NO];
    
    [self.view layoutIfNeeded];
    
    [self updateUIContent];
}

#pragma mark - 更新内容
- (void)updateUIContent
{
    [self.accountBalanceLabel setText:[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_TOTALAMOUNT]];
    NSString * bankCardStr =[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKCARD];
   
    bankCardStr = [bankCardStr stringByReplacingCharactersInRange:NSMakeRange(4, bankCardStr.length - 8) withString:@"*********"];
    
    self.bankCodeLabel.text = bankCardStr;
    self.bankNameLabel.text = [[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKNAME];
    
    if([[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_HASFEE] boolValue] && [[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_LIMITTIMES] integerValue] <= 0)
    {
        NSMutableArray * attributeArray = [NSMutableArray array];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"本次",@"range",UIColorFromHex(0x3e4446),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_FEE]],@"range",UIColorFromHex(0x02a0f2),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"元",@"range",UIColorFromHex(0x3e4446),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        
        [self.withDrawFeeLabel setAttributedText:[NSString getAttributeStringWithAttributeArray:attributeArray]];
    }else
    {
        
        NSMutableArray * attributeArray = [NSMutableArray array];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"本月还可以免费提现",@"range",UIColorFromHex(0x3e4446),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_LIMITTIMES]],@"range",UIColorFromHex(0x02a0f2),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        [attributeArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"次",@"range",UIColorFromHex(0x3e4446),@"color",[UIFont systemFontOfSize:14],@"font", nil]];
        
        [self.withDrawFeeLabel setAttributedText:[NSString getAttributeStringWithAttributeArray:attributeArray]];
    }
    
    [self.intoAccountDateLabel setText:[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_PAYMENTDATE]];
}

#pragma mark - 提现明细
- (void)clickDeportDetail
{
    MIDeportDetailController * deportDetailCtrl = [[MIDeportDetailController alloc]initWithNibName:@"MIDeportDetailController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:deportDetailCtrl animated:YES];
}

#pragma mark - 单击银行操作
- (IBAction)clickBank:(id)sender
{
    self.addressOptionalValue = BankNameType;
    //开始加载银行
    [[XNAddBankCardModule defaultModule] getAllBankInfo];
    [self.view showGifLoading];
}

#pragma mark - 单击省份
- (IBAction)clickProvice:(id)sender
{
    self.addressOptionalValue = ProvinceOptionalType;
    
    //开始加载省份地址
    [[DeportMoneyModule defaultModule] requestProvinceInfo];
    [self.view showGifLoading];
}

#pragma mark - 单击城市
- (IBAction)clickCity:(id)sender
{
    //如果选择了省份
    if ([self.selectedProvinceDictionary.allKeys count] > 0) {
        
        self.addressOptionalValue = CityOptionalType;
        
        //开始加载城市地址
        [[DeportMoneyModule defaultModule] requestCityInfoWithProvinceCode:[self.selectedProvinceDictionary objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCEID]];
        [self.view showGifLoading];
    }
}

#pragma mark - 下一步
- (IBAction)nextStep:(id)sender
{
    [self exitAction:nil];
    if ([[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_NEEDKAIHUHANG] boolValue])
    {
        if ([self.provinceTextField.text isEqualToString:@""]) {
            
            [self showCustomWarnViewWithContent:@"请选择省份"];
            return;
        }
        
        if ([self.cityTextField.text isEqualToString:@""]) {
            
            [self showCustomWarnViewWithContent:@"请选择城市"];
            return;
        }
        
        if ([self.streetTextField.text isEqualToString:@""]) {
            
            [self showCustomWarnViewWithContent:@"请输入开户行信息"];
            return;
        }
    }
    
    if (self.withDrawAmountTextField.text.length <= 0) {
        
        [self showCustomWarnViewWithContent:@"请输入提款金额"];
        return;
    }
    
    if (((int)(([self.withDrawAmountTextField.text floatValue] * 100))) < 10) {
        
        self.withDrawAmountTextField.text = @"";
        [self showCustomWarnViewWithContent:@"提现金额不能小于0.1元"];
        return;
    }
    
    if (([[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_TOTALAMOUNT] floatValue] * 100) < [self.withDrawAmountTextField.text floatValue] * 100) {
        
        self.withDrawAmountTextField.text = @"";
        [self showCustomWarnViewWithContent:@"可提金额不足"];
        return;
    }
    
//    [[XNPasswordManagerModule defaultModule] userVerifyExistPayPassword];
//    [self.view showGifLoading];
    _isShowTradePwdView = YES;
    self.tradePwdViewController.view.hidden = NO;
    [self.tradePwdViewController refreshAmount];
}

#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    if ( [self.withDrawAmountTextField isFirstResponder]) {
        
        [self.containerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height + 100)];
    }

    //如果输入框聚焦时，则不显示交易密码输入框
    if ([self.streetTextField isFirstResponder] || [self.withDrawAmountTextField isFirstResponder])
    {
        self.tradePwdViewController.view.hidden = YES;
        return;
    }
    
    if (_isShowTradePwdView)
    {
        // 获取键盘的位置和大小
        CGRect keyboardBounds;
        [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // 键盘的位置和大小
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        self.tradePwdViewController.view.frame = CGRectMake(0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width, 120);
        // 获取输入框的位置和大小
        CGRect containerFrame = self.tradePwdViewController.view.frame;
        // 计算出输入框的y坐标
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
        
        weakSelf(weakSelf)
        [self.tradePwdViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
         
            make.leading.equalTo(weakSelf.view.mas_leading);
            make.trailing.equalTo(weakSelf.view.mas_trailing);
            make.height.mas_equalTo(@(120));
            make.top.mas_equalTo(weakSelf.view.mas_top).offset(containerFrame.origin.y);
        }];
        
        // 动画改变位置
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:[duration doubleValue]];
            [UIView setAnimationCurve:[curve intValue]];
            // 更改输入框的位置
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - 键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
    [self.containerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - 50)];
    
    _isShowTradePwdView = NO;
    
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 获取输入框的位置和大小
    CGRect containerFrame = self.tradePwdViewController.view.frame;
    containerFrame.origin.y = self.view.bounds.size.height;
    
    weakSelf(weakSelf)
    [self.tradePwdViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.view.mas_leading);
        make.trailing.equalTo(weakSelf.view.mas_trailing);
        make.height.mas_equalTo(@(120));
        make.top.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    // 动画改变位置
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        // 更改输入框的位置
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 退出键盘
- (void)exitAction:(UIGestureRecognizer *)gesture
{
    _isShowTradePwdView = NO;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 重新加载
- (void)reload
{
    [self hideLoadingTarget:self];
    
    //开始加载数据
    [[DeportMoneyModule defaultModule] requestBindBankCardInfo];
    [self.view showGifLoading];
}

////////////////////
#pragma mark - Protocal
////////////////////////////////////////////

#pragma mark - 获取打款信息
- (void)XNAccountModuleUserBindBankCardInfoDidReceive:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    
    [self updateUIContent];
    [self updateBankAddress];
}

- (void)XNAccountModuleUserBindBankCardInfoDidFailed:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (![self isExistNetworkLoadingFailedTarget:self])
        [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reload)];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 提款
- (void)XNAccountModuleWithDrawDidReceive:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    
    self.withDrawAmountTextField.text = @"";
    self.needRefresh = YES;
    
    MIDeportStatusController * deportStatusCtrl = [[MIDeportStatusController alloc]initWithNibName:@"MIDeportStatusController" bundle:nil transportData:self.widthDrawInfoArray];
    
    [_UI pushViewControllerFromRoot:deportStatusCtrl animated:YES];
}

- (void)XNAccountModuleWithDrawDidFailed:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    self.needRefresh = NO;
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[module.retCode.detailErrorDic objectForKey:@"msg"]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 检查支付密码是否正确
- (void)XNUserModuleVerifyPayPasswordDidReceive:(XNPasswordManagerModule *)module
{
    if (module.userVerifyPayPwdMode.result) {
        
        [self.tradePwdViewController.passwordView clearUpPassword];
        
        NSString * withDrawAmountStr = self.withDrawAmountTextField.text;
        NSString * city = @"";
        NSString * province = @"";
        NSString * kaiHuHang = @"";
        
        if([[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_NEEDKAIHUHANG] boolValue])
        {
            city = self.cityTextField.text;
            province = self.provinceTextField.text;
            kaiHuHang = self.streetTextField.text;
            
        }else
        {
            city = [[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_CITY];
            province = [[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_PROVINCE];
            kaiHuHang = [[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_KAIHUHANG];
        }
        
        //提现免费次数
        NSString *withDrawFeeString = self.withDrawFeeLabel.text;
        NSInteger nWithDrawFee = [[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_LIMITTIMES] integerValue];
        if (nWithDrawFee > 0)
        {
            withDrawFeeString = @"本次提现免费";
        }
        
        self.widthDrawInfoArray = [NSArray arrayWithObjects:[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKCARD],[NSString stringWithFormat:@"%@%@%@",province,city,kaiHuHang],self.withDrawAmountTextField.text,self.intoAccountDateLabel.text, withDrawFeeString, nil];
        
        [[DeportMoneyModule defaultModule] requestWithDrawWithBankCard:[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKCARD] bankName:[[[DeportMoneyModule defaultModule] userBindBankCardinfoDictionary] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYUSERBINDBANKCARDINFO_BANKNAME] city:city kaiHuHang:kaiHuHang amount:withDrawAmountStr];
    }else
    {
        [self.view hideLoading];
        
        [self.tradePwdViewController.passwordView clearUpPassword];
        [self showCustomWarnViewWithContent:@"支付密码错误"];
    }
}

- (void)XNUserModuleVerifyPayPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 回调处理
- (void)passwordView:(PasswordView*)passwordView inputPassword:(NSString*)password
{
    [self.tradePwdViewController.view setHidden:YES];
    [self exitAction:nil];
    [[XNPasswordManagerModule defaultModule] userVerifyPayPassword:password];
    [passwordView clearUpPassword];
    [self.view showGifLoading];
}

#pragma mark - textfielddelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * strMoney = self.withDrawAmountTextField.text;
    
    //
    NSString * number = @"^[0-9]*$";
     NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    if ([string isEqualToString:@" "] || (![numberPre evaluateWithObject:string] && ![string isEqualToString:@"."])) {
        
        return NO;
    }
  
    if ([NSObject isValidateInitString:strMoney]) {
        
        NSArray * content = [strMoney componentsSeparatedByString:@"."];
        
        if (content.count > 1 && [string isEqualToString:@"."]) {
            
            return NO;
        }
        
        if (content.count >= 2 && [[content lastObject] length] >= 2) {
            
            self.withDrawAmountTextField.text = [NSString stringWithFormat:@"%@.%@",[[strMoney componentsSeparatedByString:@"."] objectAtIndex:0],[[[strMoney componentsSeparatedByString:@"."] lastObject] substringToIndex:1]];
        }
    }
    else
    {
        if ([string hasPrefix:@"."])
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 忘记支付密码回调
- (void)passwordInputControllerDidForgetPassword
{
    [self exitAction:nil];
    MIResetPayPwdController * resetPwdCtrl = [[MIResetPayPwdController alloc]initWithNibName:@"MIResetPayPwdController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:resetPwdCtrl animated:YES];
}

#pragma mark - 查询银行
- (void)XNAccountModuleGetOpenBankInfoDidReceive:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    [self.addressCtrl show];
}

- (void)XNAccountModuleGetOpenBankInfoDidFailed:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark -  //查询省份
- (void)XNAccountModuleGetProvinceDidReceive:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    
    [self.provinceAddressArray removeAllObjects];
    [self.provinceAddressArray addObjectsFromArray:module.provinceInfoArray];
    
    [self.addressCtrl show];
}

- (void)XNAccountModuleGetProvinceDidFailed:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - //查询城市
- (void)XNAccountModuleGetCityDidReceive:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    
    [self.cityAddressArray removeAllObjects];
    [self.cityAddressArray addObjectsFromArray:module.cityInfoArray];
    
    [self.addressCtrl show];
}

- (void)XNAccountModuleGetCityDidFailed:(DeportMoneyModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    
}

#pragma mark - TimePickerDegate
- (NSInteger )numberOfColumn
{
    return 1;
}

- (NSInteger)TimePickerView:(UIPickerView *)pickerView rowsForColumn:(NSInteger)column
{
    NSInteger nCount = 0;
    switch (self.addressOptionalValue) {
        case BankNameType:
            nCount = [[[XNAddBankCardModule defaultModule] openBankListArray] count];
            
            break;
        case ProvinceOptionalType:
            nCount = [[[DeportMoneyModule defaultModule] provinceInfoArray] count];
            
            break;
        case CityOptionalType:
            nCount = [[[DeportMoneyModule defaultModule] cityInfoArray] count];
            
            break;
        default:
            break;
    }
    return nCount;
}

- (NSString *)TimePickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row AtColumn:(NSInteger)column
{
    if (self.addressOptionalValue == BankNameType)
    {
        if ([[[XNAddBankCardModule defaultModule] openBankListArray] count] > row)
        {
            return [[[[XNAddBankCardModule defaultModule] openBankListArray] objectAtIndex:row] bankName];
        }
    }
    
    if (self.addressOptionalValue == ProvinceOptionalType) {
        
        if (self.provinceAddressArray.count > 0 && self.provinceAddressArray.count > row) {
            
            return [[self.provinceAddressArray objectAtIndex:row] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCENAME];
        }
    }
    
    if (self.addressOptionalValue == CityOptionalType) {
        
        if (self.cityAddressArray.count > 0 && self.cityAddressArray.count > row) {
            
            return [[self.cityAddressArray objectAtIndex:row] objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYALLCITY_CITYNAME];
        }
    }
    
    return @"";
}

- (void)TimePickerView:(UIPickerView *)pickerView DidSelectedAtRow:(NSInteger)row Column:(NSInteger)column
{
    if (self.addressOptionalValue == BankNameType)
    {
        if ([[[XNAddBankCardModule defaultModule] openBankListArray] count] > row)
        {
            
            self.openBankMode = [[[XNAddBankCardModule defaultModule] openBankListArray] objectAtIndex:row];
            self.bankNameLabel.text = [[[[XNAddBankCardModule defaultModule] openBankListArray] objectAtIndex:row] bankName];
        }
    }
    
    if (self.addressOptionalValue == ProvinceOptionalType) {
        
        if (self.provinceAddressArray.count > 0 && self.provinceAddressArray.count > row) {
            
            self.selectedProvinceDictionary = [self.provinceAddressArray objectAtIndex:row];
            self.provinceTextField.text = [NSString stringWithFormat:@"%@省",[[self.selectedProvinceDictionary objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYALLPROVINCE_PROVINCENAME] stringByReplacingOccurrencesOfString:@" " withString:@""]];
            self.cityTextField.text = @"";
        }
    }
    
    if (self.addressOptionalValue == CityOptionalType) {
        
        if (self.cityAddressArray.count > 0 && self.cityAddressArray.count > row) {
            
            self.selectedCityDictionary = [self.cityAddressArray objectAtIndex:row];
            self.cityTextField.text = [NSString stringWithFormat:@"%@市",[[self.selectedCityDictionary objectForKey:XN_MYINFO_ACCOUNTCENTER_QUERYALLCITY_CITYNAME] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
}
////////////////////
#pragma mark - setter/getter
////////////////////////////////////////////

#pragma mark - provinceAddressArray
- (NSMutableArray *)provinceAddressArray
{
    if (!_provinceAddressArray) {
        
        _provinceAddressArray = [[NSMutableArray alloc]init];
    }
    return _provinceAddressArray;
}

#pragma mark -  cityAddressArray
- (NSMutableArray *)cityAddressArray
{
    if (!_cityAddressArray) {
        
        _cityAddressArray = [[NSMutableArray alloc]init];
    }
    return _cityAddressArray;
}

#pragma mark - selectedAddressDictionary
- (NSDictionary *)selectedProvinceDictionary
{
    if (!_selectedProvinceDictionary) {
        
        _selectedProvinceDictionary = [[NSDictionary alloc]init];
    }
    return _selectedProvinceDictionary;
}

#pragma mark - selectedCityDictionary
- (NSDictionary *)selectedCityDictionary
{
    if (!_selectedCityDictionary) {
        
        _selectedCityDictionary = [[NSDictionary alloc]init];
    }
    return _selectedCityDictionary;
}

#pragma mark - widthDrawInfoArray
- (NSArray *)widthDrawInfoArray
{
    if (!_widthDrawInfoArray) {
        
        _widthDrawInfoArray = [[NSArray alloc]init];
    }
    return _widthDrawInfoArray;
}

#pragma mark - TapGesutre
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitAction:)];
    }
    return _tapGesture;
}

#pragma mark - tradePwdViewController
- (TradePasswordViewController *)tradePwdViewController
{
    if (!_tradePwdViewController)
    {
        _tradePwdViewController = [[TradePasswordViewController alloc] initWithTitle:@"请输入交易密码"];
        _tradePwdViewController.view.frame = CGRectMake(0, SCREEN_FRAME.size.height, SCREEN_FRAME.size.width, 120);
        _tradePwdViewController.delegate = self;
    }
    
    return _tradePwdViewController;
}


#pragma mark - addressCtrl
- (JFZTimePickerViewController *)addressCtrl
{
    if (!_addressCtrl) {
        
        _addressCtrl = [[JFZTimePickerViewController alloc]initWithNibName:@"JFZTimePickerViewController" bundle:nil];
        [_addressCtrl setRowAlignment:NSTextAlignmentCenter];
        _addressCtrl.delegate = self;
    }
    return _addressCtrl;
}

#pragma mark - phoneCtrl
- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}
@end
