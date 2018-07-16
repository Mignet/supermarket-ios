//
//  CFGImagePickerViewController.h
//  App
//
//  Created by lcp on 14-12-26.
//  Copyright (c) 2014年 BBG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MIAddBankCardController.h"

@interface CustomImagePickerViewController : UIViewController

@property (nonatomic, strong) NSString                * captureBusinessType; //业务类型，0表示身份证识别，1表示银行卡识别
@property (nonatomic,   weak) MIAddBankCardController * presentedChildViewController;

//弹出选项
- (void)show;
@end
