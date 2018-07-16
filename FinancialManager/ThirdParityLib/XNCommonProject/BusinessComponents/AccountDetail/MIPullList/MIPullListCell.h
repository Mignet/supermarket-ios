//
//  MIPullListCell.h
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIPullListCell : UITableViewCell

- (void)updateTitle:(NSString *)title Status:(BOOL)selected;
- (void)setStatus:(BOOL)selected;
@end
