//
//  ESPNetWorking.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/21.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPNetWorking.h"
#import "AFNetworking.h"

#import "EspHttpParams.h"
#import "EspHttpResponse.h"
#import "EspHttpUtils.h"
#import "EspCommonUtils.h"
@interface ESPNetWorking()
@end

@implementation ESPNetWorking

+ (NSMutableArray*)getMeshInfoFromHost:(EspDevice *)device {
    NSString *url = [ESPNetWorking getLocalUrlForProtocol:device.httpType host:device.host port:device.port file:@"/mesh_info"];
    EspHttpParams *params = [[EspHttpParams alloc] init];
    params.tryCount = 3;
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    while (YES) {
        EspHttpResponse *response = [EspHttpUtils getForUrl:url params:params headers:nil];
        if ([EspCommonUtils isNull:response]) {
            break;
        }
        
        if (response.code != 200) {
            break;
        }
        
        NSString *meshID;
        int nodeCount;
        NSArray<NSString *> *nodeMacs;
        @try {
            meshID = [response getHeaderValueForKey:@"Mesh-Id"];
            nodeCount = [[response getHeaderValueForKey:@"Mesh-Node-Num"] intValue];
            nodeMacs = [[response getHeaderValueForKey:@"Mesh-Node-Mac"] componentsSeparatedByString:@","];
        } @catch (NSException *e) {
            NSLog(@"%@", e);
            break;
        }
        
        for(NSString *mac in nodeMacs) {
            EspDevice *node = [[EspDevice alloc] init];
            node.mac = mac;
            node.meshID = meshID;
            node.host = device.host;
            node.httpType = device.httpType;
            node.port = device.port;
            //[node addState:EspDeviceStateLocal];
            [result addObject:node];
        }
        
        if (nodeCount == [nodeMacs count]) {
            break;
        }
    }
    
    return result;
}
+ (NSString *)getLocalUrlForProtocol:(NSString *)protocol host:(NSString *)host port:(NSString *)port file:(NSString *)file {
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@:%@%@", protocol, host, port, file];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlStr;
}
@end
