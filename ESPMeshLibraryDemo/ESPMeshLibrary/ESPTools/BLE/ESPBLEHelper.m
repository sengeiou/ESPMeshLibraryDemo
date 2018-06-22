//
//  BabyBLEHelper.m
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2016/12/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

#import "ESPBLEHelper.h"
#define BleFilterName @"mesh"
@implementation ESPBLEHelper
{
    BabyBluetooth *baby;
    
}
//单例模式
+ (instancetype)share {
    static ESPBLEHelper *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[ESPBLEHelper alloc]init];
    });
    return share;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化BabyBluetooth 蓝牙库
        baby = [BabyBluetooth shareBabyBluetooth];
        //设置蓝牙委托
        [self babyDelegate];
        
    }
    return self;
    
}

-(void)starScan:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock{
   
    _successBlock=successBlock;
    _failBlock=failBlock;
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    baby.scanForPeripherals().begin();//.stop(scanTimer);
}
 //停止扫描
-(void)cancelScan{
    [baby cancelScan];
}
- (float)calcDistByRSSI:(int)rssi
{
    int iRssi = abs(rssi);
    float power = (iRssi-59)/(10*2.0);
    return pow(10, power);
}



//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state != CBCentralManagerStatePoweredOn) {
            weakSelf.failBlock(1);
            //[weakSelf cancelScan];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        NSData *macData=nil;
        NSData *ManufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];//没有这个字段
        if (!ManufacturerData || ManufacturerData.length<6)
        {
            macData = nil;
        }else{
           macData=[ManufacturerData subdataWithRange:NSMakeRange(0, 6)];
        }
        NSString *macStr=[[NSString alloc]initWithData:macData encoding:NSASCIIStringEncoding];
        EspDevice* device=[[EspDevice alloc] init];
        device.uuidBle=peripheral.identifier.UUIDString;
        device.RSSI=RSSI.intValue;
        device.name=peripheral.name;
        device.mac=macStr;
        weakSelf.successBlock(device);
        NSLog(@"发现设备uuid:%@,name:%@,距离:%d,mac:%@",peripheral.identifier.UUIDString,peripheral.name,RSSI.intValue,macStr);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheralName == nil) {
            return NO;
        }
        if ([peripheralName.lowercaseString containsString:BleFilterName]) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
       // weakSelf.babyBLEScanFailedBlock(2);
    }];
    
    
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //NSArray *scanForPeripheralsWithServices = @[[CBUUID UUIDWithString:@"FFF0"]];
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}
@end
