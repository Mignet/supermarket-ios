//
//  CustomPhotoViewController.m
//  FinancialManager
//
//  Created by xnkj on 22/12/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomPhotoViewController.h"
#import "XNAddBankCardModule.h"
#import "XNAddBankCardModuleObserver.h"

@interface CustomPhotoViewController ()<XNAddBankCardModuleObserver,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage * captureImage;
@property (nonatomic, strong) UIButton * captureButton;
@property (nonatomic, strong) UILabel  * captureTitleLabel;
@property (nonatomic, strong) UIButton * useImageButton;
@property (nonatomic, strong) UIButton * recaptureImageButton;

@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput * imageOutput;
@property (nonatomic, strong) AVCaptureSession * photoSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic, strong) NSString               * captureType;//0表示识别身份证，1表示银行卡
@property (nonatomic, strong) NSString               * describeContent;
@property (nonatomic, strong) UILabel                * describeLabel;
@property (nonatomic, strong) UIView                 * shadowView;
@property (nonatomic, strong) UIBezierPath           * defaultBezierPath;
@property (nonatomic, strong) CAShapeLayer           * maskShapeLayer;


@property (nonatomic, strong) UIImageView * captureImageView;
@end

@implementation CustomPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil maskBezierPath:(UIBezierPath *)bezierPath title:(NSString*)title describeContent:(NSString *)describeContent captureType:(NSString *)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = title;
        self.captureType = type;
        
        self.describeContent = describeContent;
        [self.defaultBezierPath appendPath:bezierPath];
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

- (void)dealloc
{
    [[XNAddBankCardModule defaultModule] removeObserver:self];
}

//////////////
#pragma mark - 自定义方法
////////////////////////////////////

//初始化
- (void)initView
{
    [self.recaptureImageButton setHidden:YES];
    [self.useImageButton setHidden:YES];
    
    [[XNAddBankCardModule defaultModule] addObserver:self];
    
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    
    self.photoSession = [[AVCaptureSession alloc]init];
    self.photoSession.sessionPreset = AVCaptureSessionPreset640x480;
    
    if ([self.photoSession canAddInput:self.deviceInput]) {
        
        [self.photoSession addInput:self.deviceInput];
    }
    
    if ([self.photoSession canAddOutput:self.imageOutput]) {
        
        [self.photoSession addOutput:self.imageOutput];
    }
    
    [self.maskShapeLayer setPath:self.defaultBezierPath.CGPath];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.photoSession];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.shadowView];
    [self.shadowView.layer setMask:self.maskShapeLayer];
    
    //添加拍照按钮
    self.describeLabel.text = self.describeContent;
    [self.view addSubview:self.describeLabel];
    [self.view addSubview:self.captureImageView];
    [self.view addSubview:self.captureButton];
    [self.view addSubview:self.captureTitleLabel];
    [self.view addSubview:self.recaptureImageButton];
    [self.view addSubview:self.useImageButton];
    
    weakSelf(weakSelf)
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.bottom).offset(- 20);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
    }];
    
    [self.useImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.view.mas_leading).offset( 20);
        make.bottom.mas_equalTo(weakSelf.view.bottom).offset(- 20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(55);
    }];
    
    [self.recaptureImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing).offset(- 20);
        make.bottom.mas_equalTo(weakSelf.view.bottom).offset(- 20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(55);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).offset(-37.5);
        make.width.mas_equalTo(weakSelf.view.frame.size.width - 75);
        make.height.mas_equalTo(16);
    }];
    
    [self.captureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(weakSelf.view);
    }];
    
    //开始取景
    [self.photoSession startRunning];
}

//获取设备摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice * device in devices) {
        
        if (device.position == position) {
            
            return device;
        }
    }
    return nil;
}

//设置block
- (void)setCaptrueImageBlock:(UseCaptureImage)block
{
    if (block) {
        
        self.useCaptureImageBlock = block;
    }
}

//拍照
- (IBAction)clickPhoto:(id)sender
{
    AVCaptureConnection * connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (!connection) {
        
        return;
    }
    
    weakSelf(weakSelf)
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
       
        if (imageDataSampleBuffer == nil) {
            
            return;
        }
        
        [self.recaptureImageButton setHidden:NO];
        [self.useImageButton setHidden:NO];
        [self.captureButton setHidden:YES];
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        weakSelf.captureImage = [UIImage imageWithData:imageData];
        [weakSelf.photoSession stopRunning];
    }];
}

//重新拍照
- (void)rePhoto:(UIButton *)sender
{
    self.captureImage = nil;
    [self.captureImageView setImage:nil];
    [self.recaptureImageButton setHidden:YES];
    [self.useImageButton setHidden:YES];
    [self.captureButton setHidden:NO];
    
    //开始取景
    [self.photoSession startRunning];
}

