//
//  RecommendMemberCell.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNCSCfgItemMode, XNCSMyCustomerItemMode;

@interface RecommendMemberCell : UITableViewCell

@property (nonatomic, strong) XNCSCfgItemMode *cfgItem;

@property (nonatomic, strong) XNCSMyCustomerItemMode *customerItem;

- (void)updateStatus:(BOOL)status;

@end
