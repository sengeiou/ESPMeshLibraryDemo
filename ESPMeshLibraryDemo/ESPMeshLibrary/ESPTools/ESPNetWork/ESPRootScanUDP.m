//
//  ESPUDPUtils.m
//  Esp32Mesh
//
//  Created by zhaobing on 2018/6/12.
//  Copyright © 2018年 AE. All rights reserved.
//

#import "ESPRootScanUDP.h"
#import "ESPTools.h"
//#import "EspDevice.h"

@interface ESPRootScanUDP()<GCDAsyncUdpSocketDelegate>{
    NSTimer* timer;
}
@property (strong, nonatomic)GCDAsyncUdpSocket * udpCLientSoket;
@end
#define udpPort 1025
#define udpHost @"255.255.255.255"

@implementation ESPRootScanUDP

//单例模式
+ (instancetype)share {
    static ESPRootScanUDP *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[ESPRootScanUDP alloc]init];
    });
    return share;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
    
}

-(void)starScan:(UDPScanSccessBlock)successBlock failblock:(UDPScanFailedBlock)failBlock{
    
    _successBlock=successBlock;
    _failBlock=failBlock;
    //开启定时发送请求设备信息
    [self createUdpSocket];
    timer =  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendMsg) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
//停止扫描
-(void)cancelScan{
    [_udpCLientSoket close];
    _udpCLientSoket = nil;
    
    //取消定时器
    [timer invalidate];
    timer = nil;
}

-(void) createUdpSocket{
    [self cancelScan];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _udpCLientSoket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:queue];
    NSError * error = nil;
    [_udpCLientSoket bindToPort:udpPort error:&error];
    [_udpCLientSoket enableBroadcast:true error:nil];
    if (error) {
        NSLog(@"error:%@",error);
    }else {
        [_udpCLientSoket beginReceiving:&error];
    }
}

- (void) sendMsg {
    NSString *s = @"Are You Espressif IOT Smart Device?";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    [_udpCLientSoket sendData:data toHost:udpHost port:udpPort withTimeout:-1 tag:0];
}


-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContex
{
    //取得发送发的ip和端口

    NSString *hostAddr = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *deviceAddress=[hostAddr componentsSeparatedByString:@":"].lastObject;
    NSString *curDevice=[ESPTools.getIPAddresses objectForKey:@"en0/ipv4"];
    NSLog(@"[%@:%u]",deviceAddress, port);
    //data就是接收的数据
    if ([deviceAddress isEqualToString:curDevice]==false) {//不是当前设备发的消息
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",dataStr);
        if ([dataStr.lowercaseString containsString:@"esp32 mesh"]) {
            NSArray* dataArr=[dataStr componentsSeparatedByString:@" "];
            _successBlock(dataArr[2],deviceAddress,dataArr[4],dataArr[3]);
        }
        
    }
}

@end
