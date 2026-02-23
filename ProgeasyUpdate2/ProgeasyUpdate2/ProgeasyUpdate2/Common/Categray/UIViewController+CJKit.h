//
//  UIViewController+CJKit.h
//  UIKitModule
//
//  Created by weidong liu on 2017/5/4.
//  Copyright © 2017年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJKitConfig.h"

@interface UIViewController (CJKit)

//获取当前控制器
+ (UIViewController *)mo_currentViewController;

/** 新增修改 by lianchijin 2018.11.09
 1、增加 disablePopGesture 是否禁用右滑手势返回属性，在需要禁用页面的 viewDidLoad 中设置 self.disablePopGesture = YES 即可
 2、设置默认返回按钮
 3、提供导航栏自定义左边 leftBarButtonItems 方法
 */

/**
 * 是否禁用右滑返回，默认NO
 * Created by lianchijin on 2018/11/09.
 */
@property(nonatomic, assign) BOOL disablePopGesture;

@property(nonatomic, assign) BOOL notRootShowBottomBarWhenPushed;

@property (nonatomic, assign) BOOL keyboardManagerEnable;

/**
 * 自定义leftBarItems
 * 可 return 多个按钮
 * return nil  则 leftBarItem 不存在

 @return NSArray
 */
- (NSArray <UIBarButtonItem *>*)customLeftBarItems;


/** 创建左侧图片返回按钮 nav_back */
- (void)CJ_setLeftBackBarItem;

- (void)CJ_setLeftBackImgName:(NSString *)name;
- (void)CJ_setLeftBackImage:(UIImage *)image;

/** 创建左侧图片返回按钮 nav_back */
- (void)CJ_setLeftBackBarItem:(id)target
                          action:(SEL)action;

/** 创建 字符按钮 的 rightBarItem */
- (void)CJ_setRightBarItemsByTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action;

/** 创建 图片按钮 rightBarItem */
- (void)CJ_setRightBarItemsByNormalImage:(UIImage *)normalImage
                          highlightedImage:(UIImage *)highlightedImage
                              target:(id)target
                              action:(SEL)action;


/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTitle:(NSString *)title;

/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTarget:(id)target
                              action:(SEL)action;

/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action;

- (void)CJ_showAlertTitle:(NSString *)title
                  message:(NSString *)message
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction;

- (void)CJ_showAlertTitle:(NSString *)title
                cancelStr:(NSString *)cancelStr
             cancelAction:(void(^)(void))cancelAction
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction;

- (void)CJ_showAlertTitle:(NSString *)title
                  message:(NSString *)message
                cancelStr:(NSString *)cancelStr
             cancelAction:(void(^)(void))cancelAction
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction;

- (void)CJ_showSheetTitle:(NSString *)title
             actionTitles:(NSArray <NSString *>*)actionTitles
              actionBlock:(void(^)(NSInteger index, NSString *title))actionBlock
             cancelAction:(void(^)(void))cancelAction;

- (UIImageView *)addBackImageViewWithName:(NSString *)name;
@end
