//
//  MIAddBankCardController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIAddBankCardController.h"
#import "JFZTimePickerViewController.h"
#import "MIAddBankCardSuccessController.h"
#import "CustomerServiceController.h"
#import "CustomPhotoViewController.h"
#import "CustomImagePickerViewController.h"

#import "CoreTextLabel.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#import "MIMySetMode.h"
#import "XNMyInformationModule.h"

#import "XNBankCardMode.h"
#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"

@interface MIAddBankCardController ()<UITextFieldDelegate,XNAddBankCardModuleObserver,TimePickerViewDelegate>

@property (nonatomic, strong)    NSMutableArray         * errorMsgArray;
@property (nonatomic, strong)    NSMutableArray         * validatedStrArray;
@property (nonatomic, strong)    UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong)    CustomerServiceController * phoneCtrl;
@property (nonatomic, strong)    CustomImagePickerViewController * imgPickerViewCtrl;

@property (nonatomic, weak) IBOutlet UITextField        * realNameTextField;
@property (nonatomic, weak) IBOutlet UITextField        * userIdentifyTextField;
@property (nonatomic, weak) IBOutlet UITextField        * bankCardTextField;
@property (nonatomic, weak) IBOutlet UITextField        * mobileTextField;
@property (nonatomic, weak) IBOutlet UIButton           * submitButton;
@property (nonatomic, weak) IBOutlet UILabel            * errorRemindLabel;

@property (nonatomic, weak) IBOutlet UIView             * awardView;
@property (nonatomic, weak) IBOutlet UIView             * baseBindCardInfoView;
@property (nonatomic, weak) IBOutlet UIView             * phoneView;
@property (nonatomic, weak) IBOutlet UIButton           * remindBtn;
@property (nonatomic, weak) IBOutlet UIView             * remindView;
@property (nonatomic, weak) IBOutlet UIScrollView       * containerScrollView;
@end

@implementation MIAddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[XNAddBankCardModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[XNAddBankCardModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AppFramework getGlobalHandler] removePopupCtrl];
}

///////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

#pragma mark -初始化操作
- (void)initView
{
    [self setTitle:@"银行卡绑定"];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        UITextField * textField = [note object];
        
        BOOL canBindCard = NO;
        if ((weakSelf.validatedStrArray.count >= 3 && ![weakSelf.validatedStrArray containsObject:textField]) || (weakSelf.validatedStrArray.count == 4)) {
            
            if ([textField isEqual:weakSelf.realNameTextField]) {
                
               canBindCard = [weakSelf validateUserNameIsChineseForEditing];
            }else if ([textField isEqual:weakSelf.userIdentifyTextField]) {
                
               canBindCard =  [weakSelf validateUserIdentifyForEditing];
            }else if ([textField isEqual:weakSelf.bankCardTextField]) {
                
               canBindCard =  [weakSelf validateBankCardForEditing];
            }else if ([textField isEqual:weakSelf.mobileTextField]) {
                
               canBindCard = [weakSelf validatePhoneNumberForEditing];
            }

            if (canBindCard) {
                
                [weakSelf.submitButton setBackgroundImage:[UIImage imageNamed:@"XN_Button_normal.png"] forState:UIControlStateNormal];
                [weakSelf.submitButton setEnabled:YES];
            }else
            {
                [weakSelf.submitButton setBackgroundImage:[UIImage imageNamed:@"XN_Button_disable.png"] forState:UIControlStateNormal];
                [weakSelf.submitButton setEnabled:NO];
            }
        }
    }];
    
    //添加提示
    CGFloat height = 0;
    __weak UIView * lastView = nil;
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    if (![[[XNMyInformationModule defaultModule] settingMode] onceMoreBindCard]) {
        
        [self.containerScrollView addSubview:self.awardView];
        [self.awardView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            make.width.equalTo(tmpScrollView);
            make.height.mas_equalTo(@(40));
        }];
        lastView = self.awardView;
        height = 40;
    }
    height = height + 322;
    
    [self.containerScrollView addSubview:self.baseBindCardInfoView];
    [self.containerScrollView addSubview:self.phoneView];
    [self.containerScrollView addSubview:self.errorRemindLabel];
    [self.containerScrollView addSubview:self.submitButton];
    [self.containerScrollView addSubview:self.remindView];
    
    [self.baseBindCardInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(lastView?lastView.mas_bottom:tmpScrollView.mas_top);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.width.equalTo(tmpScrollView);
        make.height.mas_equalTo(@(140));
    }];
    
    lastView = self.baseBindCardInfoView;
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(lastView.mas_bottom).offset(10);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(@(138));
    }];
    
    lastView = self.phoneView;
    [self.errorRemindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(lastView.mas_bottom).offset(4);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.height.mas_equalTo(@(21));
    }];
    
    lastView = self.errorRemindLabel;
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lastView.mas_bottom).offset(4);
        make.centerX.equalTo(tmpScrollView);
        make.width.mas_equalTo(tmpScrollView.mas_width).multipliedBy(0.945);
        make.height.mas_equalTo(tmpScrollView.mas_width).multipliedBy(0.945).multipliedBy(0.14);
    }];
    
    CGFloat bottomInterval = SCREEN_FRAME.size.height - 64 - height - (0.945 * SCREEN_FRAME.size.width * 0.14) - 45 - 20;
    if (bottomInterval <= 0) {
        
        bottomInterval = 20;
    }
    
    __weak UIButton * tmpButton = self.submitButton;
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(tmpScrollView);
        make.top.mas_equalTo(tmpButton.mas_bottom).offset(bottomInterval);
        make.height.mas_equalTo(@(45));
        make.width.mas_equalTo(@(210));
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(-20);
    }];
    [self.containerScrollView layoutIfNeeded];
    
     //更新电话号
    [self.remindBtn setTitle:[[[XNCommonModule defaultModule] configMode] serviceTelephone] forState:UIControlStateNormal];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - BankCardOperation
