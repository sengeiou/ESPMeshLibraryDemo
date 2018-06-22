//
//  EspDevice.m
//  Esp32Mesh
//
//  Created by AE on 2018/1/3.
//  Copyright © 2018年 AE. All rights reserved.
//

#import "EspDevice.h"

@implementation EspDevice

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}


-(NSString*)descriptionStr{
    return [NSString stringWithFormat:@"mac:%@,name:%@,\n,host:%@,port%@\n,meshId:%@,RSSI:%d",self.mac,self.name,self.host,self.port,self.meshID,self.RSSI];
}
@end
