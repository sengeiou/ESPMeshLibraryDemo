//
//  ESPMeshManager.h
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESPBLEHelper.h"
#import "ESPRootScanUDP.h"
#import "ESPBLEIO.h"
#import "EspDevice.h"


@interface ESPMeshManager : NSObject

#pragma mark - 工具方法

/**
 * 单例构造方法
 * @return BabyBluetooth共享实例
 */
+ (instancetype)share;

//***********************获取当前Wi-Fi名***********************
-(nullable NSString *)getCurrentWiFiSsid;

//***********************BLE ***********************
//扫描蓝牙附近所有蓝牙Mesh设备
-(void)starScanBLE:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock;
//结束扫描
-(void)cancelScanBLE;
//连接设备并配网
-(void)starBLEPair:(EspDevice*)device ssid:(NSString*)ssid password:(NSString*)password callBackBlock:(BLEIOCallBackBlock)callBackBlock;



//***********************UDP ***********************
//扫描已联网设备根节点1025
-(void)starScanRootUDP:(UDPScanSccessBlock)successBlock failblock:(UDPScanFailedBlock)failBlock;
-(void)cancelScanRootUDP;
//***********************UDP 3232监听设备变化回掉***********************

//***********************TCP/Http ***********************
//获取root device的详细信息及子节点mac信息等等
- (NSMutableArray*)getMeshInfoFromHost:(EspDevice *)device;


//JS发送方法
//JS返回方法

@end
