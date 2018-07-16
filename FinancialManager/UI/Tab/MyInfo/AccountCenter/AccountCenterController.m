//
//  AccountCenterController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "AccountCenterController.h"
#import "AccountCenterCell.h"
#import "MessageNoDisturbViewCell.h"

#import "MIAddBankCardController.h"
#import "MIPasswordManageController.h"
#import "MICheckBankCardInfoController.h"
#import "ImagePickerViewController.h"
#import "ChangeUserPictureViewController.h"
#import "NewUserGuildController.h"
#import "IMManager.h"
#import "FeedBackController.h"
#import "MIMoreViewController.h"
#import "CustomerServiceController.h"
#import "MobileViewController.h"

#import "XNMIHomePageInfoMode.h"
#import "MIAccountCenterMode.h"
#import "XNMyInformationModule.h"
#import "XNMyInformationModuleObserver.h"

#import "XNUploadPicModule.h"
#import "XNUploadPicModuleObserver.h"

#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

#define DEFAULTCELLHEIGHT 49.0f

@interface AccountCenterController ()<XNMyInformationModuleObserver,ChangeUserPictureViewControllerDelegate,XNUploadPicModuleObserver,XNUserModuleObserver>

@property (nonatomic, strong) UIImage        * currentSelectedImage;
@property (nonatomic, strong) NSMutableArray * contentArray;
@property (nonatomic, strong) ChangeUserPictureViewController * changeUserPictureViewController;
@property (nonatomic, strong) ImagePickerViewController       * pickImageViewController;
@property (nonatomic, strong) CustomerServiceController * phoneCtrl;
@property (nonatomic, strong) MIAccountCenterMode *mode;
@property (nonatomic, copy) NSString *levelName;

@property (nonatomic, weak) IBOutlet UITableView * setListTableView;
@end

@implementation AccountCenterController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil levelName:(NSString *)levelName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.levelName = levelName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        [[XNMyInformationModule defaultModule] addObserver:self];
        [[XNMyInformationModule defaultModule] requestAccountCenter];
        
        [self.view showGifLoading];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNMyInformationModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNUserModule defaultModule] removeObserver:self];
    [[AppFramework getGlobalHandler] removePopupCtrl];
}

///////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////

