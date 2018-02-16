//
//  DDTCPLogger.h
//  SocketLog
//
//  Created by e314521 on 16/8/25.
//  Copyright © 2016年 e314521. All rights reserved.
//

#import "DDSocketLogger.h"
#import "GCDAsyncSocket.h"

@interface DDTCPLogger : DDSocketLogger<GCDAsyncSocketDelegate>

+(void)start:(NSString *)host Port:(uint16_t)port;

@end
