//
//  MFProductRecommendListOtherViewController.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"

@class XNFMProductListItemMode, XNFMAgentDetailMode;
@interface MFProductRecommendListOtherViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productListItemMode:(XNFMProductListItemMode *)mode agentDetailMode:(XNFMAgentDetailMode *)agentMode title:(NSString *)title desc:(NSString *)descString;

@end
