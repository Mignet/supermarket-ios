//
//  BPInviteCFPViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/5/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@protocol BPInviteCFPViewControllerDelegate <NSObject>

- (void)BPInviteCFPViewControllerDidSharedWithParams:(NSDictionary *)paramsDic;

@end

@interface BPInviteCFPViewController : BaseViewController

@property (nonatomic, assign) id<BPInviteCFPViewControllerDelegate> delegate;

@end
