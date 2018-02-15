//
//  CocoaLogSocket.h
//  CocoaLogSocket
//
//  Created by e314521 on 17/6/21.
//  Copyright © 2017年 e314521. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SocketLog.
FOUNDATION_EXPORT double CocoaLogSocketVersionNumber;

//! Project version string for SocketLog.
FOUNDATION_EXPORT const unsigned char CocoaLogSocketVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SocketLog/PublicHeader.h>


#ifdef LOG_DEBUG
#import "DDTCPLogger.h"
#import "DDUDPLogger.h"
#import "DDTCPServer.h"
#define LOG_TCP_START(host, port)\
[DDTCPLogger start:host Port:port]

#define LOG_UDP_START(host, port)\
[DDUDPLogger start:host Port:port]
#else

#define LOG_TCP_START(host, port)
#define LOG_UDP_START(host, port)
#define DDLogError(frmt, ...)
#define DDLogWarn(frmt, ...)
#define DDLogInfo(frmt, ...)
#define DDLogDebug(frmt, ...)
#define DDLogVerbose(frmt, ...)
#endif

//Build Setting->Preprocessing Macros->LOG_DEBUG=1
//#ifdef LOG_DEBUG
//static const DDLogLevel ddLogLevel = DDLogFlagError | DDLogFlagInfo | DDLogFlagWarning;
//#endif
