//
//  MIAddBankCardSuccessController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIAddBankCardSuccessController.h"
#import "CustomerServiceController.h"
#import "CouponContainerViewController.h"

#import "CoreTextLabel.h"

#import "XNGetUserBindBankCardInfoMode.h"
#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface MIAddBankCardSuccessController ()<XNAddBankCardModuleObserver>

@property (nonatomic, strong) CustomerServiceController * phoneCtrl;
@property (nonatomic, strong) NSString           * bankInfoStrl;
@property (nonatomic, strong) NSString           * haveBind;//是否已经绑定过

@property (nonatomic, weak) IBOutlet UILabel     * bankInfoLabel;
@property (nonatomic, weak) IBOutlet UIView      * headerView;
@property (nonatomic, weak) IBOutlet UIView      * dispatchRedPacketView;
@end

@implementation MIAddBankCardSuccessController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bankInfo:(NSArray *)bankInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.bankInfoStrl = [bankInfo firstObject];
        self.haveBind = [bankInfo lastObject];
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

///////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

//初始化操作
- (void)initView
{
    self.title = @"绑定银行卡";
    
    //更新银行信息
    self.bankInfoLabel.text = self.bankInfoStrl;
    if ([self.haveBind isEqualToString:@"0"]) {
        
        [self.view addSubview:self.dispatchRedPacketView];
        
        weakSelf(weakSelf)
        __weak UIView * tmpHeaderView = self.headerView;
        [self.dispatchRedPacketView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.top.mas_equalTo(tmpHeaderView.mas_bottom);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.height.mas_equalTo(@(52));
        }];
    }
    
    //清空绑卡导航
    [_UI clearPreNavigationCtrl];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
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


//返回
- (void)clickBack:(UIButton *)sender
{
    NSString * ctl = [_LOGIC getValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER];
    
    [_UI popViewControllerFromRoot:YES ToNavigationCtrl:ctl comlite:nil];
}

//查看红包
- (IBAction)clickCheckRedPacket:(id)sender
{
    CouponContainerViewController * ctrl = [[CouponContainerViewController alloc]initWithNibName:@"CouponContainerViewController" bundle:nil currentRedPacketType:MyRedPacketType];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES completion:^{
      
        [_UI clearPreNavigationCtrl];
    }];
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
