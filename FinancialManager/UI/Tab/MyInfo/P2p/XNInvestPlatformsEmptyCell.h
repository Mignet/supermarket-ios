//
//  XNInvestPlatformsEmptyCellTableViewCell.h
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^recommendBlock)();

@interface XNInvestPlatformsEmptyCell : UITableViewCell

- (void)showExplain:(NSString *)string btnTitle:(NSString *)title;

- (void)setCliekRecommend:(recommendBlock)recommendBlock;
@end
