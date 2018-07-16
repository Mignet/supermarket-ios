//
//  XNNewUserController.h
//  FinancialManager
//
//  Created by xnkj on 15/11/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNNewUserControllerDelegate <NSObject>
@optional

- (void)xnNewUserControllerDidClick;
@end

@interface XNNewUserController : UIViewController

@property (nonatomic, assign) id<XNNewUserControllerDelegate> delegate;

+ (instancetype)defaultObj;


- (void)refreshGuideImage:(NSString *)imageName;
@end
