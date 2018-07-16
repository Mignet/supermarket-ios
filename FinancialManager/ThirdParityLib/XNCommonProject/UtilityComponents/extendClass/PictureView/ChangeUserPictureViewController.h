//
//  TakePictureViewController.h
//  XNCommonProject
//
//  Created by xnkj on 5/5/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeUserPictureViewControllerDelegate <NSObject>
@optional

- (void)ChangeUserPictureViewControllerDidChangePic;
@end

@interface ChangeUserPictureViewController : BaseViewController

@property (nonatomic, assign) id<ChangeUserPictureViewControllerDelegate> delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pictureName:(UIImage *)pictureName;
@end
