//
//  DispatchRedPacketContainerViewController.h
//  FinancialManager
//
//  Created by xnkj on 6/20/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,CouponType){
    
    MyRedPacketType = 0,
    LevelCouponType,
    ComissionCouponType
};
@interface CouponContainerViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil currentRedPacketType:(CouponType)type;
@end
