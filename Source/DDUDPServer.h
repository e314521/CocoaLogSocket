//
//  DDUDPServer.h
//  IOS CocoaLogSocket
//
//  Created by e314521 on 2018/2/15.
//

#import "GCDAsyncUdpSocket.h"
@interface DDUDPServer : NSObject<GCDAsyncUdpSocketDelegate>{
    GCDAsyncUdpSocket      *socket;
}
- (void)start:(uint16_t)port delegateQueue:(dispatch_queue_t)dq;
@end
