//
//  CustomLoginViewController.h
//  FinancialManager
//
//  Created by xnkj on 27/07/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^loginOperation)(NSInteger status);
@interface CustomLoginViewController : BaseViewController

@property (nonatomic, copy) loginOperation block;

- (void)setLoginOperationBlock:(loginOperation)block;

//显示
- (void)show;

//隐藏
- (void)hide;
@end
