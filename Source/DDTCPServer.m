//
//  DDTCPServer.m
//  CocoaLogSocket
//
//  Created by e314521 on 2018/2/14.
//

#import "DDTCPServer.h"
#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 5.0
#define WRITE_TIMEOUT 5.0

@implementation DDTCPServer

    
- (void)start:(uint16_t)port delegateQueue:(dispatch_queue_t)dq
{
    NSError *error = nil;
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dq];
    connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
    if(![socket acceptOnPort:port error:&error]){
        NSLog(@"TCP服务启动失败(bind): %@",error);
        return;
    }
    NSLog(@"TCP服务启动成功,端口:%hu",[socket localPort]);
}
    
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
    {
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (msg)
        {
            if(msg.length > 1){
                printf("%s",[msg UTF8String]);
            }
        }
        else
        {
            printf("数据含有非法字符(非UTF-8)\n");
        }
        [sock readDataWithTimeout:READ_TIMEOUT tag:0];
    }
    
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
    {
        if (elapsed <= READ_TIMEOUT)
        {
            return READ_TIMEOUT_EXTENSION;
        }
        return 0.0;
    }
    
    
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
    {
        @synchronized(connectedSockets)
        {
            [connectedSockets addObject:newSocket];
        }
        [newSocket readDataWithTimeout:READ_TIMEOUT tag:0];
    }
    
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
    {
        if (sock != socket)
        {
            @synchronized(connectedSockets)
            {
                [connectedSockets removeObject:sock];
            }
        }
    }
@end