- (IBAction)clickNext:(id)sender
{
    [self exitKeyboard:nil];
    
    //保存用户信息
    [[XNAddBankCardModule defaultModule] addBankCardWithBankCardNumber:[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] idCard:self.userIdentifyTextField.text mobile:self.mobileTextField.text userName:self.realNameTextField.text];
    [self.view showGifLoading];
}

//扫描银行卡
- (IBAction)clickScanBankCard:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.imgPickerViewCtrl setCaptureBusinessType:@"1"];
    [self.imgPickerViewCtrl show];
}

- (void)scanBankCard:(NSDictionary *)params
{
    self.bankCardTextField.text = [params objectForKey:@"bankCardNumber"];
    
    [self textFieldDidEndEditing:self.bankCardTextField];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.bankCardTextField];
}

//扫描身份证
- (IBAction)clickScanIdCard:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.imgPickerViewCtrl setCaptureBusinessType:@"0"];
    [self.imgPickerViewCtrl show];
}

- (void)scanIdCard:(NSDictionary *)params
{
    self.userIdentifyTextField.text = params[@"idCard"];
    
    [self textFieldDidEndEditing:self.userIdentifyTextField];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.userIdentifyTextField];
    
    self.realNameTextField.text = params[@"userName"];
    
    [self textFieldDidEndEditing:self.realNameTextField];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.realNameTextField];
}

//打电话
- (IBAction)clickPhone:(id)sender
{
    [self.view addSubview:self.phoneCtrl.view];
    
    weakSelf(weakSelf)
    [self.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(weakSelf.view);
    }];
}

//电话提示
- (IBAction)clickPhoneRemind:(id)sender
{
    [self showCustomAlertViewWithTitle:@"银行预留手机说明"
                              subTitle:@"银行预留手机号是办理该银行卡时所填写的手机号码。没有预留、手机号忘记或者已停用，请联系银行客服更新处理。"
                   subTitleLeftPadding:25
                         otherSubTitle:nil
                               okTitle:@"我知道了"
                       okCompleteBlock:nil
                           cancelTitle:nil
                   cancelCompleteBlock:nil];
}
#pragma mark - 退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    NSDictionary * notifDic = [notif userInfo];
    
    NSValue * endValue = [notifDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [endValue CGRectValue];
    
    CGFloat interval = (self.submitButton.frame.origin.y + self.submitButton.size.height + keyboardRect.size.height) - SCREEN_FRAME.size.height;
    [self.containerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height + interval)];
}

- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
    
    NSDictionary * notifDic = [notif userInfo];
    
    NSValue * animationDurationValue = [notifDic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.containerScrollView setContentOffset:CGPointMake(0, 0)];
        [self.containerScrollView setContentSize:CGSizeMake(0, 0)];
    }];
}

