//
//  FMComissionCaculateVController.m
//  FinancialManager
//
//  Created by xnkj on 5/11/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "FMComissionCaculateVController.h"
#import "UILabel+Extend.h"
#import "UINavigationItem+Extension.h"
#import "UniversalInteractWebViewController.h"
#import "CustomTextField.h"
#import "NewUserGuildController.h"
#import "XNFMProfitCaculateMode.h"
#import "XNFMProductListItemMode.h"
#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNCommonModule.h"
#import "XNConfigMode.h"
#import "LimitInput.h"
#import "XNInsuranceModule.h"
#import "ProductRedPacketModel.h"
#import "ProductRedPacketItemModel.h"

@interface FMComissionCaculateVController () <UITextFieldDelegate>

@property (nonatomic, strong) XNFMProductListItemMode * productDetailMode;


/*** 投资金额 **/
@property (nonatomic, weak) IBOutlet UIView *inputView;

/*** 投资金额输入框 **/
@property (nonatomic, weak) IBOutlet UITextField *inputTextField;

/*** 产品期限视图 **/
@property (nonatomic, weak) IBOutlet UIView      * timeLineView;

/*** 产品期限输入框 **/
@property (nonatomic, weak) IBOutlet UITextField * timeLineTextField;

/*** 红包视图 **/
@property (strong, nonatomic) IBOutlet UIView *redPacketView;

/*** 红包输入框 **/
@property (weak, nonatomic) IBOutlet UITextField *redPacketField;

/*** 平台奖励视图 **/
@property (strong, nonatomic) IBOutlet UIView *agentAwardView;

/*** 平台奖励输入框 **/
@property (weak, nonatomic) IBOutlet UITextField *agentAwardField;

/*** 收益视图 **/
@property (strong, nonatomic) IBOutlet UIView *earningsView;

/*** 猎财收益 **/
@property (weak, nonatomic) IBOutlet UILabel *lieCaiEarningLabel;

/*** 产品收益 **/
@property (weak, nonatomic) IBOutlet UILabel *productEarningLabel;

/*** 年化综合收益视图 **/
@property (strong, nonatomic) IBOutlet UIView *resultView;

/*** 综合年化 **/
@property (weak, nonatomic) IBOutlet UILabel *yearRateLabel;

/*** 综合收益 **/
@property (weak, nonatomic) IBOutlet UILabel *synthesizeEarningLabel;


/*** 红包数据源 **/
@property (nonatomic, strong) NSMutableArray *redPackArr;

@end

@implementation FMComissionCaculateVController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil detailMode:(XNFMProductListItemMode *)productDetailMode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.productDetailMode = productDetailMode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    [[XNFinancialManagerModule defaultModule] addObserver:self];
    
    [self loadProductRedPacket];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[XNFinancialManagerModule defaultModule] removeObserver:self];
}

///////////////////////////////
#pragma mark - custom method
//////////////////////////////

- (void)initView
{
    // 1.标题右侧按钮
    self.navigationItem.title = @"收益计算器";
    [self.navigationItem addComissionDescWithTarget:self action:@selector(ComissionDescClick)];
    
    // 设置label自动缩小文字大小
    self.yearRateLabel.adjustsFontSizeToFitWidth = YES;
    self.yearRateLabel.minimumScaleFactor = 0.5;
    self.synthesizeEarningLabel.adjustsFontSizeToFitWidth = YES;
    self.synthesizeEarningLabel.minimumScaleFactor = 0.5;
    
    // 2.添加子视图
    [self addSubviews];
    
    // 3.监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.inputTextField setValue:UIColorFromHex(0xD9D9D9) forKeyPath:@"_placeholderLabel.textColor"];
    [self.timeLineTextField setValue:UIColorFromHex(0xD9D9D9) forKeyPath:@"_placeholderLabel.textColor"];
    

    // 4.设置最小天数
    self.timeLineTextField.text = self.productDetailMode.deadLineMinValue;
    
    // 5.限制输入位数
    [self.inputTextField setValue:@7 forKey:@"LimitInput"];
    [self.agentAwardField setValue:@7 forKey:@"LimitInput"];
    
    // 6.添加监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.inputTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.agentAwardField];
    
    [self setData];
    
    [self.inputTextField becomeFirstResponder];
}

