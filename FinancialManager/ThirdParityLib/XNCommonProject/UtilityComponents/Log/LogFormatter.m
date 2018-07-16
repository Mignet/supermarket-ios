//
//  JFZLogFormatter.m
//  GXQApp
//
//  Created by liaochangping on 11/5/14.
//  Copyright (c) 2014 XIAOLIAOZI. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{    
    NSString *log;
    NSDateFormatter *logTimeFormatter = [[NSDateFormatter alloc] init];
    [logTimeFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    NSString *logTimeStamp =[logTimeFormatter stringFromDate: logMessage->_timestamp];
    
    switch (logMessage->_context) {
        case COMMON_LOG_CONTEXT:
        {
            NSString *logPrefix = @"[COMMON]: ";
            
            if ((logMessage->_level == JC_LOG_LEVEL_DEBUG)
                || (logMessage->_level == JC_LOG_LEVEL_VERBOSE)) {
                NSString *fullLogMessage = [NSString stringWithFormat:@"%@ | %@ @%i | %@",
                                            [logMessage fileName], logMessage->_function, logMessage->_line, logMessage->_message];
                log = [NSString stringWithFormat:@"%@ %@%@", logTimeStamp, logPrefix, fullLogMessage];
            }
            else
            {
                log = [NSString stringWithFormat:@"%@ %@%@", logTimeStamp, logPrefix, logMessage->_message];
            }
            
        }
            break;
        case NETWORK_LOG_CONTEXT:
        {
            NSString *logPrefix = @"[NETWORK]: ";
            
            
            
            if ((logMessage->_level == JN_LOG_LEVEL_DEBUG)
                || (logMessage->_level == JN_LOG_LEVEL_VERBOSE)) {
                NSString *fullLogMessage = [NSString stringWithFormat:@"%@ | %@ @%i | %@",
                                            [logMessage fileName], logMessage->_function, logMessage->_line, logMessage->_message];
                log = [NSString stringWithFormat:@"%@ %@%@", logTimeStamp, logPrefix, fullLogMessage];
            }
            else
            {
                log = [NSString stringWithFormat:@"%@ %@%@", logTimeStamp, logPrefix, logMessage->_message];
            }
        }
            break;
        
        default:
        {
            NSString *logPrefix = @"[DDLog]: ";
            
                NSString *fullLogMessage = [NSString stringWithFormat:@"%@ | %@ @%i | %@",
                                            [logMessage fileName], logMessage->_function, logMessage->_line, logMessage->_message];
                log = [NSString stringWithFormat:@"%@ %@%@", logTimeStamp, logPrefix, fullLogMessage];
        }
            break;
    }
    
    return log;
}
@end
