//
//  AFURLSessionManager+Extension.m
//  GXQApp
//
//  Created by 振增 黄 on 14-12-5.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "AFURLSessionManager+Extension.h"
#import "AFSecurityPolicy+Extension.h"

@implementation AFURLSessionManager (Extension)

- (void)setAuthenticationChallenge {
    [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        
        //NSLog(@"authenticationMethod:%@", challenge.protectionSpace.authenticationMethod);
        if (challenge.previousFailureCount == 0) {
            if (((challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault) ||
                 (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) ||
                 (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest) ||
                 (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM)))
            {
                /*
                 if (self.username && self.password) {
                 // for NTLM, we will assume user name to be of the form "domain\\username"
                 NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username
                 password:self.password
                 persistence:self.credentialPersistence];
                 
                 [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
                 }
                 */
            }
            else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                if(challenge.previousFailureCount < 5) {
                    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
                    SecTrustResultType result;
                    SecTrustEvaluate(trust, &result);
                    
                    if(result == kSecTrustResultProceed ||
                       result == kSecTrustResultUnspecified || //The cert is valid, but user has not explicitly accepted/denied. Ok to proceed (Ch 15: iOS PTL :Pg 269)
                       result == kSecTrustResultRecoverableTrustFailure //The cert is invalid, but is invalid because of name mismatch. Ok to proceed (Ch 15: iOS PTL :Pg 269)
                       ) {
                        
                        *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    }
                    else {
                        
                    }
                }
                else {
                    
                }
            }
            else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
                OSStatus status = errSecSuccess;
                static SecIdentityRef identity = NULL;
                static CFArrayRef certsArray = NULL;
                if (identity == NULL) {
                    NSString *keyPassword = GXQ_HTTPS_CER_PASSWORD;
                    SecTrustRef trust = NULL;
                    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:GXQ_HTTPS_CER_NAME ofType:@"txt"]];//p12
                    status = [AFSecurityPolicy extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data keyPassword:(__bridge CFStringRef)(keyPassword)];
                }
                
                if ((certsArray == NULL)
                    && identity != NULL) {
                    SecCertificateRef certificate = nil;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void *certs[] = { certificate };
                    certsArray = CFArrayCreate(NULL, certs, 1, NULL);
                    CFRelease(certificate);
                }
                
                if(status == errSecSuccess) {
                    
                    NSArray *certificatesForCredential = (__bridge NSArray *)certsArray;
                    *credential = [NSURLCredential credentialWithIdentity:identity
                                                             certificates:certificatesForCredential
                                                              persistence:NSURLCredentialPersistencePermanent];
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    
                }
            }
        }
        else {
            //  apple proposes to cancel authentication, which results in NSURLErrorDomain error -1012, but we prefer to trigger a 401
            //        [[challenge sender] cancelAuthenticationChallenge:challenge];
            
        }
        
        return disposition;
    }];
}

@end
