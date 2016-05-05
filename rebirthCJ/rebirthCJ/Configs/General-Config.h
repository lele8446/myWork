//
//  General-Config.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/28.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#ifndef General_Config_h
#define General_Config_h

#warning 发布时，将CJDEBUG设置为0
#define CJDEBUG 1

#if CJDEBUG
#define DebugLog(log, ...) NSLog(log, ##__VA_ARGS__)
#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define DebugLog(log, ...)
#define NSLog(...) {}
#endif



#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#endif /* General_Config_h */
