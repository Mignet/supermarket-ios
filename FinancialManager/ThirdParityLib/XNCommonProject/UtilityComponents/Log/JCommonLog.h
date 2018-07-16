//
//  JCommonLog.h
//  GXQApp
//
//  Created by ganquan on 11/5/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#ifndef GXQApp_JCommonLog_h
#define GXQApp_JCommonLog_h

#define JC_LOG_CONTEXT COMMON_LOG_CONTEXT

// Configure log levels.
#define JC_LOG_FLAG_ERROR   (1 << 0) // 0...00001
#define JC_LOG_FLAG_WARN    (1 << 1) // 0...00010
#define JC_LOG_FLAG_INFO    (1 << 2) // 0...00100
#define JC_LOG_FLAG_DEBUG   (1 << 3) // 0...01000
#define JC_LOG_FLAG_VERBOSE (1 << 4) // 0...10000

#define JC_LOG_LEVEL_OFF     0                                          // 0...00000
#define JC_LOG_LEVEL_ERROR   (JC_LOG_LEVEL_OFF   | JC_LOG_FLAG_ERROR)   // 0...00001
#define JC_LOG_LEVEL_WARN    (JC_LOG_LEVEL_ERROR | JC_LOG_FLAG_WARN)    // 0...00011
#define JC_LOG_LEVEL_INFO    (JC_LOG_LEVEL_WARN  | JC_LOG_FLAG_INFO)    // 0...00111
#define JC_LOG_LEVEL_DEBUG   (JC_LOG_FLAG_INFO   | JC_LOG_FLAG_DEBUG)   // 0...01111
#define JC_LOG_LEVEL_VERBOSE (JC_LOG_LEVEL_INFO  | JC_LOG_FLAG_VERBOSE) // 0...11111

////////////////////////////////////////////////////////////////////////////////

#define JC_LOG_FLAG_TRACE   (1 << 4) // 0...10000

////////////////////////////////////////////////////////////////////////////////

#define JC_LOG_ERROR    (JCLogLevel & JC_LOG_FLAG_ERROR)
#define JC_LOG_WARN     (JCLogLevel & JC_LOG_FLAG_WARN)
#define JC_LOG_INFO     (JCLogLevel & JC_LOG_FLAG_INFO)
#define JC_LOG_DEBUG    (JCLogLevel & JC_LOG_FLAG_DEBUG)
#define JC_LOG_VERBOSE  (JCLogLevel & JC_LOG_FLAG_VERBOSE)

////////////////////////////////////////////////////////////////////////////////

#define JC_LOG_ASYNC_ENABLED   YES

#define JC_LOG_ASYNC_ERROR   ( NO && JC_LOG_ASYNC_ENABLED)
#define JC_LOG_ASYNC_WARN    (YES && JC_LOG_ASYNC_ENABLED)
#define JC_LOG_ASYNC_INFO    (YES && JC_LOG_ASYNC_ENABLED)
#define JC_LOG_ASYNC_DEBUG   (YES && JC_LOG_ASYNC_ENABLED)
#define JC_LOG_ASYNC_VERBOSE (YES && JC_LOG_ASYNC_ENABLED)

////////////////////////////////////////////////////////////////////////////////

#define JCLogError(frmt, ...)   LOG_MAYBE(NO,                JCLogLevel, JC_LOG_FLAG_ERROR,   JC_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JCLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, JCLogLevel, JC_LOG_FLAG_WARN,    JC_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JCLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, JCLogLevel, JC_LOG_FLAG_INFO,    JC_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JCLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, JCLogLevel, JC_LOG_FLAG_DEBUG,   JC_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JCLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, JCLogLevel, JC_LOG_FLAG_VERBOSE, JC_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif
