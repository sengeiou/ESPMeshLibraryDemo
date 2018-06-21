//
//  ESPNetWorking.h
//  ESPMeshLibraryDemo
//
//  Created by zhaobing on 2018/6/21.
//  Copyright © 2018年 zhaobing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPNetWorking : NSObject

+ (NSMutableURLRequest*)getMeshInfoFromHost:(NSString *)host protocol:(NSString *)protocol port:(NSString*)port Parameters:(NSDictionary*)parameters;

@end
