//
//  CJDeviceVersion.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/27.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, DeviceSize) {
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4
};

@interface CJDeviceVersion : NSObject

+ (DeviceSize)deviceSize;
@end
