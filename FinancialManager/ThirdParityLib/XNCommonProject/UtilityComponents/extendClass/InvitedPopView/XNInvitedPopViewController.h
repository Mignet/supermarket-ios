//
//  XNInvitedPopViewController.h
//  XNCommonProject
//
//  Created by xnkj on 5/4/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XNInvitedPopView.h"

@interface XNInvitedPopViewController : UIViewController

- (id)initWithDelegate:(id)delegate titlesArray:(NSArray *)titles AndIconsArray:(NSArray *)icons;

- (void)show;
- (void)hide;
@end
