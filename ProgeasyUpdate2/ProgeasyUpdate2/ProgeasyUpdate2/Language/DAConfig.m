//
//  DAConfig.m
//  LanguageSettingsDemo
//
//  Created by DarkAngel on 2017/5/4.
//  Copyright © 2017年 暗の天使. All rights reserved.
//

#import "DAConfig.h"
#import "NSBundle+DAUtils.h"

static NSString *const UWUserLanguageKey = @"UWUserLanguageKey";
#define STANDARD_USER_DEFAULT  [NSUserDefaults standardUserDefaults]

@interface DAConfig()
@property (nonatomic, copy) void(^languageChangeBlock)(void);
@end

@implementation DAConfig

+ (instancetype)manager {
    static DAConfig *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[DAConfig alloc]init];
    });
    return share;
}

+ (void)languageChange:(void(^)(void))changeBlock {
    [DAConfig manager].languageChangeBlock = changeBlock;
}

+ (void)setUserLanguage:(NSString *)userLanguage {
    //跟随手机系统
    if (!userLanguage.length) {
        [self resetSystemLanguage];
    }else{
        //用户自定义
        [STANDARD_USER_DEFAULT setValue:userLanguage forKey:UWUserLanguageKey];
        [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppleLanguages"];
        [STANDARD_USER_DEFAULT synchronize];
    }
    if([DAConfig manager].languageChangeBlock){
        [DAConfig manager].languageChangeBlock();
    }
}

+ (NSString *)userLanguage {
    return [STANDARD_USER_DEFAULT valueForKey:UWUserLanguageKey];
}

+ (void)setDefaultLanguage:(NSString *)userLanguage {
    NSString *language = [self userLanguage];
    //未设置过则设置默认值
    if(!(language && [language isKindOfClass:[NSString class]] && language.length > 0)){
        [STANDARD_USER_DEFAULT setValue:userLanguage forKey:UWUserLanguageKey];
        [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppleLanguages"];
        [STANDARD_USER_DEFAULT synchronize];
    }
    
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage {
    [STANDARD_USER_DEFAULT removeObjectForKey:UWUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:nil forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

//+ (NSString *)language {
////    if (!DAConfig.userLanguage) {
////        return NSLocalizedString(@"System default",nil);
////    }
//    NSString *str = [NSBundle currentLanguage];
//    if([str hasPrefix:@"zh-"]){//中文地区,如 "zh-Hant"、"zh-HK"、"zh-TW" 等
//        if ([str hasPrefix:@"zh-Hans"]) {
//            return @"简体中文";
//        }else {
//            return @"繁體中文";
//        }
//    }
//    else if ([str hasPrefix:@"fr"]) {
//        return @"Français";
//    }
//    else if ([str hasPrefix:@"de"]) {
//        return @"Deutsch";
//    }
//    else {
//        return @"English";
//    }
//}
//
//+ (void)setLanguage:(NSString *)name {
//    if ([name isEqualToString:NSLocalizedString(@"系统默认",nil)]) {
//        [DAConfig setUserLanguage:nil];
//    }else if ([name isEqualToString:@"English"]) {
//        [DAConfig setUserLanguage:@"en"];
//    }else if ([name isEqualToString:@"简体中文"]) {
//        [DAConfig setUserLanguage:@"zh-Hans"];
//    }else if ([name isEqualToString:@"繁體中文"]) {
//        [DAConfig setUserLanguage:@"zh-Hant"];
//    }else if ([name isEqualToString:@"Français"]) {
//        [DAConfig setUserLanguage:@"fr"];
//    }else if ([name isEqualToString:@"Deutsch"]) {
//        [DAConfig setUserLanguage:@"de"];
//    }else {
//        [DAConfig setUserLanguage:@"en"];
//    }
//}

+ (NSString *)languageCode {
    NSString *str = [NSBundle currentLanguage];
    return str;
}
+ (void)setLanguageCode:(NSString *)code {
    [DAConfig setUserLanguage:code];
}

@end
