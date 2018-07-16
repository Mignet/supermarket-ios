//
//  ProductHomeSectionView.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/27/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickMore)();

@interface ProductHomeSectionView : UITableViewHeaderFooterView

@property (nonatomic, copy) clickMore moreOption;

- (void)showSectionIcon:(NSString *)iconName title:(NSString *)title moreTitle:(NSString *)moreTitle clickMore:(clickMore)more;

@end