//判断用过户名是否是中文
- (BOOL)validateUserNameIsChinese
{
   if ([self.realNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.realNameTextField.text isChinese]) {
        
        if ([self.errorMsgArray containsObject:@"姓名必须是中文，输入有误"]) {
            
            [self.errorMsgArray removeObject:@"姓名必须是中文，输入有误"];
        }
        [self.errorMsgArray insertObject:@"姓名必须是中文，输入有误" atIndex:0];
        [self.realNameTextField setTextColor:[UIColor redColor]];
      
        [self.validatedStrArray removeObject:self.realNameTextField];
       
        return NO;
    }else
    {
        if ([self.realNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            
            if (![self.validatedStrArray containsObject:self.realNameTextField]) {
                
                [self.validatedStrArray addObject:self.realNameTextField];
            }
        }else
        {
            [self.validatedStrArray removeObject:self.realNameTextField];
        }
        
        [self.errorMsgArray removeObject:@"姓名必须是中文，输入有误"];
        [self.realNameTextField setTextColor:UIColorFromHex(0x323232)];
    }
    
    return YES;
}

- (BOOL)validateUserNameIsChineseForEditing
{
    if ([self.realNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0 || ([self.realNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.realNameTextField.text isChinese])) {
        
        return NO;
    }
    
    return YES;
}

//判断身份证是否是有效的身份证
- (BOOL)validateUserIdentify
{
   if ([self.userIdentifyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.userIdentifyTextField.text validateIdentityCard]) {
        
        if ([self.errorMsgArray containsObject:@"身份证号输入有误"]) {
            
            [self.errorMsgArray removeObject:@"身份证号输入有误"];
        }
        [self.errorMsgArray insertObject:@"身份证号输入有误" atIndex:0];
        [self.userIdentifyTextField setTextColor:[UIColor redColor]];
        [self.validatedStrArray removeObject:self.userIdentifyTextField];
    
        return NO;
    }else
    {
        if ([self.userIdentifyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            if (![self.validatedStrArray containsObject:self.userIdentifyTextField]) {
                
                [self.validatedStrArray addObject:self.userIdentifyTextField];
            }
        }else
        {
            [self.validatedStrArray removeObject:self.userIdentifyTextField];
        }

        
        [self.errorMsgArray removeObject:@"身份证号输入有误"];
        [self.userIdentifyTextField setTextColor:UIColorFromHex(0x323232)];
    }
    
    return YES;
}

- (BOOL)validateUserIdentifyForEditing
{
    if ([self.userIdentifyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0 ||([self.userIdentifyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.userIdentifyTextField.text validateIdentityCard])) {
        
        return NO;
    }
    
    return YES;
}

//判断银行卡号是否有效的卡号
- (BOOL)validateBankCard
{
    if ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ([[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] < 16 || [[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 19)) {
        
        if ([self.errorMsgArray containsObject:@"很抱歉，银行卡号码有误"]) {
            
            [self.errorMsgArray removeObject:@"很抱歉，银行卡号码有误"];
        }
        [self.errorMsgArray insertObject:@"很抱歉，银行卡号码有误" atIndex:0];
        [self.bankCardTextField setTextColor:[UIColor redColor]];
        [self.validatedStrArray removeObject:self.bankCardTextField];
        
        return NO;
    }else
    {
        if ([self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            
            if (![self.validatedStrArray containsObject:self.bankCardTextField]) {
                
                [self.validatedStrArray addObject:self.bankCardTextField];
            }
        }else
        {
            [self.validatedStrArray removeObject:self.bankCardTextField];
        }

        
       [self.errorMsgArray removeObject:@"很抱歉，银行卡号码有误"];
       [self.bankCardTextField setTextColor:UIColorFromHex(0x323232)];
    }
    
    return YES;
}

- (BOOL)validateBankCardForEditing
{
    if ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0 || ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ([[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] < 16 || [[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 19))) {
        
        return NO;
    }
    
    return YES;
}

//判断手机号码是否有效
- (BOOL)validatePhoneNumber
{
    if ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.mobileTextField.text isValidateMobile]) {
        
        if ([self.errorMsgArray containsObject:@"很抱歉，手机号码有误"]) {
            
            [self.errorMsgArray removeObject:@"很抱歉，手机号码有误"];
        }
        [self.errorMsgArray insertObject:@"很抱歉，手机号码有误" atIndex:0];
        [self.mobileTextField setTextColor:[UIColor redColor]];
        [self.validatedStrArray removeObject:self.mobileTextField];
        
        return NO;
    }else
    {
        if ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            
            if (![self.validatedStrArray containsObject:self.mobileTextField]) {
                
               [self.validatedStrArray addObject:self.mobileTextField];
            }
        }else
        {
            [self.validatedStrArray removeObject:self.mobileTextField];
        }
        
        [self.errorMsgArray removeObject:@"很抱歉，手机号码有误"];
        [self.mobileTextField setTextColor:UIColorFromHex(0x323232)];
    }
    
    return YES;
}

- (BOOL)validatePhoneNumberForEditing
{
    if ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0 || ([self.mobileTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && ![self.mobileTextField.text isValidateMobile])) {
        
        return NO;
    }
    
    return YES;
}

///////////////////////
#pragma mark - Protocol
//////////////////////////////////////////

#pragma mark - 绑定银行卡
- (void)XNAccountModuleBankBankCardDidReceive:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERBINDCARDSUCCESSNOTIFICATION object:nil];
    
    NSString * remark = module.bankCardMode.remark;
    NSString * haveBind = module.bankCardMode.haveBind;
    
    MIAddBankCardSuccessController  * ctrl = [[MIAddBankCardSuccessController alloc]initWithNibName:@"MIAddBankCardSuccessController" bundle:nil bankInfo:@[remark,haveBind]];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

- (void)XNAccountModuleBankBankCardDidFailed:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);

    //根据errorCode对应处理
    if ([module.retCode.errorCode isEqualToString:@"100006"]) {
        
        NSArray * errorMsgArray = [module.retCode.errorMsg componentsSeparatedByString:@"="];
        
        if (errorMsgArray.count > 0) {
            
            [self showCustomAlertViewWithTitle:@"很抱歉"
                                      subTitle:[errorMsgArray firstObject]
                           subTitleLeftPadding:25
                                 otherSubTitle:[errorMsgArray count] >= 2?[errorMsgArray objectAtIndex:1]:nil
                                       okTitle:@"确定" okCompleteBlock:nil
                                   cancelTitle:@"" cancelCompleteBlock:nil];
        }
    }else
    {
        if (module.retCode.detailErrorDic) {
            
            [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:2.0f];
        }else
            [self showCustomWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:2.0f];
    }
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //退出软键盘
    [self exitKeyboard:nil];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.realNameTextField]) {
        
        [self validateUserNameIsChinese];
    }else if ([textField isEqual:self.userIdentifyTextField]) {
        
        [self validateUserIdentify];
    }else if ([textField isEqual:self.bankCardTextField]) {
        
        [self validateBankCard];
    }else if ([textField isEqual:self.mobileTextField]) {
        
        [self validatePhoneNumber];
    }
    
    if (self.errorMsgArray.count > 0)
    {
       self.errorRemindLabel.text = [self.errorMsgArray firstObject];
    }else
    {
       self.errorRemindLabel.text = @"";
    }
    
    if (self.validatedStrArray.count == 4) {
        
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"XN_Button_normal.png"] forState:UIControlStateNormal];
        [self.submitButton setEnabled:YES];
    }else
    {
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"XN_Button_disable.png"] forState:UIControlStateNormal];
        [self.submitButton setEnabled:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.bankCardTextField]) {
        
        if ([[self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] >= 19 && string.length > 0) {
            
            return NO;
        }
        
        if ([self.bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length % 4 == 0 && self.bankCardTextField.text.length > 0 && string.length != 0) {
            
            self.bankCardTextField.text = [self.bankCardTextField.text stringByAppendingString:@" "];
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:UIColorFromHex(0x323232)];
}

///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

//errorMsgArray
- (NSMutableArray *)errorMsgArray
{
    if (!_errorMsgArray) {
        
        _errorMsgArray = [[NSMutableArray alloc]init];
    }
    return _errorMsgArray;
}

//validatedStrArray
- (NSMutableArray *)validatedStrArray
{
    if (!_validatedStrArray) {
        
        _validatedStrArray = [[NSMutableArray alloc]init];
    }
    return _validatedStrArray;
}

#pragma mark - TapGesutre
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard:)];
    }
    return _tapGesture;
}

#pragma mark - phoneCtrl
- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}

//CustomImagePickerViewController
- (CustomImagePickerViewController *)imgPickerViewCtrl
{
    if (!_imgPickerViewCtrl) {
        
        _imgPickerViewCtrl = [[CustomImagePickerViewController alloc]initWithNibName:@"CustomImagePickerViewController" bundle:nil];
        _imgPickerViewCtrl.presentedChildViewController = self;
    }
    
    if (![[AppFramework getGlobalHandler].currentPopupCtrl isEqual:_imgPickerViewCtrl]) {
        
        [_KEYWINDOW addSubview:_imgPickerViewCtrl.view];
        [AppFramework getGlobalHandler].currentPopupCtrl = _imgPickerViewCtrl;
        
        __weak UIView * tmpKeyView = _KEYWINDOW;
        [_imgPickerViewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpKeyView);
        }];
        [_KEYWINDOW layoutIfNeeded];
    }
    
    return _imgPickerViewCtrl;
}
@end
