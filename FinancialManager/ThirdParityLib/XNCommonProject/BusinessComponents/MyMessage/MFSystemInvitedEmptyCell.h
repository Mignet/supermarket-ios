//
//  MFSystemInvitedEmptyCell.h
//  FinancialManager
//
//  Created by xnkj on 15/11/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)();

@interface MFSystemInvitedEmptyCell : UITableViewCell

- (void)refreshTitle:(NSString *)title;

- (void)refreshTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle;

- (void)refreshTitle:(NSString *)title imageView:(NSString *)imageString;

- (void)setButtonClick:(buttonBlock)buttonBlock;

@end
