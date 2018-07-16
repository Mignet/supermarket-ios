//
//  AsyLoadSession.h
//  FinancialManager
//
//  Created by xnkj on 08/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModuleBase.h"

@interface AsyCustomerLoadSession : NSObject

+ (instancetype)asyLoadInstance;

- (void)POST:(NSString *)url parameters:(NSDictionary *)params success:(void (^)(id operation, id responseObject))successBlock failure:(void (^)(id operation, NSError * error))failureBlock;
@end