// 请求产品可用红包
- (void)loadProductRedPacket
{
    [[XNFinancialManagerModule defaultModule] product_product_RedPacket:self.productDetailMode.productId];
}

// 右侧问号点击
- (void)ComissionDescClick
{
    [self.view endEditing:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[AppFramework getConfig].XN_REQUEST_H5_BASE_URL,@"pages/message/sale_commission.html"];
    UniversalInteractWebViewController *viewController = [[UniversalInteractWebViewController alloc] initRequestUrl:urlString requestMethod:@"GET"];
    [_UI pushViewControllerFromRoot:viewController animated:YES];
}

//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    
    if (sender == self.inputTextField) {
        
        [self setData];
        
    } else {
        
        NSString *inputNum = self.inputTextField.text;
        if ([inputNum integerValue] > 0) {
            [self setData];
        }
    }
}

- (void)addSubviews
{
    // 添加投资金额视图
    self.inputView.frame = CGRectMake(0.f, 0.f, SCREEN_FRAME.size.width, 45.f);
    [self.view addSubview:self.inputView];
    
    // 添加产品期限视图
    self.timeLineView.frame = CGRectMake(0.f, CGRectGetMaxY(self.inputView.frame), SCREEN_FRAME.size.width, 45.f);
    [self.view addSubview:self.timeLineView];
    
    // 添加平台奖励视图
    self.agentAwardView.frame = CGRectMake(0.f, CGRectGetMaxY(self.timeLineView.frame), SCREEN_FRAME.size.width, 45.f);
    [self.view addSubview:self.agentAwardView];
    
    // 添加猎财红包视图
    self.redPacketView.frame = CGRectMake(0.f, CGRectGetMaxY(self.agentAwardView.frame), SCREEN_FRAME.size.width, 45.f);
    [self.view addSubview:self.redPacketView];
    
    // 添加收益视图
    self.earningsView.frame = CGRectMake(0.f, CGRectGetMaxY(self.redPacketView.frame) + 15.f, SCREEN_FRAME.size.width, 90.5);
    [self.view addSubview:self.earningsView];
    
    // 年化收益率
    CGFloat nav_h = Device_Is_iPhoneX ? 88.f : 64.f;
    self.resultView.frame = CGRectMake(0.f, SCREEN_FRAME.size.height - 49.f - nav_h, SCREEN_FRAME.size.width, 49.f);
    [self.view addSubview:self.resultView];
}

// 键盘处理
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出需要花费的时间
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 修改transform
    [UIView animateWithDuration:duration animations:^{
        CGFloat ty = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
        self.resultView.transform = CGAffineTransformMakeTranslation(0, - ty);
    }];
}

//计算匹配赋值数据
- (void)setData
{
    NSString *inputNumStr = self.inputTextField.text;      //投资金额
    CGFloat inputNum = [inputNumStr floatValue];
    if (inputNum > 0) {
        
        //1.猎财收益 = 投资金额 * 产品期限 ÷ 360 * 佣金率 + 猎财红包，去尾保留两位小数
        NSString *timeDayStr = self.timeLineTextField.text;    //投资期限
        CGFloat timeDay = [timeDayStr floatValue];
        CGFloat feeRatio = self.productDetailMode.feeRatio;    //佣金率
        
        // 匹配出红包
        ProductRedPacketItemModel *redPacketItemModel = [self getRedPacketStr:inputNumStr];
        NSInteger redPacket = 0;
        
        // 文案显示
        if ([NSObject isValidateObj:redPacketItemModel]) {
            // 投资≥[红包起投金额]，最高奖励[红包金额]
            self.redPacketField.text = [NSString stringWithFormat:@"投资≥[%@]，最高奖励[%@]", redPacketItemModel.amount, redPacketItemModel.money];
            redPacket = [redPacketItemModel.money integerValue];
        } else {
            self.redPacketField.text = @"暂无可用红包";
            redPacket = 0;
        }
        
        CGFloat lieCaiEarning = inputNum * timeDay / 360 * feeRatio / 100 + redPacket;
        self.lieCaiEarningLabel.text = [NSString stringWithFormat:@"%.2f", lieCaiEarning];
        
        //2.产品收益 = 投资金额*产品期限÷360*平台收益率+平台奖励金额，去尾保留两位小数
        CGFloat fixRate = self.productDetailMode.fixRate;      //年化
        NSString *agentAwardStr = self.agentAwardField.text;
        CGFloat agentAward = [agentAwardStr floatValue];       //平台奖励
        CGFloat productEarning = inputNum * timeDay / 360 * fixRate / 100 + agentAward;
        
        self.productEarningLabel.text = [NSString stringWithFormat:@"%.2f", productEarning];
        
        //3.综合收益  综合收益=计算去尾后的猎财收益+计算去尾后的产品收益
        CGFloat synthesizeEarning = lieCaiEarning + productEarning;
        self.synthesizeEarningLabel.text = [NSString stringWithFormat:@"%.2f", synthesizeEarning];
        
        //4.综合年化 4.综合年化=综合收益÷投资金额÷(产品期限/360)，百分比后面去尾保留两位小数
        CGFloat yearRate = synthesizeEarning / inputNum / (timeDay / 360);
        self.yearRateLabel.text = [NSString stringWithFormat:@"%.2f%%", yearRate * 100];
    
    } else {
        
        self.lieCaiEarningLabel.text = @"0.00";
        self.productEarningLabel.text = @"0.00";
        self.synthesizeEarningLabel.text = @"0.00";
        self.yearRateLabel.text = @"0.00";
    }
}

