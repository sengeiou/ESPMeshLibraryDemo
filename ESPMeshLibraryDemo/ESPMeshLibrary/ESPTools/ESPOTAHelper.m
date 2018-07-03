//
//  ESPOTAHelper.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/29.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPOTAHelper.h"
#import "EspJsonUtils.h"
#import "EspHttpParams.h"

@implementation ESPOTAHelper
//获取服务器bin文件信息

//获取设备版本信息

//socket 分包发送bin信息
-(void)starOTA:(NSArray<EspDevice *> *)devices binPath:(NSString *)binpath timeOut:(int)timeout callback:(CallBack)callback {
    self->callBack=callback;
    self->timeOut=timeout;//超时时间
    self->binPath=binpath;
    //获取设备升级版本信息
    self->statusTimer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(requestota_status) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self->statusTimer forMode:NSDefaultRunLoopMode];
    
    
    EspDevice *deviceFirst = devices[0];
    NSString *host = deviceFirst.host;
    int port = deviceFirst.port.intValue;
    
    NSData *binData = [NSData dataWithContentsOfFile:binpath];
    if (!binData) {
        callback(@"OTA read bin data failed");
        return;
    }
    NSLog(@"OTA bin size = %lu", (unsigned long)binData.length);
    
}

-(void)requestota_status{
    NSString* version=[binPath componentsSeparatedByString:@"/"].lastObject;
    version=[version ];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:@"ota_status" forKey:@"request"];
    [postDict setObject:@"" forKey:@"ota_bin_verson"];
    [postDict setObject:version forKey:@"ota_bin_len"];
    NSData *postData = [EspJsonUtils getDataWithDictionary:postDict];
    
    EspHttpParams *params = [[EspHttpParams alloc] init];
    params.timeout = 60;
    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
    for (EspDevice *device in devices) {
        [deviceDict setObject:device forKey:device.mac];
    }
    NSMutableDictionary *respDict = [NSMutableDictionary dictionary];
}
@end
