//
//  BabyBLEIO.m
//  OznerLibrarySwiftyDemo
//
//  Created by 赵兵 on 2016/12/27.
//  Copyright © 2016年 net.ozner. All rights reserved.
//

#import "ESPBLEIO.h"
#import "PacketCommand.h"
#import "DH_AES.h"


@interface ESPBLEIO (){
@private
    BOOL requireWifiState;
}


@property(nonatomic,strong) RSAObject *rsaobject;
@property(nonatomic,assign) uint8_t channel;

@end
@implementation ESPBLEIO
{
    //CBService* curService;
    CBCharacteristic* writeCharacteristic;
    CBCharacteristic* readCharacteristic;
}
NSString* idString;
- (instancetype)init:(EspDevice*)device ssid:(NSString*)ssid password:(NSString*)password callBackBlock:(BLEIOCallBackBlock)callBackBlock {
    self = [super init];
    if (self) {
        requireWifiState=YES;
        _device=device;
        idString=device.uuidBle;
        self.ssid=ssid;
        self.password=password;
        _CallBackBlock=callBackBlock;
        
        //初始化BabyBluetooth 蓝牙库
        baby = [BabyBluetooth shareBabyBluetooth];
        [baby cancelAllPeripheralsConnection];
        [self babyDelegate];//设置蓝牙委托
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    }
    return self;
    
}
- (void)disconnectBLE{
    [baby AutoReconnectCancel:self.currPeripheral];
    [baby cancelAllPeripheralsConnection];
}

-(void)loadData{
    
    if (baby.centralManager.state==CBCentralManagerStatePoweredOn) {
        _CallBackBlock(@"CBCentralManagerStatePoweredOn");
        self.currPeripheral=[baby retrievePeripheralWithUUIDString:idString];//获取外设
        if (self.currPeripheral==nil) {
            _CallBackBlock(@"retrievePeripheralWithUUIDString failed");
            return;
        }
        _CallBackBlock(@"retrievePeripheralWithUUIDString success");
        switch (self.currPeripheral.state) {//初始化设备状态
            case CBPeripheralStateConnected:
                _CallBackBlock(@"CBPeripheralStateConnected");
                break;
            case CBPeripheralStateDisconnected:
                _CallBackBlock(@"CBPeripheralStateDisconnected");
                break;
            default:
                //_babyBLEStatusBlock(0);
                break;
        }
        [baby AutoReconnect:self.currPeripheral];
        baby.having(self.currPeripheral).and.channel(idString).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    } else {
        _CallBackBlock(@"CBCentralManagerStatePoweredOff");
    }
    
}
////发送数据
//- (void)sendDataToDevice:(NSData *)data block:(void (^)(NSError *error))block{
//    if (self.currPeripheral != nil) {
//        if (writeCharacteristic != nil) {
//            [self.currPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
//
//            _babyFailureBlock = block;
//        }
//    }
//}
-(void)babyDelegate{
    __weak typeof(self)weakSelf = self;
    
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        [weakSelf loadData];
    }];
    [baby setBlockOnCentralManagerDidUpdateStateAtChannel:idString block:^(CBCentralManager *central) {
        [weakSelf loadData];
    }];
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:idString block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        if (![idString isEqualToString:peripheral.identifier.UUIDString]) {
            return ;
        }
        NSLog(@"设备：%@--连接成功",peripheral.name);
        weakSelf.CallBackBlock(@"设备：--连接成功");
        
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:idString block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        if (![idString isEqualToString:peripheral.identifier.UUIDString]) {
            return ;
        }
        NSLog(@"设备：%@--连接失败",peripheral.name);
        weakSelf.CallBackBlock(@"设备：--连接失败");
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:idString block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        if (![idString isEqualToString:peripheral.identifier.UUIDString]) {
            return ;
        }
        NSLog(@"设备：%@--断开连接",peripheral.name);
         weakSelf.CallBackBlock(@"设备：--断开连接");
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:idString block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        if (![idString isEqualToString:peripheral.identifier.UUIDString]) {
            return ;
        }
        if (![service.UUID.UUIDString isEqualToString:@"FFFF"]) {
            return;
        }
        for (CBCharacteristic* characteristic in service.characteristics)
        {
            
            if ([[[characteristic UUID] UUIDString] isEqualToString:@"FF01"])
            {
                self->writeCharacteristic=characteristic;
                
            }
            if ([[[characteristic UUID] UUIDString] isEqualToString:@"FF02"])
            {
                self->readCharacteristic=characteristic;
                [weakSelf setNotifiy];
                
            }
            if (self->writeCharacteristic != nil && self->readCharacteristic != nil) {
                weakSelf.CallBackBlock(@"已发现writeCharacteristic，readCharacteristic");
                continue;
            }
        }
        
        
    }];
    
