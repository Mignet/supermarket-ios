//
//  AFSecurityPolicy+Extension.h
//  AFNetworking Tests
//
//  Created by 振增 黄 on 14-11-27.
//  Copyright (c) 2014年 AFNetworking. All rights reserved.
//

#import "AFSecurityPolicy.h"

@interface AFSecurityPolicy (Extension)

+ (OSStatus)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data keyPassword:(CFStringRef)keyPassword;

@end
