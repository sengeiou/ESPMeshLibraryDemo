//
//  ESPMeshManager.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/20.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPMeshManager.h"

@implementation ESPMeshManager{
    
}
//单例模式
+ (instancetype)share {
    static ESPMeshManager *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[ESPMeshManager alloc]init];
    });
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
    }
    return self;
    
}
-(void)starScanBLE:(BLEScanSccessBlock)successBlock failblock:(BLEScanFailedBlock)failBlock
{
    [[ESPBLEHelper share] starScan:successBlock failblock:failBlock];
}
@end
