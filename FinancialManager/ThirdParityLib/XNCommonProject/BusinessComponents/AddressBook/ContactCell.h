//
//  ContactCell.h
//  FinancialManager
//
//  Created by xnkj on 15/12/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

- (void)refreshName:(NSString *)name tel:(NSString *)phoneNumber;
- (void)updateStatus:(BOOL)status;
- (void)showRecommendLabel:(BOOL)flag;

@end
