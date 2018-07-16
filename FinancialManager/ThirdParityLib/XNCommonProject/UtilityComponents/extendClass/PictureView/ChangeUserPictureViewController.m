//
//  TakePictureViewController.m
//  XNCommonProject
//
//  Created by xnkj on 5/5/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "ChangeUserPictureViewController.h"
#import "ImagePickerViewController.h"

#import "UINavigationItem+Extension.h"

#import "XNUploadPicModule.h"
#import "XNUploadPicModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface ChangeUserPictureViewController ()<XNUploadPicModuleObserver>

@property (nonatomic, strong) UIImage                     * pictureImage;
@property (nonatomic, strong) UIImage                     * currentSelectedImage;
@property (nonatomic, strong) ImagePickerViewController   * pickImageViewController;

@property (nonatomic, weak) IBOutlet UIImageView * pictureImageView;
@end

@implementation ChangeUserPictureViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pictureName:(UIImage *)picture
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.pictureImage = picture;
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

////////////////////
#pragma mark - Custom Method
////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"个人头像";
    [self setCurrentSelectedImage:nil];
    [self.navigationItem addTakePictureItemWithTarget:self action:@selector(clickTakePicture)];
    
    [self.pictureImageView setImage:self.pictureImage];
    
    [self.view addSubview:self.pickImageViewController.view];
    [self addChildViewController:self.pickImageViewController];
    
    weakSelf(weakSelf)
    [self.pickImageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 拍照
- (void)clickTakePicture
{
    [self.pickImageViewController show];
}

////////////////
#pragma mark - Protocol
/////////////////////////////////

#pragma mark - 上传图片
- (void)XNUploadPicModuleDidUploadPicSuccess:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] uploadUserPicUrlWithImageUrl:module.imageMd5];
}

- (void)XNUploadPicModuleDidUploadPicFailed:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] removeObserver:self];
    [self.view hideLoading];
    
    [self showCustomWarnViewWithContent:@"图片上传失败"];
}

#pragma mark - 上传图片链接
- (void)XNUploadPicModuleDidUploadPicUrlSuccess:(XNUploadPicModule *)module
{
    [[XNUploadPicModule defaultModule] removeObserver:self];
    
    [self.pictureImageView setImage:self.currentSelectedImage];
    
    BOOL success = [_LOGIC saveImageIntoLocalBox:self.currentSelectedImage imageName:[NSString stringWithFormat:@"%@_userPic.png",[[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]] md5]]];
    
    if (success) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChangeUserPictureViewControllerDidChangePic)]) {
            
            [self.delegate ChangeUserPictureViewControllerDidChangePic];
        }
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

////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - pickImageViewController
- (ImagePickerViewController *)pickImageViewController
{
    if (!_pickImageViewController) {
        
        _pickImageViewController = [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewController" bundle:nil PickViewType:ChangeUserPicType];
        _pickImageViewController.presentedChildViewController = self;
        _pickImageViewController.canEdit = YES;
        
        weakSelf(weakSelf)
        [_pickImageViewController setPickPhotoBlock:^(UIImage *image) {
            
            weakSelf.currentSelectedImage = image;
            [weakSelf.view showGifLoading];
            
            //开始进行图片上传操作
            [[XNUploadPicModule defaultModule] addObserver:weakSelf];
            [[XNUploadPicModule defaultModule] uploadUserPicWithFile:image];
        }];
        
        [_pickImageViewController setPickPhoneSaveBlock:^{
            
            UIImageWriteToSavedPhotosAlbum(weakSelf.pictureImageView.image, nil,nil, nil);
            [weakSelf showCustomWarnViewWithContent:@"保存至相册成功"];
        }];
    }
    return _pickImageViewController;
}

@end