#pragma mark -初始化操作
- (void)initView
{
    [self setTitle:@"个人中心"];
    [self setCurrentSelectedImage:nil];
    [[XNUserModule defaultModule] addObserver:self];
    
    [[XNMyInformationModule defaultModule] requestMySettingInfo];
    
    [self.setListTableView registerNib:[UINib nibWithNibName:@"AccountCenterCell" bundle:nil] forCellReuseIdentifier:@"AccountCenterCell"];
    [self.setListTableView registerClass:[MessageNoDisturbViewCell class] forCellReuseIdentifier:@"MessageNoDisturbViewCell"];
    [self.setListTableView setSeparatorColor:[UIColor clearColor]];
    
    if (@available(iOS 11.0, *)) {
        
        self.setListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.contentArray objectAtIndex:indexPath.row] objectForKey:@"cellHeight"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    AccountCenterCell *cell = (AccountCenterCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountCenterCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateContent:[self.contentArray objectAtIndex:nRow] AtIndex:nRow TotalIndex:self.contentArray.count];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case RankType:
        {
            //https://preliecai.toobei.com/pages/rank/my_rank.html
            NSString *urlStr = [_LOGIC getWebUrlWithBaseUrl:@"/pages/rank/my_rank.html"];
            UniversalInteractWebViewController *webViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:urlStr requestMethod:@"GET"];
            
            [_UI pushViewControllerFromRoot:webViewController animated:YES];
        
        }
            break;
        case AvatarType:
        {
            [self.pickImageViewController show];
        }
            break;
        case MobileType:
        {
            MobileViewController *viewController = [[MobileViewController alloc] initWithNibName:@"MobileViewController" bundle:nil mobile:self.mode.mobile];
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
            break;
        case RealnameAuthenticationType:
        case BankCardManagerType:
        {
            if (self.mode.authenName.length <= 0 || self.mode.bankCard.length <= 0)
            {
                MIAddBankCardController * bankCardManagerCtrl = [[MIAddBankCardController alloc]initWithNibName:@"MIAddBankCardController" bundle:nil];
                
                [_UI pushViewControllerFromRoot:bankCardManagerCtrl animated:YES];
            }
            else
            {
                MICheckBankCardInfoController * bankCardInfoCtrl = [[MICheckBankCardInfoController alloc]initWithNibName:@"MICheckBankCardInfoController" bundle:nil];
                
                [_UI pushViewControllerFromRoot:bankCardInfoCtrl animated:YES];
            }
        }
            break;
        case PasswordManagerType:
        {
            MIPasswordManageController * passwordCtrl = [[MIPasswordManageController alloc]initWithNibName:@"MIPasswordManageController" bundle:nil];
            [_UI pushViewControllerFromRoot:passwordCtrl animated:YES];
        }
            break;
        case MoreType:
        {
            MIMoreViewController * moreCtrl = [[MIMoreViewController alloc] initWithNibName:@"MIMoreViewController" bundle:nil];
            [_UI pushViewControllerFromRoot:moreCtrl animated:YES];
        }
            break;
        case ServicePhoneType:
        {
            [self.view addSubview:self.phoneCtrl.view];
            weakSelf(weakSelf)
            [self.phoneCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(weakSelf.view);
            }];
        }
            break;
        case ExitType:
        {
            weakSelf(weakSelf)
            [self showCustomAlertViewWithTitle:@"确认退出?" titleFont:16 okTitle:@"确定" okCompleteBlock:^{
                
                [[XNUserModule defaultModule] userLogout];
                [weakSelf.view showLoadingForTitle:@"退出中..."];
            } cancelTitle:@"取消" cancelCompleteBlock:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

/////////////////////
#pragma mark - Protocol
////////////////////////////////////

#pragma mark - 个人中心
- (void)XNMyInfoModuleAccountCenterDidReceive:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    
    self.mode = module.accountCenterMode;
    
    if (self.mode.headImage.length > 0)
    {
        NSString *avatarValue = @"已设置";
        //[[self.contentArray objectAtIndex:0] setObject:avatarValue forKey:@"valueTitle"];
        //[[self.contentArray objectAtIndex:0] setObject:UIColorFromHex(0x969696) forKey:@"color"];
        [[self.contentArray objectAtIndex:1] setObject:avatarValue forKey:@"valueTitle"];
        [[self.contentArray objectAtIndex:1] setObject:UIColorFromHex(0x969696) forKey:@"color"];
    }
    
    if (self.mode.mobile.length > 0)
    {
        NSString *phone = self.mode.mobile;//[self.mode.mobile convertToSecurityPhoneNumber];
        //[[self.contentArray objectAtIndex:1] setObject:phone forKey:@"valueTitle"];
        //[[self.contentArray objectAtIndex:1] setObject:UIColorFromHex(0x969696) forKey:@"color"];
        [[self.contentArray objectAtIndex:2] setObject:phone forKey:@"valueTitle"];
        [[self.contentArray objectAtIndex:2] setObject:UIColorFromHex(0x969696) forKey:@"color"];
    }
    
    if (self.mode.authenName.length > 0)
    {
        NSString *name = self.mode.authenName;//[self.mode.authenName stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"*"];
        //[[self.contentArray objectAtIndex:2] setObject:name forKey:@"valueTitle"];
        //[[self.contentArray objectAtIndex:2] setObject:UIColorFromHex(0x969696) forKey:@"color"];
        [[self.contentArray objectAtIndex:3] setObject:name forKey:@"valueTitle"];
        [[self.contentArray objectAtIndex:3] setObject:UIColorFromHex(0x969696) forKey:@"color"];
    }
    
    if (self.mode.bankCard.length > 0)
    {
        NSString *bankCard = self.mode.bankCard;//[self.mode.bankCard convertToSecurityLastFourBankCardNumber];
        //[[self.contentArray objectAtIndex:3] setObject:bankCard forKey:@"valueTitle"];
        //[[self.contentArray objectAtIndex:3] setObject:UIColorFromHex(0x969696) forKey:@"color"];
        [[self.contentArray objectAtIndex:4] setObject:bankCard forKey:@"valueTitle"];
        [[self.contentArray objectAtIndex:4] setObject:UIColorFromHex(0x969696) forKey:@"color"];
    }

    [self.setListTableView reloadData];
}

- (void)XNMyInfoModuleAccountCenterDidFailed:(XNMyInformationModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic)
    {
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }
    else
    {
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    }
}

#pragma mark - 图片上传回调
- (void)XNUploadPicModuleDidUploadPicSuccess:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] uploadUserPicUrlWithImageUrl:module.imageMd5];
}

- (void)XNUploadPicModuleDidUploadPicFailed:(XNUploadPicModule *)module
{
    [self.view hideLoading];
    [[XNUploadPicModule defaultModule] removeObserver:self];
    
    [self.view showCustomWarnViewWithContent:@"上传图片失败"];
}

#pragma mark - 上传图片链接
- (void)XNUploadPicModuleDidUploadPicUrlSuccess:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] removeObserver:self];
    
    //将图片保存到沙盒
    BOOL success = [_LOGIC saveImageIntoLocalBox:self.currentSelectedImage imageName:[NSString stringWithFormat:@"%@_userPic.png",[[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]] md5]]];
    
    if (success)
    {
        [[self.contentArray objectAtIndex:1] setObject:@"已设置" forKey:@"valueTitle"];
        [self.setListTableView reloadData];
    }
    
    [self.view hideLoading];
    [self.view showCustomWarnViewWithContent:@"上传图片成功"];
}

