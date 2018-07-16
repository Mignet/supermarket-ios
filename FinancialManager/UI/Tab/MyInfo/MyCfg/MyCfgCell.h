//
//  MyCfgCell.h
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNCSNewCustomerItemModel;
@interface MyCfgCell : UITableViewCell

- (void)showCfgInfo:(XNCSNewCustomerItemModel *)model type:(NSString *)busType;
@end
