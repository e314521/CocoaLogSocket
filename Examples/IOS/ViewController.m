//
//  ViewController.m
//  IOS Test
//
//  Created by e314521 on 2018/2/14.
//

#import "ViewController.h"
#import "CocoaLogSocket/CocoaLogSocket.h"
#ifdef LOG_DEBUG
static const DDLogLevel ddLogLevel = DDLogFlagError | DDLogFlagInfo | DDLogFlagWarning;
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LOG_TCP_START(@"192.168.3.20",9978);
    //DDLogInfo(@"123456");
    //LOG_UDP_START(@"192.168.3.20",9978);
    DDLogInfo(@"123");
    DDLogInfo(@"456");
    DDLogInfo(@"789");
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
