//
//  BPInviteCustomerViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@protocol BPInviteCustomerViewControllerDelegate <NSObject>

- (void)BPInviteCustomerViewControllerDidSharedWithParams:(NSDictionary *)paramsDic;

@end

@interface BPInviteCustomerViewController : BaseViewController

@property (nonatomic, assign) id<BPInviteCustomerViewControllerDelegate> delegate;

@end
