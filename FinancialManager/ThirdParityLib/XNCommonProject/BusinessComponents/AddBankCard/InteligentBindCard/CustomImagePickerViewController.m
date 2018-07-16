//
//  CFGImagePickerViewController.m
//  BBGApp
//
//  Created by 王希朋 on 14-12-26.
//  Copyright (c) 2014年 BBG. All rights reserved.
//

#import "CustomImagePickerViewController.h"
#import "Masonry.h"
#import "CustomPhotoViewController.h"
#import "UIImage+Common.h"

#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"

@interface CustomImagePickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,XNAddBankCardModuleObserver>

@property (nonatomic, strong) UIImagePickerController * imageSelectCtrl;

@property (nonatomic,   weak) IBOutlet UIView         * takePickBgView;
@end

@implementation CustomImagePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////
#pragma mark - 自定义方法
////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.view.hidden = YES;
    self.captureBusinessType = @"0";
    
    [self.view addSubview:self.takePickBgView];
    
    [self.takePickBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(162));
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom).offset(162);
    }];
    
    [self.view layoutIfNeeded];
}

//拍照
- (IBAction)pickPhotoBtnClicked:(id)sender {
    
     [self hide];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        if ([self.captureBusinessType isEqualToString:@"0"]) {
            
            CGFloat height = self.presentedChildViewController.view.frame.size.height * 0.7;
            CGFloat width = self.presentedChildViewController.view.frame.size.height * 0.7 * (self.presentedChildViewController.view.frame.size.width / self.presentedChildViewController.view.frame.size.height);
            CGFloat orgX = (self.presentedChildViewController.view.frame.size.width - width) / 2;
            CGFloat orgY = (self.presentedChildViewController.view.frame.size.height * 0.3 - 75) / 2;
            
            CustomPhotoViewController * photoCtrl = [[CustomPhotoViewController alloc]initWithNibName:@"CustomPhotoViewController" bundle:nil maskBezierPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(orgX, orgY,width,height) cornerRadius:5] bezierPathByReversingPath] title:@"扫描身份证" describeContent:@"将身份证正面置于此区域，并对齐扫描框边缘" captureType:@"0"];
            
            weakSelf(weakSelf)
            [photoCtrl setUseCaptureImageBlock:^(NSDictionary * params) {
                
                [_UI popViewControllerFromRoot:YES];
                
                [weakSelf.presentedChildViewController scanIdCard:params];
            }];
            
            [_UI pushViewControllerFromRoot:photoCtrl animated:YES];
        }else
        {
            CGFloat height = self.presentedChildViewController.view.frame.size.height * 0.7;
            CGFloat width = self.presentedChildViewController.view.frame.size.height * 0.7 * (self.presentedChildViewController.view.frame.size.width / self.presentedChildViewController.view.frame.size.height);
            CGFloat orgX = (self.presentedChildViewController.view.frame.size.width - width) / 2;
            CGFloat orgY = (self.presentedChildViewController.view.frame.size.height * 0.3 - 75) / 2;
            
            CustomPhotoViewController * photoCtrl = [[CustomPhotoViewController alloc]initWithNibName:@"CustomPhotoViewController" bundle:nil maskBezierPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(orgX, orgY,width,height) cornerRadius:5] bezierPathByReversingPath] title:@"扫描银行卡" describeContent:@"将银行卡正面置于此区域，并对齐扫描框边缘" captureType:@"1"];
            weakSelf(weakSelf)
            [photoCtrl setUseCaptureImageBlock:^(NSDictionary * params) {
                
                [_UI popViewControllerFromRoot:YES];
                
                [weakSelf.presentedChildViewController scanBankCard:params];
            }];
            
            [_UI pushViewControllerFromRoot:photoCtrl animated:YES];
        }
    }else
    {
        [self.view showCustomWarnViewWithContent:@"相机不能使用"];
    }
}

//相册获取
- (IBAction)pickPhotoFromImageAlbum:(id)sender{
    
    [_UI presentNaviModalViewCtrl:self.imageSelectCtrl animated:YES];
    [self hide];
}

