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

@interface ESPMeshManager : NSObject

#pragma mark - 工具方法

/**
 * 单例构造方法
 * @return BabyBluetooth共享实例
 */
+ (instancetype)share;

//蓝牙设备扫描
-(void)starScanBLE:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock;
-(void)cancelScanBLE;

//获取当前Wi-Fi名
- (nullable NSString *)getCurrentWiFiSsid;

//UDP扫描已联网设备根节点
-(void)starScanRootUDP:(UDPScanSccessBlock)successBlock failblock:(UDPScanFailedBlock)failBlock;
-(void)cancelScanRootUDP;

//获取所有子节点信息
-(NSMutableURLRequest*)getMeshInfoFromHost:(NSString *)host protocol:(NSString *)protocol  port:(NSString*)port Parameters:(NSDictionary*)parameters;
//
//
@end
