//
//  DAConfig.h
//  LanguageSettingsDemo
//
//  Created by DarkAngel on 2017/5/4.
//  Copyright © 2017年 暗の天使. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 设置
 */
@interface DAConfig : NSObject
/**
 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
 */
@property (class, nonatomic, strong) NSString *userLanguage;
/**
 重置系统语言
 */
+ (void)resetSystemLanguage;

//+ (NSString *)language;
//+ (void)setLanguage:(NSString *)name;
+ (NSString *)languageCode;
+ (void)setLanguageCode:(NSString *)code;
/**
 设置默认语言
 */
+ (void)setDefaultLanguage:(NSString *)userLanguage;

+ (void)languageChange:(void(^)(void))changeBlock;

@end
