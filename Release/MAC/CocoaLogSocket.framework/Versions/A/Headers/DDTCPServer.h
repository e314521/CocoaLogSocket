//
//  DDTCPServer.h
//  CocoaLogSocket
//
//  Created by e314521 on 2018/2/14.
//

#import "GCDAsyncSocket.h"
@interface DDTCPServer : NSObject<GCDAsyncSocketDelegate>{
    GCDAsyncSocket      *socket;
    NSMutableArray      *connectedSockets;
}
- (void)start:(uint16_t)port delegateQueue:(dispatch_queue_t)dq;
@end
