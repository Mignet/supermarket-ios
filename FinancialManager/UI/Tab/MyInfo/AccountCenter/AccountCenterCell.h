//
//  AccountCenterCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/21.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCenterCell : UITableViewCell

- (void)updateContent:(NSDictionary *)params AtIndex:(NSInteger )index TotalIndex:(NSInteger )totalIndex;
@end
