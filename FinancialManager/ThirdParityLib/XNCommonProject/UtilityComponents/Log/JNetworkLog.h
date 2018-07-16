//
//  JNetworkLog.h
//  GXQApp
//
//  Created by ganquan on 11/5/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#ifndef GXQApp_JNetworkLog_h
#define GXQApp_JNetworkLog_h

#define JN_LOG_CONTEXT NETWORK_LOG_CONTEXT

// Configure log levels.
#define JN_LOG_FLAG_ERROR   (1 << 0) // 0...00001
#define JN_LOG_FLAG_WARN    (1 << 1) // 0...00010
#define JN_LOG_FLAG_INFO    (1 << 2) // 0...00100
#define JN_LOG_FLAG_DEBUG   (1 << 3) // 0...01000
#define JN_LOG_FLAG_VERBOSE (1 << 4) // 0...10000

#define JN_LOG_LEVEL_OFF     0                                          // 0...00000
#define JN_LOG_LEVEL_ERROR   (JN_LOG_LEVEL_OFF   | JN_LOG_FLAG_ERROR)   // 0...00001
#define JN_LOG_LEVEL_WARN    (JN_LOG_LEVEL_ERROR | JN_LOG_FLAG_WARN)    // 0...00011
#define JN_LOG_LEVEL_INFO    (JN_LOG_LEVEL_WARN  | JN_LOG_FLAG_INFO)    // 0...00111
#define JN_LOG_LEVEL_DEBUG   (JN_LOG_FLAG_INFO   | JN_LOG_FLAG_DEBUG)   // 0...01111
#define JN_LOG_LEVEL_VERBOSE (JN_LOG_LEVEL_INFO  | JN_LOG_FLAG_VERBOSE) // 0...11111

////////////////////////////////////////////////////////////////////////////////

#define JN_LOG_FLAG_TRACE   (1 << 4) // 0...10000

////////////////////////////////////////////////////////////////////////////////

#define JN_LOG_ERROR    (JNLogLevel & JN_LOG_FLAG_ERROR)
#define JN_LOG_WARN     (JNLogLevel & JN_LOG_FLAG_WARN)
#define JN_LOG_INFO     (JNLogLevel & JN_LOG_FLAG_INFO)
#define JN_LOG_DEBUG    (JNLogLevel & JN_LOG_FLAG_DEBUG)
#define JN_LOG_VERBOSE  (JNLogLevel & JN_LOG_FLAG_VERBOSE)

////////////////////////////////////////////////////////////////////////////////

#define JN_LOG_ASYNC_ENABLED   YES

#define JN_LOG_ASYNC_ERROR   ( NO && JN_LOG_ASYNC_ENABLED)
#define JN_LOG_ASYNC_WARN    (YES && JN_LOG_ASYNC_ENABLED)
#define JN_LOG_ASYNC_INFO    (YES && JN_LOG_ASYNC_ENABLED)
#define JN_LOG_ASYNC_DEBUG   (YES && JN_LOG_ASYNC_ENABLED)
#define JN_LOG_ASYNC_VERBOSE (YES && JN_LOG_ASYNC_ENABLED)

////////////////////////////////////////////////////////////////////////////////

#define JNLogError(frmt, ...)   LOG_MAYBE(NO,                JNLogLevel, JN_LOG_FLAG_ERROR,   JN_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JNLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, JNLogLevel, JN_LOG_FLAG_WARN,    JN_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JNLogInfo(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, JNLogLevel, JN_LOG_FLAG_INFO,    JN_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JNLogDebug(frmt, ...)   LOG_MAYBE(LOG_ASYNC_ENABLED, JNLogLevel, JN_LOG_FLAG_DEBUG,   JN_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define JNLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, JNLogLevel, JN_LOG_FLAG_VERBOSE, JN_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#endif
