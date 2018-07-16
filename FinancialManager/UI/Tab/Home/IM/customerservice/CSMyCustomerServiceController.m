//
//  CSMyCustomerServiceController.m
//  FinancialManager
//
//  Created by xnkj on 2016/7/28.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "CSMyCustomerServiceController.h"
#import "CSIMViewController.h"
#import "CustomerServiceController.h"
#import "CustomerChatManager.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface CSMyCustomerServiceController ()<IMManagerDelegate>

@property (nonatomic, strong) CustomerServiceController * phoneCtrl;

@property (nonatomic, weak) IBOutlet UILabel   * phoneLabel;
@property (nonatomic, weak) IBOutlet UIWebView * webView;
@end

@implementation CSMyCustomerServiceController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = title;
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

/////////////////////////
#pragma mark - Custom Method
////////////////////////////////////

#pragma mark - 
- (void)initView
{
    [self.phoneLabel setText:[[[XNCommonModule defaultModule] configMode] serviceTelephone]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[XNCommonModule defaultModule] configMode] questionUrl]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webView loadRequest:request];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 拨打电话
- (IBAction)clickPhone:(id)sender
{
    [self.view addSubview:self.phoneCtrl.view];
    
    weakSelf(weakSelf)
    [self.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - im通讯
- (IBAction)clickIM:(id)sender
{
    [[CustomerChatManager defaultCustomerService] chat];
}

//////////////////
#pragma mark - setter/getter
///////////////////////////////

#pragma mark - phoneCtrl
- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}
@end