//    //设置读取characteristics的委托
//    [baby setBlockOnReadValueForCharacteristicAtChannel:idString block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        if (![idString isEqualToString:peripheral.identifier.UUIDString]||Notified==false) {
//            return ;
//        }
//        NSLog(@"%@",[[NSString alloc] initWithData:characteristics.value encoding:NSASCIIStringEncoding]);
//        //weakSelf.babyBLESensorBlock(characteristics.value);
//
//    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:idString block:^(CBCharacteristic *characteristic, NSError *error) {
        //weakSelf.CallBackBlock([NSError errorWithDomain:@"写数据成功" code:1 userInfo:nil]);
        
    }];
//    //读取rssi的委托
//    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
//        weakSelf.CallBackBlock([NSError errorWithDomain:@"已发现writeCharacteristic，readCharacteristic" code:1 userInfo:nil]);
//        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
//    }];
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:idString block:^(CBCharacteristic *characteristic, NSError *error) {
        if (!error) {
            if (characteristic.isNotifying) {
                NSLog(@"BLE set notify success");
                [weakSelf updateMessage:@"Set notification success"];
                
                [weakSelf SendNegotiateDataWithDevice];
            } else {
                NSLog(@"BLE set notify failed");
                [weakSelf updateMessage:@"Set notification failed"];
                [weakSelf disconnectBLE];
            }
        } else {
            NSLog(@"BLE update notification error %@", error);
            [weakSelf updateMessage:@"Notification state error"];
            [weakSelf disconnectBLE];
        }
    }];
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@NO,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@NO,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@NO};
    
    [baby setBabyOptionsAtChannel:idString scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}
//订阅一个值
//int Notified=0;
-(void)setNotifiy{
    __weak typeof(self)weakSelf = self;
    if (self->readCharacteristic.properties & CBCharacteristicPropertyNotify ||  self->readCharacteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(!readCharacteristic.isNotifying) {
            
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self->readCharacteristic];
        
            [baby notify:self.currPeripheral
          characteristic:self->readCharacteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                      
                       //订阅蓝牙数据返回
                       if (!error) {
                           [weakSelf analyseData:[NSMutableData dataWithData:characteristics.value]];
                       } else {
                           NSLog(@"BLE notification error %@", error);
                           [weakSelf updateMessage:@"Notification error"];
                           [weakSelf disconnectBLE];
                       }
                           
                       
                       
                   }];
        }
    }
    else{
        self.CallBackBlock(@"这个characteristic没有nofity的权限");
        return;
    }
    
}

- (void)updateMessage:(NSString *)message {
    self.CallBackBlock(message);
}

