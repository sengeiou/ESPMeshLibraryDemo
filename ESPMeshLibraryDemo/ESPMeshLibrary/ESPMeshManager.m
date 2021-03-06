//
//  ESPMeshManager.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPMeshManager.h"
#import "ESPTools.h"
#import "ESPNetWorking.h"
@implementation ESPMeshManager{
    
}
//单例模式
+ (instancetype)share {
    static ESPMeshManager *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[ESPMeshManager alloc]init];
    });
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
    }
    return self;
    
}
//获取当前Wi-Fi名
-(nullable NSString *)getCurrentWiFiSsid{
    return ESPTools.getCurrentWiFiSsid;
}

//开始蓝牙扫描
-(void)starScanBLE:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock
{
    [[ESPBLEHelper share] starScan:successBlock failblock:failBlock];
}
-(void)cancelScanBLE{
    [[ESPBLEHelper share] cancelScan];
}
//开始蓝牙Wi-Fi配网
-(void)starBLEPair:(EspDevice*)device ssid:(NSString*)ssid password:(NSString*)password callBackBlock:(BLEIOCallBackBlock)callBackBlock{
    [[ESPBLEIO alloc] init:device ssid:ssid password:password callBackBlock:callBackBlock];
}


//UDP扫描已联网设备根节点
-(void)starScanRootUDP:(UDPScanSccessBlock)successBlock failblock:(UDPScanFailedBlock)failBlock
{
    [[ESPRootScanUDP share] starScan:successBlock failblock:failBlock];
}
-(void)cancelScanRootUDP{
    [[ESPRootScanUDP share] cancelScan];
}

//获取root host下的所有设备的mac
- (NSMutableArray*)getMeshInfoFromHost:(EspDevice *)device{
    return [ESPNetWorking getMeshInfoFromHost:device];
}



@end
