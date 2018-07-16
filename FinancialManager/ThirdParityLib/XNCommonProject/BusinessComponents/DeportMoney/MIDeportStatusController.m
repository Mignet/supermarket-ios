//
//  MIDeportStatusController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIDeportStatusController.h"
#import "CustomerServiceController.h"

#import "CoreTextLabel.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface MIDeportStatusController ()

@property (nonatomic, strong) NSArray                * widthDrawInfoArray;
@property (nonatomic, strong) CustomerServiceController * phoneCtrl;

@property (nonatomic, weak) IBOutlet UILabel         * bankCardLabel;
@property (nonatomic, weak) IBOutlet UILabel         * bankAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel         * withDrawAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel         * intoAccountDateLabel;
@property (nonatomic, weak) IBOutlet UILabel         * withDrawFeeLabel;
@property (nonatomic, weak) IBOutlet CoreTextLabel   * remindCoreTextLabel;
@end

@implementation MIDeportStatusController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil transportData:(NSArray *)widthDrawInfoArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.widthDrawInfoArray = widthDrawInfoArray;
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

/////////////////
#pragma mark - Custom Mehthod
////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"提现";
    
    [self.bankCardLabel setText:[self.widthDrawInfoArray objectAtIndex:0]];
    [self.bankAddressLabel setText:[self.widthDrawInfoArray objectAtIndex:1]];
    [self.withDrawAmountLabel setText:[NSString convertUnits:[self.widthDrawInfoArray objectAtIndex:2]]];
    [self.intoAccountDateLabel setText:[self.widthDrawInfoArray objectAtIndex:3]];
    [self.withDrawFeeLabel setText:[self.widthDrawInfoArray objectAtIndex:4]];
    
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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

////////////////
#pragma mark setter/getter
/////////////////////////////

- (NSArray *)widthDrawInfoArray
{
    if (!_widthDrawInfoArray) {
        
        _widthDrawInfoArray = [[NSArray alloc]init];
    }
    return _widthDrawInfoArray;
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
