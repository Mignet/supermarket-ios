//
//  CSCustomerOptionalCell.h
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCustomerDelegate.h"

@interface CSCustomerOptionalCell : UITableViewCell

@property (nonatomic, assign) id<CSCustomerDelegate> delegate;

//刷新信息
- (void)showUnInvestCustomer:(NSString *)unInvestCustomerCount careCustomer:(NSString *)caredCustomerCount;
@end
