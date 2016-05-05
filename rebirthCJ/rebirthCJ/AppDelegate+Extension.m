//
//  AppDelegate+Extension.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/29.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "AppDelegate+Extension.h"
#import "Application-Config.h"

//友盟
#import "MobClick.h"

#import <ShareSDK/ShareSDK.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"



@implementation AppDelegate (Extension)

- (void)setupUMeng {
    //友盟
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([bundleID isEqualToString:BUNDLE_ID]) {
        [MobClick startWithAppkey:UM_APP_KEY
                     reportPolicy:BATCH
                        channelId:Nil];
#if CJDEBUG
//        [MobClick setLogEnabled:YES];
#else
        [MobClick setLogEnabled:NO];
#endif
    }
}

- (void)setupShareSDK {
    [ShareSDK registerApp:SHARESDK_APP_KEY];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SINA_APP_KEY
                               appSecret:SINA_APP_SECRET
                             redirectUri:SINA_REDIRECT_URI];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:SINA_APP_KEY
                                appSecret:SINA_APP_SECRET
                              redirectUri:SINA_REDIRECT_URI
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQ_APP_ID
                           appSecret:QQ_APP_SECRET
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQ_APP_ID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:WECHAT_APP_ID
                           appSecret:WECHAT_APP_SECRET
                           wechatCls:[WXApi class]];
    
}

@end
