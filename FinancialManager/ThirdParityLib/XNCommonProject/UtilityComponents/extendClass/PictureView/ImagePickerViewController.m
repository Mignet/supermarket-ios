//
//  CFGImagePickerViewController.m
//  BBGApp
//
//  Created by 王希朋 on 14-12-26.
//  Copyright (c) 2014年 BBG. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "Masonry.h"


@interface ImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) PickViewType pickViewType;
@property (nonatomic, assign) PicOperationType currentPicType;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, weak) IBOutlet UIView * changePickBgView;
@property (nonatomic, weak) IBOutlet UIView * takePickBgView;
@end

@implementation ImagePickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PickViewType:(PickViewType )type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.pickViewType = type;
    }
    return self;
}

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
    self.currentPicType = 0;
    self.view.hidden = YES;
    
    if (self.pickViewType == InitUserPicType) {
        
        [self.view addSubview:self.takePickBgView];
        
        [self.takePickBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(162));
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.bottom.equalTo(self.view.mas_bottom).offset(162);
        }];

    }else
    {
        [self.view addSubview:self.changePickBgView];
        
        [self.changePickBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(162));
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.bottom.equalTo(self.view.mas_bottom).offset(212);
        }];
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - 设置完成block
-(void)setPickPhotoBlock:(PickPhotoCompleteBlock)pickPhotoCompleteBlock{
    
    //不能使用点语法
    _pickPhotoCompleteBlock = nil;
    _pickPhotoCompleteBlock = [pickPhotoCompleteBlock copy];
}

- (void)setPickPhoneSaveBlock:(PickPhoneSavePicBlock)pickPhoneSavePickBlock
{
    _pickPhoneSavePicBlock = nil;
    _pickPhoneSavePicBlock = [pickPhoneSavePickBlock copy];
}

#pragma mark - 截取图片
-(void)pickPhotoWithTag:(int)buttonIndex{
   
    self.currentPicType = buttonIndex;
    if (buttonIndex == TakePictureType) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate = self;
            self.picker.allowsEditing = self.canEdit;
            
            if (self.presentedChildViewController) {
                
                [self.presentedChildViewController presentViewController:self.picker animated:YES completion:nil];
            }
        }else
        {
            [self.view showCustomWarnViewWithContent:@"相机不能使用"];
        }
    }else if (buttonIndex == GetPictureFromAbumType){
        
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.delegate = self;
        self.picker.allowsEditing = self.canEdit;
        
        if (self.presentedChildViewController) {
            
            [self.presentedChildViewController presentViewController:self.picker animated:YES completion:nil];
        }
    }else
    {
        self.pickPhoneSavePicBlock();
    }
}

-(void)show{

    [self.view setHidden:NO];
    self.view.alpha = 1.0f;
    
    weakSelf(weakSelf)
    if (self.pickViewType == InitUserPicType) {
        
        [self.takePickBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(@(162));
            make.leading.equalTo(weakSelf.view.mas_leading);
            make.trailing.equalTo(weakSelf.view.mas_trailing);
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        }];

        
    }else
    {
        [self.changePickBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
          
            make.leading.mas_equalTo(weakSelf.view.mas_leading);
            make.trailing.mas_equalTo(weakSelf.view.mas_trailing);
            make.height.mas_equalTo(@(212));
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        }];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)hide{
    
    if (self.pickViewType == InitUserPicType) {
        
        [self.takePickBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(162);
        }];
        
    }else
    {
        [self.changePickBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(212);
        }];
    }

    [UIView animateWithDuration:0.5 animations:^{
       
        self.view.alpha = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view setHidden:YES];
    }];
}

#pragma mark - 获取图片-修改用户头像
- (IBAction)pickPhotoBtnClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
   
    [self hide];
    [self pickPhotoWithTag:(int)btn.tag];
}

#pragma mark - 取消拍照-修改用户头像
- (IBAction)cancelBtnClicked:(id)sender {
   
    [self hide];
}

#pragma mark - 退出
- (IBAction)clickExist:(id)sender
{
    [self hide];
}

////////////////////////
#pragma mark - 代理方法
////////////////////////////////

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //编辑后图片
        UIImage* image;
        if (self.canEdit) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    
        __weak typeof(self) pSelf = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [pSelf hide];
            _pickPhotoCompleteBlock(image);
        }];
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) pSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [pSelf hide];
    }];
}

//////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - picker
- (UIImagePickerController *)picker
{
    if (!_picker) {
        
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}

@end
