//
//  CSTradeListController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/18.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@protocol MIAnnounceControllerDelegate <NSObject>
@optional

- (void)MIAnnounceControllerDidRead;
- (void)MIAnnounceControllerDidReadAll;
@end
@interface MIAnnounceController : BaseViewController

@property (nonatomic, assign) id<MIAnnounceControllerDelegate> delegate;

- (void)setFlagButtonHidden:(BOOL)hidden;
- (void)canEdit:(BOOL)edited;
@end
