//
//  CSCustomerOptionalCell.h
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCfgDelegate.h"

@interface CSCfgOptionalCell : UITableViewCell

@property (nonatomic, assign) id<CSCfgDelegate> delegate;

- (void)showUnInvestCustomer:(NSString *)unInvestCustomerCount careCustomer:(NSString *)caredCustomerCount;
@end
