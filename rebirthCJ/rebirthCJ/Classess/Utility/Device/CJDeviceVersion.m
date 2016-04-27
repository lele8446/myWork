//
//  CJDeviceVersion.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/27.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "CJDeviceVersion.h"

@implementation CJDeviceVersion


+ (DeviceSize)deviceSize {
    CGFloat screenHeight = ({
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        BOOL isLandscape = (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight);
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        screenHeight = isLandscape ? screenWidth : screenHeight;
        screenHeight;
    });
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else
        return 0;
}

@end
