//
//  MIFingerPasswordViewController.m
//  FinancialManager
//
//  Created by xnkj on 09/10/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIFingerPasswordViewController.h"

@interface MIFingerPasswordViewController ()

@property (nonatomic, strong) UIImageView     * guildImageView;

@property (nonatomic, weak) IBOutlet UILabel  * headerLabel;
@property (nonatomic, weak) IBOutlet UISwitch * switchView;
@property (nonatomic, weak) IBOutlet UIScrollView * containerView;
@end

@implementation MIFingerPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
//////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"设置指纹解锁";
    
    [self.containerView addSubview:self.guildImageView];
    
    __weak UILabel * tmpLabel = self.headerLabel;
    __weak UIScrollView * tmpScrollView = self.containerView;
    [self.guildImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(tmpScrollView.mas_leading);
        make.top.mas_equalTo(tmpLabel.mas_bottom).offset(26);
        make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset((SCREEN_FRAME.size.width * (715.0 / 375.0) - SCREEN_FRAME.size.height - 112) > 0?(SCREEN_FRAME.size.width * (715.0 / 375.0) - SCREEN_FRAME.size.height - 112):SCREEN_FRAME.size.height - 112 - (SCREEN_FRAME.size.width * (715.0 / 375.0)));
        make.width.mas_equalTo(tmpScrollView.mas_width);
        make.height.mas_equalTo(SCREEN_FRAME.size.width * (715.0 / 375.0));
    }];
    
    if ([_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET] == 1 && [_LOGIC canEvaluatePolicy]) {
        
        [self.switchView setOn:YES];
        self.switchView.selected = YES;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark  - 转换器值发生改变
- (IBAction)switchValueChange:(id)sender
{
    if(![_LOGIC canEvaluatePolicy])
    {
        [self showCustomAlertViewWithTitle:@"您尚未开启系统的Touch ID指纹解锁功能，请按下方步骤在系统设置中开启" okTitle:@"确定" okTitleColor:UIColorFromHex(0x323232) okCompleteBlock:^{
            
            
        }];
        
        return;
    }
    
    if (!self.switchView.selected) {
        
        weakSelf(weakSelf)
        [_LOGIC evaluatePolicyWithSuccess:^{
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureSuccess:) withObject:nil waitUntilDone:NO];
        } failed:^(NSError *error) {
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureFailed:) withObject:error.userInfo waitUntilDone:NO];
        }];
    }else
    {
        weakSelf(weakSelf)
        [_LOGIC evaluatePolicyWithSuccess:^{
            
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureSuccess:) withObject:nil waitUntilDone:NO];
            
        } failed:^(NSError *error) {
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureFailed:) withObject:error.userInfo waitUntilDone:NO];
        }];
    }
}

#pragma mark - 启动指纹解锁失败
- (void)showFingerGestureFailed:(NSDictionary *)params
{
    [self.view showCustomWarnViewWithContent:@"指纹解锁功能开启失败"];
}

#pragma mark - 启动指纹解锁成功
- (void)showFingerGestureSuccess:(NSDictionary *)params
{
    
    if (!self.switchView.selected) {
        
        self.switchView.on = YES;
        self.switchView.selected = YES;
        [self showCustomWarnViewWithContent:@"指纹解锁功能开启"];
        
        [_LOGIC saveInt:1 key:XN_USER_FINGER_PASSWORD_SET];
        
        return;
    }
    
    self.switchView.selected = NO;
    self.switchView.on = NO;
    [_LOGIC saveInt:0 key:XN_USER_FINGER_PASSWORD_SET];
}

//////////////////
#pragma mark - setter/getter
////////////////////////////////

#pragma mark - guildImageView
- (UIImageView *)guildImageView
{
    if (!_guildImageView) {
        
        _guildImageView = [[UIImageView alloc]init];
        [_guildImageView setImage:[UIImage imageNamed:@"XN_MyInfo_finger_password_guid.png"]];
    }
    return _guildImageView;
}
@end
