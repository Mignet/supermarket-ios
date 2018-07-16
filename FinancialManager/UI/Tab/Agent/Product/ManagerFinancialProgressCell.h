//
//  ManagerFinancialStableCell.h
//  FinancialManager
//
//  Created by xnkj on 15/12/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNFMProductListItemMode;

@interface ManagerFinancialProgressCell : UITableViewCell

- (void)refreshDataWithParams:(XNFMProductListItemMode *)params section:(NSInteger)section index:(NSInteger )index;
@end
