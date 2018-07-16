//
//  CSIMMsgCell.h
//  FinancialManager
//
//  Created by xnkj on 15/12/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMessage.h"

#define IMAGE_SIZE 120

@interface CSIMCustomerMsgCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

- (void)refreshMsgContent:(EMMessage *)content avatorImageString:(NSString *)avatorImageString isService:(BOOL)isService;
@end