- (void)writeStructDataWithDevice:(NSData *)data {
    if (_currPeripheral!=nil && writeCharacteristic!=nil) {
        [_currPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
        _device.sequence = _device.sequence + 1;
    } else {
        [self updateMessage:@"peripheral write characteristic nil"];
        [self disconnectBLE];
    }
}

- (void)analyseData:(NSMutableData *)data {
    Byte *dataByte = (Byte *)[data bytes];
    Byte Type = dataByte[0] & 0x03;
    Byte sequence = dataByte[2];
    Byte frameControl = dataByte[1];
    Byte length = dataByte[3];
    BOOL hash = frameControl & Packet_Hash_FrameCtrlType;
    BOOL checksum = frameControl & Data_End_Checksum_FrameCtrlType;
    //BOOL Drection=frameControl & Data_Direction_FrameCtrlType;
    BOOL Ack=frameControl & ACK_FrameCtrlType;
    BOOL AppendPacket=frameControl & Append_Data_FrameCtrlType;
    if (hash) {
        //zwjLog(@"加密");
        //解密
        NSRange range = NSMakeRange(4, length);
        NSData *Decryptdata = [data subdataWithRange:range];
        Byte *byte = (Byte *)[Decryptdata bytes];
        Decryptdata = [DH_AES blufi_aes_DecryptWithSequence:sequence data:byte len:length KeyData:_device.Securtkey];
        [data replaceBytesInRange:range withBytes:[Decryptdata bytes]];
    } else {
        //zwjLog(@"无加密");
    }
    if (checksum) {
        //zwjLog(@"有校验");
        //计算校验
        if ([PacketCommand VerifyCRCWithData:data]) {
            //zwjLog(@"校验成功");
        } else {
            NSLog(@"校验失败,返回");
            [self updateMessage:@"CRC error"];
            [self disconnectBLE];
            return;
        }
    } else {
        //zwjLog(@"无校验");
    }
    if (Ack) {
        //zwjLog(@"回复ACK");
        [self writeStructDataWithDevice:[PacketCommand ReturnAckWithSequence:_device.sequence BackSequence:sequence] ];
    } else {
        //zwjLog(@"不回复ACK");
    }
    if (AppendPacket) {
        //zwjLog(@"有后续包");
    } else {
        //zwjLog(@"没有后续包");
    }
    
    if (Type == ContolType) {
        //zwjLog(@"接收到控制包===========");
        [self GetControlPacketWithData:data];
    } else if (Type==DataType) {
        //zwjLog(@"接收到数据包===========");
        [self GetDataPackectWithData:data];
    } else if (Type == UserType){
        //自定义用户包
        [self GetUserPacketWithData:data];
    } else {
        NSLog(@"异常数据包");
        [self updateMessage:@"Data error"];
        [self disconnectBLE];
    }
}

//用户包解析
-(void)GetUserPacketWithData:(NSData *)data {
    Byte *dataByte = (Byte *)[data bytes];
    Byte SubType=dataByte[0]>>2;
    switch (SubType) {
        case 0x00:
            self.channel=dataByte[4];
            if (_device.index == 1) {
                //连接wifi
                [self writeStructDataWithDevice:[PacketCommand ConnectToAPWithSequence:_device.sequence]];
            }
        default:
            break;
    }
}

//控制包解析
-(void)GetControlPacketWithData:(NSData *)data {
    Byte *dataByte = (Byte *)[data bytes];
    Byte SubType=dataByte[0]>>2;
    switch (SubType) {
        case ACK_Esp32_Phone_ControlSubType:
            NSLog(@"Receive ACK ,%@", _device.name);
            _device.blufisuccess = YES;
            [self updateMessage:@"Post configure data complete"];
            if (!requireWifiState) {
                [self disconnectBLE];
                self.CallBackBlock(@"success pair");
                
            }
            break;
        case ESP32_Phone_Security_ControlSubType:
        case Wifi_Op_ControlSubType:
        case Connect_AP_ControlSubType:
        case Disconnect_AP_ControlSubType:
        case Get_Wifi_Status_ControlSubType:
        case Deauthenticate_STA_Device_SoftAP_ControlSubType:
        case Get_Version_ControlSubType:
        case Negotiate_Data_ControlSubType:
            break;
        default:
            break;
    }
}

//数据包解析
-(void)GetDataPackectWithData:(NSData *)data {
    Byte *dataByte = (Byte *)[data bytes];
    Byte SubType = dataByte[0] >> 2;
    Byte length = dataByte[3];
    
    switch (SubType) {
        case Negotiate_Data_DataSubType: //协商数据
        {
            NSLog(@"Receive negoriate data");
            if (data.length < length + 4) {
                NSLog(@"Negotiate data error");
                [self updateMessage:@"Negotiate data error"];
                [self disconnectBLE];
                return;
            }
            NSData *NegotiateData = [data subdataWithRange:NSMakeRange(4, length)];
            _device.Securtkey = [DH_AES GetSecurtKey:NegotiateData RsaObject:self.rsaobject];
            [self updateMessage:@"Negotiate security complete"];
            
            NSMutableData *data = [[NSMutableData alloc]init];
            uint8_t type[1] = {0x01};
            
            [data appendData:[[NSData alloc]initWithBytes:type length:sizeof(type)]];
            
            uint8_t length[1];
            length[0] = self.ssid.length;
            [data appendData:[[NSData alloc]initWithBytes:length length:sizeof(length)]];
            [data appendData:[self.ssid dataUsingEncoding:NSUTF8StringEncoding]];
            
            type[0] = 0x02;
            [data appendData:[[NSData alloc]initWithBytes:type length:sizeof(type)]];
            length[0] = self.password.length;
            [data appendData:[[NSData alloc]initWithBytes:length length:sizeof(length)]];
            [data appendData:[self.password dataUsingEncoding:NSUTF8StringEncoding]];
            
            type[0] = 0x03;
            NSData *meshID = [@"123456" dataUsingEncoding:NSUTF8StringEncoding];
            length[0] = meshID.length;
            [data appendData:[[NSData alloc]initWithBytes:type length:sizeof(type)]];
            [data appendData:[[NSData alloc]initWithBytes:length length:sizeof(length)]];
            [data appendData:meshID];
            
            if (_device.Securtkey) {
                if (meshID) {
                    NSLog(@"%@",data);
                    //设置meshID
                    [self writeStructDataWithDevice:[PacketCommand SetMeshID:data Sequence:_device.sequence Encrypt:YES WithKeyData:_device.Securtkey]];
                }
            } else {
                if (meshID) {
                    //设置meshID
                    NSLog(@"%@",data);
                    [self writeStructDataWithDevice:[PacketCommand SetMeshID:data Sequence:_device.sequence Encrypt:NO WithKeyData:_device.Securtkey]];
                }
            }
        }
            break;
        case Wifi_Connection_state_Report_DataSubType: //连接状态报告
            NSLog(@"Notify wifi state");
            if (length < 3) {
                [self updateMessage:@"Wifi state data error"];
                [self disconnectBLE];
                return;
            }
            Byte opMode = dataByte[4];
            NSLog(@"OP Mode %d", opMode);
            if (opMode != STAOpmode) {
                [self updateMessage:[NSString stringWithFormat:@"Wifi opmode %d", opMode]];
                [self disconnectBLE];
                return;
            }
            Byte stationConn = dataByte[5];
            NSLog(@"Wifi state %d", stationConn);
            BOOL connectWifi = stationConn == 0;
            if (!connectWifi) {
                [self updateMessage:@"Device connect wifi failed"];
                [self disconnectBLE];
                return;
            }
            [self updateMessage:@"Device connected wifi"];
            [self disconnectBLE];
            [self updateMessage:@"success pair"];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case Error_DataSubType:
            NSLog(@"Notify error code");
            if (data.length < 5) {
                NSLog(@"Error notify data error");
                [self updateMessage:@"Error notify data error"];
            } else  {
                [self updateMessage:[NSString stringWithFormat:@"Error notify code = %d", dataByte[4]]];
            }
            [self disconnectBLE];
            break;
        case BSSID_STA_DataSubType:
        case SSID_STA_DataSubType:
        case Password_STA_DataSubType:
        case SSID_SoftaAP_DataSubType:
        case Password_SoftAP_DataSubType:
        case Max_Connect_Number_SoftAP_DataSubType:
        case Authentication_SoftAP_DataSubType:
        case Channel_SoftAP_DataSubType:
        case Username_DataSubType:
        case CA_Certification_DataSubType:
        case Client_Certification_DataSubType:
        case Server_Certification_DataSubType:
        case Client_PrivateKey_DataSubType:
        case Server_PrivateKey_DataSubType:
        case Version_DataSubType:
            break;
        default:
            break;
    }
}

-(void)SendNegotiateDataWithDevice{
    if (!self.rsaobject) {
        self.rsaobject = [DH_AES DHGenerateKey];
    }
    NSInteger datacount = 139;
    //发送数据长度
    uint16_t length = self.rsaobject.P.length + self.rsaobject.g.length + self.rsaobject.PublickKey.length+6;
    [self writeStructDataWithDevice:[PacketCommand SetNegotiatelength:length Sequence:_device.sequence]];
    
    //发送数据,需要分包
    _device.senddata = [PacketCommand GenerateNegotiateData:self.rsaobject];
    NSInteger number = _device.senddata.length / datacount;
    if (number > 0) {
        for(NSInteger i = 0; i < number + 1; i++){
            if (i == number){
                NSData *data=[PacketCommand SendNegotiateData:_device.senddata Sequence:_device.sequence Frag:NO TotalLength:_device.senddata.length];
                [self writeStructDataWithDevice:data];
            } else {
                NSData *data = [PacketCommand SendNegotiateData:[_device.senddata subdataWithRange:NSMakeRange(0, datacount)] Sequence:_device.sequence Frag:YES TotalLength:_device.senddata.length];
                [self writeStructDataWithDevice:data];
                _device.senddata = [_device.senddata subdataWithRange:NSMakeRange(datacount, _device.senddata.length-datacount)];
            }
        }
    } else {
        NSData *data=[PacketCommand SendNegotiateData:_device.senddata Sequence:_device.sequence Frag:NO TotalLength:_device.senddata.length];
        [self writeStructDataWithDevice:data];
    }
}

@end

