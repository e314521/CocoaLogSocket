//
//  DDTCPLogger.m
//  SocketLog
//
//  Created by e314521 on 16/8/25.
//  Copyright © 2016年 e314521. All rights reserved.
//

#import "DDTCPLogger.h"

#ifndef DD_NSLOG_LEVEL
#define DD_NSLOG_LEVEL 2
#endif

#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)

@interface DDTCPLogger () {
    GCDAsyncSocket  *_tcpSocket;
    NSMutableArray  *senddatas;
}

@end

@implementation DDTCPLogger

+ (void)start:(NSString *)host Port:(uint16_t)port{
    static DDSocketLogger *sharedInstance;
    static dispatch_once_t SocketLogOnceToken;
    
    dispatch_once(&SocketLogOnceToken, ^{
        sharedInstance = [DDTCPLogger sharedInstance:host Port:port];
        sharedInstance.colorsEnabled = YES;
        [DDLog addLogger:sharedInstance];
    });
}

- (instancetype)initsocket{
    _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    senddatas = [[NSMutableArray alloc] initWithCapacity:1];
    return self;
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [sock readDataWithTimeout:- 1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if([text isEqual: @"#"]){
        [sock writeData:data withTimeout:-1 tag:0];
    }
    [sock readDataWithTimeout:- 1 tag:0];
}

- (void)sendsocket:(NSData *)data
{
    if(![_tcpSocket isConnected]){
        if([_tcpSocket isDisconnected]){
            NSError *error = nil;
            if (![_tcpSocket connectToHost:[self host] onPort:[self port] error:&error])
            {
                NSLogError(@"Error connecting: %@", error);
            }
        }
    }
    
    [_tcpSocket writeData:data withTimeout:-1 tag:0];
}
@end
