//
//  AsyCustomerListOperation.h
//  FinancialManager
//
//  Created by xnkj on 1/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AsyCustomerLoadingStatus) {
    AsyCustomerLoadingPausedState,
    AsyCustomerLoadingReadyState,
    AsyCustomerLoadingExecutingState,
    AsyCustomerLoadingFinishedState,
};

@interface AsyCustomerListOperation : NSOperation

@end
