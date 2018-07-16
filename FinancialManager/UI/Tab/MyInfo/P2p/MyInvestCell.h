//
//  MyInvestCell.h
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInvestCell : UITableViewCell

- (void)updateContentWithAgentLogo:(NSString *)logo investMoney:(NSString *)investMoney investProfit:(NSString *)investProfit;
@end
