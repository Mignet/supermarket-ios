//
//  CSIMViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/12/9.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"
#import "IMManager.h"

@interface CSIMViewController : BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            titleName:(NSString *)title
         conversation:(EMConversation *)conversation
         enterService:(BOOL)isEnterService
          chatAccount:(NSString *)chatAccount
            themeName:(NSString *)themeName
     customerImageUrl:(NSString *)imageUrl;
@end
