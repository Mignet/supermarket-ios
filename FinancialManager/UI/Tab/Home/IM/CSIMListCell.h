//
//  CSIMListCell.h
//  FinancialManager
//
//  Created by xnkj on 15/12/11.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMConversation;
@interface CSIMListCell : UITableViewCell

- (void)refreshIMInformationForConversation:(NSDictionary *)params;
- (void)refreshContent:(NSDictionary *)params AtLastIndex:(BOOL)isTrue;
@end
