//
//  AgentDetailViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/21/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, sharedTag){
    ProductSharedTag = 1,  //产品分享
    PlatformActivitySharedTag //平台活动分享
};

@interface AgentDetailViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil platNo:(NSString *)platNo;

@end
