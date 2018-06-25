//
//  BabyBLEIO.h
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2016/12/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
#import "EspDevice.h"


@interface ESPBLEIO : NSObject
{
@public
    BabyBluetooth *baby;
}
typedef void(^BLEIOCallBackBlock)(NSString *msg);
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic, copy) BLEIOCallBackBlock CallBackBlock;//code 0代表成功


@property(nonatomic, strong) NSString *ssid;
@property(nonatomic, strong) NSString *password;
@property(strong,nonatomic)  EspDevice *device;

- (instancetype)init:(EspDevice*)device ssid:(NSString*)ssid password:(NSString*)password callBackBlock:(BLEIOCallBackBlock)callBackBlock;

- (void)disconnectBLE;


@end
