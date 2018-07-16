 //
//  main.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomApplication.h"

int main(int argc, char * argv[]) {
    
    @try {
        @autoreleasepool {
            
            return UIApplicationMain(argc, argv, NSStringFromClass([CustomApplication class]), NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception:%@",exception.description);
    }
    @finally {
        
    }
}
