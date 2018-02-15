//
//  main.m
//  CocoaLogSocketServer
//
//  Created by e314521 on 2018/2/14.
//

#import <Foundation/Foundation.h>
#import "DDTCPServer.h"
#import "DDUDPServer.h"
static BOOL isTTY;
void system1(const char * a){
    if(isTTY){
        system(a);
    }
}
void waitinput(){
    int maxlen = 255;
    char data[maxlen];
    char *newdata = data;
    int len = 0;
    while (1) {
        char a = getchar();
        *newdata++ = a;
        len ++;
        if(a == '\n' || len >= maxlen){
            data[len - 1] = 0;
            if(strcmp(data, "clear")== 0 || strcmp(data, "reset") == 0){
                system1("reset");
            }
            if(strcmp(data, "exit")== 0 ){
                break;
            }
            len = 0;
            newdata = data;
            *newdata = 0;
        }
        
    }
}
int main(int argc, char * argv[]) {
    BOOL isTCP = false,isUDP = false;
    DDTCPServer *tcp;
    DDUDPServer *udp;
    uint16_t port = 0;
    int ch;
    while((ch=getopt(argc,argv,"tup:"))!=-1)
    {
        switch(ch)
        {
            case 't':
            isTCP = true;
            break;
            case 'u':
            isUDP = true;
            break;
            case 'p':
            port = atoi(optarg);
            break;
            default:
            printf("-t TCP\n-u UDP\n-p 端口\n-h 帮助\n");
        }
    }
    if(getenv("TERM")){
        isTTY = YES;
    }
    system1("reset");
    if(!isTCP && !isUDP){
        isUDP = true;
    }
    if(port == 0){
        port = 9978;
    }
    
    
    
    @autoreleasepool {
        dispatch_queue_t dq = dispatch_queue_create("com.appshentan.socketlogserver", DISPATCH_QUEUE_SERIAL);
        if(isTCP){
            tcp = [[DDTCPServer alloc] init];
            [tcp start:port delegateQueue:dq];
        }
        if(isUDP){
            udp = [[DDUDPServer alloc] init];
            [udp start:port delegateQueue:dq];
        }
        waitinput();
    }
    return 0;
}