//使用当前的图片
- (void)useImage
{
    if (self.captureImage && self.useCaptureImageBlock) {
        
        if ([self.captureType  isEqualToString: @"0"]) {
            
            [[XNAddBankCardModule defaultModule] uploadIdCardImage:self.captureImage];
        }else
        {
            [[XNAddBankCardModule defaultModule] uploadBankCardImage:self.captureImage];
        }
         [self.view showSpecialGifLoading];
    }
}

////////////
#pragma mark - 网络请求回调
///////////////////////////

//扫描银行卡
- (void)XNAccountModuleUploadBankCardImageDidReceive:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    
    if (![NSObject isValidateInitString:module.bankCardNumberStr]) {
      
        [self showCustomSpecialWarnViewWithContent:@"银行卡识别失败，请重新尝试" Completed:nil showTime:2.0f];
        
        [self rePhoto:nil];
        
        return;
    }
    self.useCaptureImageBlock(@{@"bankCardNumber":module.bankCardNumberStr});
}

- (void)XNAccountModuleUploadBankCardImageDidFailed:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self rePhoto:nil];
    
    //根据errorCode对应处理
    if (module.retCode.detailErrorDic) {
        
        [self showCustomSpecialWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:2.0f];
    }else
        [self showCustomSpecialWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:2.0f];
}

//扫描身份证
- (void)XNAccountModuleUploadIdCardImageDidReceive:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    
    if (![NSObject isValidateInitString:module.idNumberStr]) {
        
        [self showCustomSpecialWarnViewWithContent:@"身份证识别失败，请重新尝试" Completed:nil showTime:2.0f];
        
        [self rePhoto:nil];
        
        return;
    }
    self.useCaptureImageBlock(@{@"idCard":module.idNumberStr,@"userName":module.userNameStr});
}

- (void)XNAccountModuleUploadIdCardImageDidFailed:(XNAddBankCardModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    [self rePhoto:nil];
    
    //根据errorCode对应处理
    if (module.retCode.detailErrorDic) {
        
        [self showCustomSpecialWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:2.0f];
    }else
        [self showCustomSpecialWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:2.0f];
}

///////////
#pragma mark - setter/getter
///////////////////////////////

//captureButton
- (UIButton *)captureButton
{
    if (!_captureButton) {
        
        _captureButton = [[UIButton alloc]init];
        [_captureButton addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_captureButton setImage:[UIImage imageNamed:@"takePhoto.png"] forState:UIControlStateNormal];
    }
    
    return _captureButton;
}

//recaptureImageButton
- (UIButton *)recaptureImageButton
{
    if (!_recaptureImageButton) {
        
        _recaptureImageButton = [[UIButton alloc]init];
        [_recaptureImageButton addTarget:self action:@selector(rePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_recaptureImageButton setTitle:@"重新拍照" forState:UIControlStateNormal];
        _recaptureImageButton.transform =CGAffineTransformMakeRotation(M_PI/2);
    }
    return _recaptureImageButton;
}

//useImageButton
- (UIButton *)useImageButton
{
    if (!_useImageButton) {
        
        _useImageButton = [[UIButton alloc]init];
        [_useImageButton addTarget:self action:@selector(useImage) forControlEvents:UIControlEventTouchUpInside];
        [_useImageButton setTitle:@"上传照片" forState:UIControlStateNormal];
        _useImageButton.transform =CGAffineTransformMakeRotation(M_PI/2);
    }
    return _useImageButton;
}

//defaultBezierPath
- (UIBezierPath *)defaultBezierPath
{
    if (!_defaultBezierPath) {
        
        _defaultBezierPath = [UIBezierPath bezierPathWithRect:SCREEN_FRAME];
    }
    return _defaultBezierPath;
}

#pragma mark - maskShapeLayer
- (CAShapeLayer *)maskShapeLayer
{
    if (!_maskShapeLayer) {
        
        _maskShapeLayer = [CAShapeLayer layer];
    }
    return _maskShapeLayer;
}

//shadowView
- (UIView *)shadowView
{
    if (!_shadowView) {
        
        _shadowView = [[UIView alloc]initWithFrame:SCREEN_FRAME];
        [_shadowView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        
    }
    return _shadowView;
}

//背景图片
- (UIImageView *)captureImageView
{
    if (!_captureImageView) {
        
        _captureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _captureImageView;
}

//describeLabel
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.font = [UIFont systemFontOfSize:16];
        _describeLabel.adjustsFontSizeToFitWidth = true;
        _describeLabel.textColor = UIColorFromHex(0x4e8cef);
        _describeLabel.numberOfLines = 0;
        _describeLabel.transform =CGAffineTransformMakeRotation(M_PI/2);
    }
    return _describeLabel;
}
@end
