//
//  DDUDPServer.m
//  IOS CocoaLogSocket
//
//  Created by e314521 on 2018/2/15.
//

#import "DDUDPServer.h"
#define FORMAT(format, ...) [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]

@implementation DDUDPServer
- (void)start:(uint16_t)port delegateQueue:(dispatch_queue_t)dq
{
    NSError *error = nil;
    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dq];
    if (![socket bindToPort:port error:&error])
    {
        printf("%s\r\n",FORMAT(@"UDP服务启动失败(bind): %@", error));
        return;
    }
    if (![socket beginReceiving:&error])
    {
        [socket close];
        
        printf("%s\r\n",FORMAT(@"UDP服务启动失败 (recv): %@", error));
        return;
    }
    
    printf("%s\r\n",FORMAT(@"UDP服务启动成功,端口:%hu", [socket localPort]));

}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        printf("%s",[msg UTF8String]);
    }
    else
    {
        printf("数据含有非法字符(非UTF-8)\n");
    }
    
    [sock sendData:data toAddress:address withTimeout:-1 tag:0];
}
@end
