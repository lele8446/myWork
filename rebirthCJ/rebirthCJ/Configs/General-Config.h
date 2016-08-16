//
//  General-Config.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/28.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#ifndef General_Config_h
#define General_Config_h

//#warning 发布时，将CJDEBUG设置为0
//#define CJDEBUG 1

#if defined(DEBUG)||defined(_DEBUG)
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/*
 根据RGB创建颜色
 */
#define CJRGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#endif /* General_Config_h */