#pragma mark - 取消
- (IBAction)cancelBtnClicked:(id)sender {
    
    [self hide];
}

#pragma mark - 退出
- (IBAction)clickExist:(id)sender
{
    [self hide];
}

-(void)show{

    [self.view setHidden:NO];
    self.view.alpha = 1.0f;
    
    weakSelf(weakSelf)
    [self.takePickBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@(162));
        make.leading.equalTo(weakSelf.view.mas_leading);
        make.trailing.equalTo(weakSelf.view.mas_trailing);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)hide{
    
    [self.takePickBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(162);
    }];

    [UIView animateWithDuration:0.5 animations:^{
       
        self.view.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view setHidden:YES];
    }];
}

//////////////
#pragma mark - 组件回调
///////////////////////////////

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_UI dismissNaviModalViewCtrlAnimated:YES];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage];
    img = [img imageWithSize:CGSizeMake(320, 480)];
    
    [[XNAddBankCardModule defaultModule] addObserver:self];
    [self.presentedChildViewController.view showGifLoading];
    if ([self.captureBusinessType  isEqualToString: @"0"]) {
        
        [[XNAddBankCardModule defaultModule] uploadIdCardImage:img];
    }else
    {
        [[XNAddBankCardModule defaultModule] uploadBankCardImage:img];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_UI dismissNaviModalViewCtrlAnimated:YES];
}

//////////////////
#pragma mark - 网络请求回调用
///////////////////////////////////

//扫描银行卡
- (void)XNAccountModuleUploadBankCardImageDidReceive:(XNAddBankCardModule *)module
{
    [self.presentedChildViewController.view hideLoading];
    [[XNAddBankCardModule defaultModule] removeObserver:self];
    
    if (![NSObject isValidateInitString:module.bankCardNumberStr]) {
        
        [self.presentedChildViewController showCustomWarnViewWithContent:@"银行卡识别失败，请重新尝试" Completed:nil showTime:1.0f];
        
        return;
    }
    
    [self.presentedChildViewController scanBankCard:@{@"bankCardNumber":module.bankCardNumberStr}];
}

- (void)XNAccountModuleUploadBankCardImageDidFailed:(XNAddBankCardModule *)module
{
    [self.presentedChildViewController.view hideLoading];
    [[XNAddBankCardModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    //根据errorCode对应处理
    if (module.retCode.detailErrorDic) {
        
        [self.presentedChildViewController showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:1.0f];
    }else
        [self.presentedChildViewController showCustomWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:1.0f];
}

//扫描身份证
- (void)XNAccountModuleUploadIdCardImageDidReceive:(XNAddBankCardModule *)module
{
    [self.presentedChildViewController.view hideLoading];
    [[XNAddBankCardModule defaultModule] removeObserver:self];
    
    if (![NSObject isValidateInitString:module.idNumberStr]) {
        
        [self.presentedChildViewController showCustomWarnViewWithContent:@"身份证识别失败，请重新尝试" Completed:nil showTime:1.0f];
        
        return;
    }
    
    [self.presentedChildViewController scanIdCard:@{@"idCard":module.idNumberStr,@"userName":module.userNameStr}];
}

- (void)XNAccountModuleUploadIdCardImageDidFailed:(XNAddBankCardModule *)module
{
    [self.presentedChildViewController.view hideLoading];
    [[XNAddBankCardModule defaultModule] removeObserver:self];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    //根据errorCode对应处理
    if (module.retCode.detailErrorDic) {
        
        [self.presentedChildViewController showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:1.0f];
    }else
        [self.presentedChildViewController showCustomWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:1.0f];
}

//////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - picker
- (UIImagePickerController *)imageSelectCtrl
{
    if (!_imageSelectCtrl) {
        
        _imageSelectCtrl = [[UIImagePickerController alloc]init];
        _imageSelectCtrl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imageSelectCtrl.allowsEditing = NO;
        _imageSelectCtrl.delegate = self;
        _imageSelectCtrl.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    return _imageSelectCtrl;
}

@end
