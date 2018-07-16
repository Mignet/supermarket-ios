//
//  AccountBookInvestCell.h
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountBookInvestCell : UITableViewCell

- (void)refreshWithTitleName:(NSString *)titleName investMoney:(NSString *)investMoney investProfit:(NSString *)investProfit;
@end
