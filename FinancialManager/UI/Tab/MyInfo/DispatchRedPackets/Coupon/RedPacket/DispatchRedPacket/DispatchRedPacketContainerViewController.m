//
//  DispatchRedPacketContainerViewController.m
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "DispatchRedPacketContainerViewController.h"
#import "RedPacketSelectCustomerViewController.h"
#import "RedPacketSelectCfgViewController.h"
#import "SwithView.h"

@interface DispatchRedPacketContainerViewController ()<SwithViewDelegate>

@property (nonatomic, strong) NSString            * redPacketRid;//红包id
@property (nonatomic, strong) NSString            * redPacketMoney;
@property (nonatomic, strong) NSArray             * contentViewArray;

@property (nonatomic, weak) SwithView             * switchView;

@property (nonatomic, weak) IBOutlet UIScrollView * containerScrollView;
@end

@implementation DispatchRedPacketContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil redPacketMoney:(NSString *)money redPacketId:(NSString *)redPacketRid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.redPacketRid = redPacketRid;
        self.redPacketMoney = money;
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

///////////////////
#pragma mark - 自定义方法
//////////////////////////////////////

//初始化
- (void)initView
{
    self.switchView = [SwithView returnSwithView];
    [self.switchView setIntrinsicContentSize:CGSizeMake(200, 45)];
    self.navigationItem.titleView = self.switchView;
    self.switchView.delegate = self;
    
    [self buildSubView];
    
    if ([self.view respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//构建子视图
- (void)buildSubView
{
    weakSelf(weakSelf)
    NSInteger index = 0;
    __weak UIView * lastCtrlView = nil;
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    for (UIViewController * ctrl in self.contentViewArray) {
        
        [self.containerScrollView addSubview:ctrl.view];
        [self addChildViewController:ctrl];
        
        [ctrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(lastCtrlView?lastCtrlView.mas_trailing:tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.bottom.mas_equalTo(tmpScrollView.mas_bottom);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(tmpScrollView.mas_height);
            
            if (index == (weakSelf.contentViewArray.count - 1)) {
                
                make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            }
        }];
        lastCtrlView = ctrl.view;
        index = index + 1;
    }
}

///////////////////
#pragma mark - 组件回调
//////////////////////////////////////

//导航回调
- (void)swithViewDid:(SwithView *)swithView clickType:(SwithViewType)clickType
{
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.containerScrollView setContentOffset:CGPointMake( clickType * SCREEN_FRAME.size.width, 0)];
    }];
}

//uiscrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.containerScrollView]) {
        
        NSInteger index = (int)scrollView.contentOffset.x / SCREEN_FRAME.size.width;
        
        [self.switchView btnClick:index == 0?self.switchView.cfgBtn:self.switchView.customerBtn];
    }
}

///////////////////
#pragma mark - 懒加载
//////////////////////////////////////

//contentViewArray
- (NSArray *)contentViewArray
{
    if (!_contentViewArray) {
        
        RedPacketSelectCustomerViewController * customerCtrl = [[RedPacketSelectCustomerViewController alloc]initWithNibName:@"RedPacketSelectCustomerViewController" bundle:nil redPacketMoney:self.redPacketMoney redPacketId:self.redPacketRid];
        RedPacketSelectCfgViewController * cfgCtrl = [[RedPacketSelectCfgViewController alloc]initWithNibName:@"RedPacketSelectCfgViewController" bundle:nil redPacketMoney:self.redPacketMoney redPacketId:self.redPacketRid];
        
        _contentViewArray = [[NSArray alloc]initWithObjects:cfgCtrl,customerCtrl, nil];
    }
    return _contentViewArray;
}
@end
