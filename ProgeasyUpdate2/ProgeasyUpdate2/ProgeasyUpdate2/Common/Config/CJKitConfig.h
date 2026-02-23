//
//  Created by lele8446 on 2024/4/17.
//

#import "CJKitConfig.h"


#if (DEBUG)
    #define NSLog(...) do {                        \
        NSLog(__VA_ARGS__);                        \
    } while (0)
#else
    #define NSLog(...)
#endif

//是否已经弹窗Hint请求广告跟踪
#define GAD_Ask_For_Tracking       @"GADAskForTracking"

//app退后台间隔超出30s重新打开广告
#define GAD_Open_AD_Time           30

//启动广告还是开屏广告 (0 开屏， 1 启动)
#define GAD_Open_AD_Type           1

#define GAD_TEST   0
#if (GAD_TEST)
    //Banner测试
    #define GAD_ID_Banner_Test          @"ca-app-pub-3940256099942544/2435281174"
    #define GAD_ID_Home_Banner          GAD_ID_Banner_Test
    #define GAD_ID_GIF_Home_Banner      GAD_ID_Banner_Test
    #define GAD_ID_Preview_Banner       GAD_ID_Banner_Test

    //开屏广告测试
    #define GAD_ID_Open_Test            @"ca-app-pub-3940256099942544/5662855259"
    #define GAD_ID_Open                 GAD_ID_Open_Test

    //插页广告测试
    #define GAD_ID_Present_Test         @"ca-app-pub-3940256099942544/4411468910"
    #define GAD_ID_Present              GAD_ID_Present_Test
#else
    //Banner
    #define GAD_ID_Home_Banner          @"ca-app-pub-8889097018948183/1718018491"
    #define GAD_ID_Detail_Banner        @"ca-app-pub-8889097018948183/1167354151"
    #define GAD_ID_Setting_Banner       @"ca-app-pub-8889097018948183/7625284436"

    //开屏广告
    #define GAD_ID_Open                 @"ca-app-pub-8889097018948183/1688515756"

    //插页广告
    #define GAD_ID_Route_Present        @"ca-app-pub-8889097018948183/5310080464"
    #define GAD_ID_Open_Present         @"ca-app-pub-8889097018948183/5118508777"
#endif



#define CJDesignWidthScale (CJWindowWidth / 375.0f)
#define CJDesignHeightScale (CJWindowHeight / 667.0f)
#define CJGetScaleWidth(x) (CJDesignWidthScale * x)
#define CJGetScaleHeight(y) (CJDesignHeightScale * y)


#pragma mark - rect
/** 状态栏高度*/
#define CJStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
/** 导航栏默认高度*/
#define CJNavHeight 44.0f
/** tabbar默认高度*/
#define CJTabbarHeight (isIPhoneX ? (49.f+34.f) : 49.f)
/** 状态+导航高度*/
#define CJNavStatusHeight (CJNavHeight + CJStatusBarHeight)

/** 主屏幕宽度*/
#define CJWindowWidth ([[UIScreen mainScreen] bounds].size.width)
/** 主屏幕高度*/
#define CJWindowHeight ([[UIScreen mainScreen] bounds].size.height)
/** 主屏幕高度(去除状态栏)*/
#define CJWindowHeight_NoStatus (CJWindowHeight - CJStatusBarHeight)
/** 主屏幕高度(去除状态栏+导航栏)*/
#define CJWindowHeight_NoNavStatus (CJWindowHeight - CJNavStatusHeight)

/** 判断是否为iPhoneXS Max，iPhoneXS，iPhoneXR，iPhoneX 的宏， 以它们的宽高比近似做的判断 */
//X      kScreenHeight = 812.000000,kScreenWidth = 375.000000  2.1653333333
//XS     kScreenHeight = 812.000000,kScreenWidth = 375.000000  2.1653333333
//XR     kScreenHeight = 896.000000,kScreenWidth = 414.000000  2.1642512077
//XS Max kScreenHeight = 896.000000,kScreenWidth = 414.000000  2.1642512077
#define isIPhoneX (((int)((CJWindowHeight/CJWindowWidth)*100) == 216)?YES:NO)


#define kTabBarHeight            (isIPhoneX? 83:49)
#define kNavigationHeight        (isIPhoneX? 88:64)
#define kCJStatusBarHeight       (isIPhoneX? 44:20)
#define kBottomBarHeight         (isIPhoneX? 34:0)

#pragma mark - layout space
/** 控件间的默认间隙 */
#define CJSpaceNormal 10.0f

/** 内容控件与边界的左右间隙 */
#define CJSpaceLeft 16.0f
#define CJSpaceRight CJSpaceLeft

/** 内容控件与边界的上下间隙*/
#define CJSpaceTop 10.0f
#define CJSpaceBottom CJSpaceTop

#pragma mark - control size
/** 头像容器的宽高*/
#define CJUserImageWidth 50.0f * CJDesignWidthScale
#define CJUserImageHeight CJUserImageWidth
/** Cell 图标的默认大小 */
#define CJCellImageNormalSize 24.0f
/** Cell 默认高度*/
#define CJCellNormalHeight 60.0f


/** rgb颜色 10进制 */
#define CJColorFromRGB10(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
/** rgb颜色 16进制 */
#define CJColorFromRGB16(rgbValue, aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]

#define CJColorView                 CJColorFromRGB16(0xF2F2F2,1.0f)
/** 主色调 */
#define CJColorMain                 CJColorFromRGB16(0xA61942,1.0f)
#define CJColorMainBack             CJColorFromRGB16(0xA61942,1.0f)


#define CJScrollBackViewColor       CJColorFromRGB16(0xDCDCDC,1.0f)
/** 选中调整图片大小边框线颜色 */
//#define CJBottomLine                CJColorFromRGB16(0x4F86ED,1.0f)
//#define CJBottomLineHighlighted     CJColorFromRGB16(0xC71585,1.0f)
#define CJBottomLine                CJColorMain
#define CJBottomLineHighlighted     CJColorFromRGB16(0xB22222,1.0f)

#pragma mark -
/*
 中性色主要被大量的应用在界面的文字部分，
 此外背景、边框、分割线、等场景中也非常常见。
 产品中性色的定义需要考虑深色背景以及浅色背景的差异。
 */
#pragma mark - 中性色
/** 标题/主要文本 */
#define CJColorTitle_33 CJColorFromRGB16(0x333333,1.0f)
/** 次要文本 (我理解为副标题) */
#define CJColorSubtitle_66 CJColorFromRGB16(0x666666,1.0f)
/** 说明性/标签文本、系统图标 */
#define CJColorExplain_99 CJColorFromRGB16(0x999999,1.0f)
/** 暗Hint性文本 (理解为暗示性) */
#define CJColorHint_C7 CJColorFromRGB16(0xC7C7C7,1.0f)
/** 分割线 */
#define CJColorSeparator_E8 CJColorFromRGB16(0xE8E8E8,1.0f)
/** 消息置顶 */
#define CJColorStick_F4 CJColorFromRGB16(0xF4F4F4,1.0f)
/** 点击反馈（List、浅色按钮） */
#define CJColorLight_F5F8FF CJColorFromRGB16(0xF5F8FF,1.0f)
/** Sheet弹窗按钮（红色） */
#define CJColorSheet_FF3B30 CJColorFromRGB16(0xFF3B30,1.0f)

/** Nav背景色 */
//#define CJColorNavBack CJColorFromRGB16(0x07b1e5,1.0f)
#define CJColorNavBack CJColorFromRGB16(0x40ccc9,1.0f)