#pragma mark - 匹配红包

- (ProductRedPacketItemModel *)getRedPacketStr:(NSString *)inputNumStr
{
    if (self.redPackArr.count == 0) {
        return nil;
    }
    
    // 1.先判断  amountLimit    金额限制 0=不限|1=大于|2=大于等于
    
    for (NSInteger i = 0; i < self.redPackArr.count; i ++) {
        
        ProductRedPacketItemModel *packItemModel = self.redPackArr[i];
    
        if (i == 0 && [packItemModel.amountLimit integerValue] == 0) { // 第一个没有额度限制
            return packItemModel;
            break;
        } else {
            
            if ([packItemModel.amountLimit integerValue] == 1) {
                
                if ([inputNumStr floatValue] > [packItemModel.amount floatValue]) {
                    return packItemModel;
                    break;
                }
                
            } else if ([packItemModel.amountLimit integerValue] == 2) {
                
                if ([inputNumStr floatValue] >= [packItemModel.amount floatValue]) {
                    return packItemModel;
                    break;
                }
            }
        }
    }
    
    return nil;
}


/////////////////////////////////////
#pragma mark - system protocl
/////////////////////////////////////

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /**
     *  1.第一位输入0之后，只能输入小数点 （小数点之后保留两位）
     *  2.正常的输入方法
     */
    
    NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
    [futureString insertString:string atIndex:range.location];
    
    //1.第一位不能输入0
    if (futureString.length > 0) {
        if ([futureString characterAtIndex:0] == '0') {
            return NO;
        }
    }
    return YES;
}

//获取产品可用红包
- (void)product_Product_RedPacket_DidReceive:(XNFinancialManagerModule *)module
{
    [self.view hideLoading];
    
    [self.redPackArr removeAllObjects];
    
    [self.redPackArr addObjectsFromArray:module.productRedPacketModel.datas];
    
    // 匹配一次
    NSString *inputNumStr = self.inputTextField.text;      //投资金额
    CGFloat inputFlo = [inputNumStr floatValue];
    
    if (inputFlo > 0) {
        ProductRedPacketItemModel *packItem = [self getRedPacketStr:inputNumStr];
        
        if ([NSObject isValidateObj:packItem]) {
            // 投资≥[红包起投金额]，最高奖励[红包金额]
            self.redPacketField.text = [NSString stringWithFormat:@"投资≥[%@]，最高奖励[%@]", packItem.amount, packItem.money];
        } else {
            self.redPacketField.text = @"暂无可用红包";
        }
    }
}

- (void)product_Product_RedPacket_DidFailed:(XNFinancialManagerModule *)module
{
    [self.view hideLoading];
}

////////////////////////////////////
#pragma mark - setter / getter
////////////////////////////////////

- (NSMutableArray *)redPackArr
{
    if (!_redPackArr) {
        _redPackArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _redPackArr;
}


@end
