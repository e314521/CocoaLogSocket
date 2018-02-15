//
//  DDUDPLogger.m
//  SocketLog
//
//  Created by e314521 on 16/8/25.
//  Copyright © 2016年 e314521. All rights reserved.
//

#import "DDUDPLogger.h"

#ifndef DD_NSLOG_LEVEL
#define DD_NSLOG_LEVEL 2
#endif

#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)

@interface DDUDPLogger () {
    GCDAsyncUdpSocket *_udpSocket;
}

@end

@implementation DDUDPLogger

+ (void)start:(NSString *)host Port:(uint16_t)port{
    static DDSocketLogger *sharedInstance;
    static dispatch_once_t SocketLogOnceToken;
    
    dispatch_once(&SocketLogOnceToken, ^{
        sharedInstance = [DDUDPLogger sharedInstance:host Port:port];
        sharedInstance.colorsEnabled = YES;
        [DDLog addLogger:sharedInstance];
    });
}

- (instancetype)initsocket{
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_udpSocket bindToPort:0 error:&error];
    if(error != nil){
        NSLogError(@"failed.:%@",[error description]);
        return nil;
    }
    [_udpSocket beginReceiving:&error];
    if(error != nil){
        NSLogError(@"failed.:%@",[error description]);
        return nil;
    }

    self.host = @"127.0.0.1";
    self.port = 9978;
    return self;
}

- (void)sendsocket:(NSData *)data
{
    [_udpSocket sendData:data toHost:[self host] port:[self port] withTimeout:-1 tag:0];
}

@end
