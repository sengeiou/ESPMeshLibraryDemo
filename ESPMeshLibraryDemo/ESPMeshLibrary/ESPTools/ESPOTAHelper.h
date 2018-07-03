//
//  ESPOTAHelper.h
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/29.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EspDevice.h"


typedef void(^CallBack)(NSString *msg);
@interface ESPOTAHelper : NSObject{
    NSTimer* statusTimer;
    CallBack callBack;
    int timeOut;
    NSString* binPath;
}

-(void)starOTA:(NSArray<EspDevice *> *)devices binPath:(NSString *)binPath timeOut:(int)timeout callback:(CallBack)callback;
@end
