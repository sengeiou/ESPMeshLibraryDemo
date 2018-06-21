//
//  ESPNetWorking.m
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/21.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import "ESPNetWorking.h"
#import "AFNetworking.h"

@interface ESPNetWorking(){
    NSTimer* timer;
}

@end

@implementation ESPNetWorking
//
+ (NSMutableURLRequest*)getMeshInfoFromHost:(NSString *)host protocol:(NSString *)protocol port:(NSString*)port Parameters:(NSDictionary*)parameters{

     NSString* url=[self getLocalUrlForProtocol:protocol host:host port:port file:@"/mesh_info"];
     return [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
}
+ (NSString *)getLocalUrlForProtocol:(NSString *)protocol host:(NSString *)host port:(NSString *)port file:(NSString *)file {
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@:%@%@", protocol, host, port, file];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlStr;
}
@end
