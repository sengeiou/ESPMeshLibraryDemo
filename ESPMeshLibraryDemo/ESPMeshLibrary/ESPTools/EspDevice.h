//
//  EspDevice.h
//  Esp32Mesh
//
//  Created by AE on 2018/1/3.
//  Copyright © 2018年 AE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EspDevice : NSObject

@property(nonatomic, strong) NSString *uuidBle;
@property(nonatomic, assign) int RSSI;
@property(nonatomic, strong) NSString *mac;
@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *httpType;
@property(nonatomic, strong) NSString *host;
@property(nonatomic, assign) NSString * port;

@property(nonatomic, strong) NSString *meshID;
@property(nonatomic, strong) NSString *parentDeviceMac;
@property(nonatomic, strong) NSString *rootDeviceMac;

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *currentRomVersion;
@property(nonatomic, assign) int typeId;
@property(nonatomic, strong) NSString *typeName;
@property(nonatomic, assign) int meshLayerLevel;

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger sequence;
@property(nonatomic,strong)NSData *Securtkey;
@property(nonatomic,strong)NSData *senddata;
@property(nonatomic,assign)BOOL blufisuccess;
@property(nonatomic,strong)NSTimer *connecttimer;
@property(nonatomic,strong)NSTimer *blufitimer;
-(NSString*)descriptionStr;
@end
