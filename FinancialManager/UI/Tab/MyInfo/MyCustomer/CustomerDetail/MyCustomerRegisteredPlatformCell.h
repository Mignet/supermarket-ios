//
//  MyCustomerRegisteredPlatformCell.h
//  FinancialManager
//
//  Created by xnkj on 18/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExpandRegisteredPlatformOperation)(BOOL expandStatus, CGFloat platformHeight);

@interface MyCustomerRegisteredPlatformCell : UITableViewCell

@property (nonatomic, copy) ExpandRegisteredPlatformOperation expandBlock;

- (void)setClickExpandRegisteredPlatformOperation:(ExpandRegisteredPlatformOperation)block;

//填充已注册的平台
- (void)setRegistedPlatform:(NSArray *)platformArray expandStatus:(BOOL)status;
@end
