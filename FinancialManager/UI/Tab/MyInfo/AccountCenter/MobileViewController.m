//
//  MobileViewController.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/28/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MobileViewController.h"
#import "CustomerServiceController.h"

#import "CoreTextLabel.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface MobileViewController ()

@property (nonatomic, weak) IBOutlet UILabel *mobileLabel;
@property (nonatomic, weak) IBOutlet UIButton * mobileBtn;

@property (nonatomic, strong) CustomerServiceController * phoneCtrl;
@property (nonatomic, strong) NSString *mobile;

@end

@implementation MobileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mobile:(NSString *)mobile
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.mobile = mobile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

#pragma mark -初始化操作
- (void)initView
{
    self.title = @"手机号码";
    self.mobileLabel.text = self.mobile;
    [self.mobileBtn setTitle:[[[XNCommonModule defaultModule] configMode] serviceTelephone] forState:UIControlStateNormal];
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

///////////////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

- (CustomerServiceController *)phoneCtrl
{
    if (!_phoneCtrl) {
        
        _phoneCtrl = [[CustomerServiceController alloc]initWithNibName:@"CustomerServiceController" bundle:nil customerServer:YES phoneNumber:[[[XNCommonModule defaultModule] configMode] serviceTelephone] phoneTitle:@"确定拨打客服电话"];
    }
    return _phoneCtrl;
}
@end