- (void)XNUploadPicModuleDidUploadPicUrlFailed:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] removeObserver:self];
    [self.view hideLoading];
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 退出
- (void)XNUserModuleLogoutDidReceive:(XNUserModule *)module
{
    [self.view hideLoading];
    
    [[IMManager defaultIMManager] imManagerLogout];
    [_LOGIC saveValueForKey:XN_USER_TOKEN_TAG Value:@""];
    
    [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:0 comlite:^{
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_EXIT_SUCCESS_NOTIFICATION object:nil];
    }];
}

- (void)XNUserModuleLogoutDidFailed:(XNUserModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////////////
#pragma mark - setter/getter
////////////////////////////////////

#pragma mark - contentArray
- (NSMutableArray *)contentArray
{
    if (!_contentArray)
    {
        NSString *avatarValue = @"去设置";
        UIColor *avatarColor = UIColorFromHex(0x4e8cef);
        if ([NSObject isValidateInitString:[[[XNMyInformationModule defaultModule] homePageMode] headImage]])
        {
            avatarValue = @"已设置";
            avatarColor = UIColorFromHex(0x969696);
            
        }
        NSString *phone = [[[[XNMyInformationModule defaultModule] homePageMode] mobile] convertToSecurityPhoneNumber];
        UIColor *phoneColor = UIColorFromHex(0x969696);
        
        NSString *auth = @"未认证";
        UIColor *authColor = UIColorFromHex(0x4e8cef);
        
        NSString *bankCard = @"未绑定";
        UIColor *bankCardColor = UIColorFromHex(0x4e8cef);

        NSString *server = [[[XNCommonModule defaultModule] configMode] serviceTelephone];
        UIColor *color = UIColorFromHex(0x969696);
        
        NSDictionary *levelDic = [NSDictionary new];
        if (self.levelName.length == 0) {
            levelDic = @{
                         @"title":@"级职特权",
                         @"valueTitle":@"",
                         @"IconHide":[NSNumber numberWithBool:NO],
                         @"cellHeight":[NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12.f],
                         @"color":avatarColor
                        };
        } else {
            levelDic = @{
                         @"title":@"职级特权",
                         @"valueTitle":self.levelName,
                         @"IconHide":[NSNumber numberWithBool:NO],
                         @"cellHeight":[NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12.f],
                         @"color":avatarColor
                         };
        }
        
        
        _contentArray = [[NSMutableArray alloc]initWithObjects:
                           levelDic,
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"头像",@"title",avatarValue,@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide",[NSNumber numberWithFloat:DEFAULTCELLHEIGHT],@"cellHeight",avatarColor,@"color", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"手机号码",@"title",phone,@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide",[NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12],@"cellHeight",phoneColor,@"color", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"实名认证",@"title",auth,@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide",[NSNumber numberWithFloat:DEFAULTCELLHEIGHT],@"cellHeight",authColor,@"color", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"银行卡",@"title",bankCard,@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide",[NSNumber numberWithFloat:DEFAULTCELLHEIGHT],@"cellHeight",bankCardColor,@"color", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"密码管理",@"title",@"",@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide",[NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12],@"cellHeight",color,@"color", nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"更多",@"title",[NSNumber numberWithBool:NO],@"IconHide", [NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12],@"cellHeight",color,@"color",nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"客服电话",@"title",server,@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide", [NSNumber numberWithFloat:DEFAULTCELLHEIGHT + 12],@"cellHeight",color,@"color",nil],
                           [NSMutableDictionary dictionaryWithObjectsAndKeys:@"安全退出",@"title",@"",@"valueTitle",[NSNumber numberWithBool:NO],@"IconHide", [NSNumber numberWithFloat:DEFAULTCELLHEIGHT],@"cellHeight",UIColorFromHex(0x4e8cef),@"color",nil],
                         nil];
    }
    
    //NSLog(@"=== %@", _contentArray);
    
    return _contentArray;
}

#pragma mark -pickImageViewController
- (ImagePickerViewController *)pickImageViewController
{
    if (!_pickImageViewController)
    {
        _pickImageViewController =  [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewController" bundle:nil PickViewType:InitUserPicType];
        _pickImageViewController.presentedChildViewController = self;
        _pickImageViewController.canEdit = YES;
        
        weakSelf(weakSelf)
        [_pickImageViewController setPickPhotoBlock:^(UIImage *image) {
            
            weakSelf.currentSelectedImage = image;
            [weakSelf.view showLoading];
            
            //开始进行图片上传操作
            [[XNUploadPicModule defaultModule] addObserver:weakSelf];
            [[XNUploadPicModule defaultModule] uploadUserPicWithFile:image];
        }];
    }
    
    if (![[AppFramework getGlobalHandler].currentPopupCtrl isEqual:_pickImageViewController]) {
        
        [_KEYWINDOW addSubview:_pickImageViewController.view];
        [AppFramework getGlobalHandler].currentPopupCtrl = _pickImageViewController;
        
        __weak UIView * tmpKeyView = _KEYWINDOW;
        [_pickImageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpKeyView);
        }];
        [_KEYWINDOW layoutIfNeeded];
    }
    
    return _pickImageViewController;
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
