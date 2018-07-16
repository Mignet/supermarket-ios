//
//  MyCustomerInvestRecordCell.h
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNCSMyCustomerInvestRecordItemMode;
@interface MyCfgInvestRecordCell : UITableViewCell

- (void)refreshInvestRecordCellWithParams:(XNCSMyCustomerInvestRecordItemMode *)params;
@end
