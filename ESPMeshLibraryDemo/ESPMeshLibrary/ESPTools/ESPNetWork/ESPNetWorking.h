//
//  ESPNetWorking.h
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/21.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EspDevice.h"
@interface ESPNetWorking : NSObject

+ (NSMutableArray*)getMeshInfoFromHost:(EspDevice *)device;
+ (NSString *)getLocalUrlForProtocol:(NSString *)protocol host:(NSString *)host port:(NSString *)port file:(NSString *)file;
@end
