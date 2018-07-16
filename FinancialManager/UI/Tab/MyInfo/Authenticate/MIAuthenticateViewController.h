//
//  MIAuthenticateViewController.h
//  FinancialManager
//
//  Created by xnkj on 6/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MIAuthenticateDelegate <NSObject>
@optional

- (void)MIAuthenticateViewDidGoAuthenticate;
@end

@interface MIAuthenticateViewController : UIViewController

@property (nonatomic, assign) id<MIAuthenticateDelegate> delegate;
@end
