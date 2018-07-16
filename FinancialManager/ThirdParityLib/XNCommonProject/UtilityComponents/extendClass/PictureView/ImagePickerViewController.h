//
//  CFGImagePickerViewController.h
//  App
//
//  Created by lcp on 14-12-26.
//  Copyright (c) 2014年 BBG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagePickerViewConst.h"

typedef void(^PickPhotoCompleteBlock)(UIImage *image);
typedef void(^PickPhoneSavePicBlock)();

@interface ImagePickerViewController : UIViewController

@property (nonatomic, assign)   BOOL   canEdit;
@property (nonatomic, weak)     UIViewController * presentedChildViewController;
@property (nonatomic, copy  )   PickPhotoCompleteBlock pickPhotoCompleteBlock;
@property (nonatomic, copy)     PickPhoneSavePicBlock pickPhoneSavePicBlock;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PickViewType:(PickViewType )type;

-(void)setPickPhotoBlock:(PickPhotoCompleteBlock)pickPhotoCompleteBlock;
- (void)setPickPhoneSaveBlock:(PickPhoneSavePicBlock)pickPhoneSavePickBlock;

-(void)show;
@end
