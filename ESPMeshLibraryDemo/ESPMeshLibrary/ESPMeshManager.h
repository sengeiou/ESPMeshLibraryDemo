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

//扫描蓝牙附近所有蓝牙Mesh设备
-(void)starScanBLE:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock;
//结束扫描
-(void)cancelScanBLE;
//连接设备并配网//(待完成)
-(void)starBLEPair:(EspDevice*)device successBlock:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock;


//获取当前Wi-Fi名
- (nullable NSString *)getCurrentWiFiSsid;

//UDP扫描已联网设备根节点
-(void)starScanRootUDP:(UDPScanSccessBlock)successBlock failblock:(UDPScanFailedBlock)failBlock;
-(void)cancelScanRootUDP;

//获取root host下的所有设备的mac
- (NSMutableArray*)getMeshInfoFromHost:(EspDevice *)device;
//
@end
