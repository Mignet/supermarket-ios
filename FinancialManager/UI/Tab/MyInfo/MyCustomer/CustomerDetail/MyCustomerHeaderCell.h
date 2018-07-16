//
//  MyCustomerHeaderCell.h
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickPhone)(NSString * phoneNumber);
typedef void(^ClickCared)();
typedef void(^ClickCancelCared)();

@interface MyCustomerHeaderCell : UITableViewCell

@property (nonatomic, copy) ClickPhone phoneBlock;
@property (nonatomic, copy) ClickCared caredBlock;
@property (nonatomic, copy) ClickCancelCared cancelCaredBlock;

- (void)refreshCustomHeaderImage:(NSString *)imageName customName:(NSString *)name phoneNumber:(NSString *)number caredStatus:(BOOL)status;

- (void)setClickCustomerPhone:(ClickPhone)block;
- (void)setClickCustomerCared:(ClickCared)block;
- (void)setClickCustomerCancelCared:(ClickCancelCared)block;
@end
