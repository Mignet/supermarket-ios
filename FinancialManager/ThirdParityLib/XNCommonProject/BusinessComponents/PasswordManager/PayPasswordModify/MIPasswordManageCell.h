//
//  MIPasswordManageCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIPasswordManageCell : UITableViewCell

- (void)updateContent:(NSString *)params desc:(NSString *)descString AtIndex:(NSInteger )index TotalIndex:(NSInteger )totalIndex;
@end
