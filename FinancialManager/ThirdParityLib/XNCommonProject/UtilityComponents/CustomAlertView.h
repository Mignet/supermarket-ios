//
//  CustomAlertView.h
//  FinancialManager
//
//  Created by xnkj on 17/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate <NSObject>
@optional

- (void)customAlertViewDidCancel;
- (void)customAlertViewDidOk;
@end

typedef void(^cancelBlock)();
typedef void(^otherBlock)();
@interface CustomAlertView : UIWindow

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<CustomAlertViewDelegate>)delegate cancelBtn:(NSString *) cancelButton cancelComplete:(cancelBlock)cancel otherBtn:(NSString *)other otherComplete:(otherBlock)other;

- (void)show;
@end
