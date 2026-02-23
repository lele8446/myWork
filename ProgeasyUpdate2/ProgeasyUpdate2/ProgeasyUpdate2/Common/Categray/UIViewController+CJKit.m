//
//  UIViewController+CJKit.m
//  UIKitModule
//
//  Created by weidong liu on 2017/5/4.
//  Copyright © 2017年 coson. All rights reserved.
//

#import "UIViewController+CJKit.h"
#import <objc/runtime.h>
#import <Masonry.h>
#import "UIImage+CJKit.h"

@implementation UIViewController (CJKit)

+ (UIViewController *)mo_currentViewController {
    //    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *rootViewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    return [self mo_getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)mo_getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self mo_getVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self mo_getVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self mo_getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(CJ_viewDidAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        SEL disappearSelector = @selector(viewDidDisappear:);
        SEL swizzledDisappearSelector = @selector(CJ_viewDidDisappear:);
        Method disappearMethod = class_getInstanceMethod(class, disappearSelector);
        Method swizzledDisappearMethod = class_getInstanceMethod(class, swizzledDisappearSelector);
        method_exchangeImplementations(disappearMethod, swizzledDisappearMethod);
        
#ifdef DEBUG
        SEL deallocSelector = sel_registerName("dealloc");;
        swizzledSelector = @selector(CJ_dealloc);
        originalMethod = class_getInstanceMethod(class, deallocSelector);
        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
#else
        
#endif
        
    });
}

- (void)CJ_viewDidAppear:(BOOL)animated {
    NSLog(@"%@ 进入页面 viewDidAppear:",[self class]);
    [self CJ_viewDidAppear:animated];
    if (self.keyboardManagerEnable) {
        [self IQKeyboardManagerEnable:YES];
    }
}

- (void)CJ_viewDidDisappear:(BOOL)animated {
    [self CJ_viewDidDisappear:animated];
    if (self.keyboardManagerEnable) {
        [self IQKeyboardManagerEnable:NO];
    }
}

- (void)CJ_dealloc {
    NSLog(@"%@ 释放了 dealloc",[self class]);
    [self CJ_dealloc];
}


static char disablePopGestureKey;
static char keyboardManagerEnableKey;
static char notRootShowBottomBarWhenPushedKey;

- (void)setDisablePopGesture:(BOOL)disablePopGesture {
    self.navigationController.interactivePopGestureRecognizer.enabled = !disablePopGesture;
    objc_setAssociatedObject(self, &disablePopGestureKey, @(disablePopGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disablePopGesture {
    NSNumber *value = objc_getAssociatedObject(self, &disablePopGestureKey);
    return [value boolValue];
}

- (void)setNotRootShowBottomBarWhenPushed:(BOOL)notRootShowBottomBarWhenPushed {
    objc_setAssociatedObject(self, &notRootShowBottomBarWhenPushedKey, @(notRootShowBottomBarWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)notRootShowBottomBarWhenPushed {
    NSNumber *value = objc_getAssociatedObject(self, &notRootShowBottomBarWhenPushedKey);
    return [value boolValue];
}

- (void)setKeyboardManagerEnable:(BOOL)keyboardManagerEnable {
    objc_setAssociatedObject(self, &keyboardManagerEnableKey, @(keyboardManagerEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)keyboardManagerEnable {
    NSNumber *value = objc_getAssociatedObject(self, &keyboardManagerEnableKey);
    return [value boolValue];
}

/** 创建左侧图片返回按钮 nav_back */
- (void)CJ_setLeftBackBarItem {
    [self CJ_setLeftBackBarItem:self action:@selector(backPopViewcontroller:)];
}

- (void)CJ_setLeftBackImgName:(NSString *)name {
    [self CJ_setLeftBackBarItem:self imgName:name action:@selector(backPopViewcontroller:)];
}

- (void)CJ_setLeftBackBarItem:(id)target action:(SEL)action {
    [self CJ_setLeftBackBarItem:target imgName:@"" action:action];
}

- (void)CJ_setLeftBackImage:(UIImage *)image {
    [self CJ_setLeftBackBarItem:self image:image action:@selector(backPopViewcontroller:)];
}


/** 创建左侧图片返回按钮 nav_back */
- (void)CJ_setLeftBackBarItem:(id)target imgName:(NSString *)name action:(SEL)action {
    UIImage *image = [UIImage imageNamed:(name.length>0)?name:@"nav_ic_back_black"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewcontroller:)];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

/** 创建左侧图片返回按钮 nav_back */
- (void)CJ_setLeftBackBarItem:(id)target image:(UIImage *)image action:(SEL)action {
    if (!image) {
        image = [UIImage imageNamed:@"nav_ic_back_black"];
    }
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewcontroller:)];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}


/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTitle:(NSString *)title {
    [self CJ_setLeftBackBarItemWithTitle:title target:self action:@selector(backPopViewcontroller:)];
}

/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTarget:(id)target
                                  action:(SEL)action {
    [self CJ_setLeftBackBarItemWithTitle:NSLocalizedString(@"Cancel",nil) target:self action:action];
}

/** 创建左侧文字返回按钮 nav_back */
- (void)CJ_setLeftBackBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    button = nil;
}


- (void)backPopViewcontroller:(id)sender {
    if(self.navigationController.topViewController == self &&
       self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/** 创建 字符按钮 的 rightBarItem */
- (void)CJ_setRightBarItemsByTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    button = nil;
}

/** 创建 图片按钮 rightBarItem */
- (void)CJ_setRightBarItemsByNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:normalImage forState:UIControlStateNormal];
    if(highlightedImage) {
        highlightedImage = [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    button = nil;
    
}

- (void)IQKeyboardManagerEnable:(BOOL)enable {
//    if (enable) {
//        /*
//         * 设置IQKeyboardManager
//         */
//        [IQKeyboardManager sharedManager].enable = YES;
//        //禁用键盘上的toolbar 也就是按钮
//        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//        //Turn On点击空白页面停止输入
//        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//        //自定义toolbar上的TintColor
//        [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = NO;
//        [IQKeyboardManager sharedManager].toolbarTintColor = CJColorMain;
//    }else{
//        [IQKeyboardManager sharedManager].enable = NO;
//        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    }
}

- (void)CJ_showAlertTitle:(NSString *)title
                  message:(NSString *)message
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (sureAction) {
            sureAction();
        }
    }];
    [alert addAction:action];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController mo_currentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)CJ_showAlertTitle:(NSString *)title
                cancelStr:(NSString *)cancelStr
             cancelAction:(void(^)(void))cancelAction
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction
{
    [self CJ_showAlertTitle:title message:@"" cancelStr:cancelStr cancelAction:cancelAction sureStr:sureStr sureAction:sureAction];
}

- (void)CJ_showAlertTitle:(NSString *)title
                  message:(NSString *)message
                cancelStr:(NSString *)cancelStr
             cancelAction:(void(^)(void))cancelAction
                  sureStr:(NSString *)sureStr
               sureAction:(void(^)(void))sureAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }]];
    UIAlertAction *action = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureAction) {
            sureAction();
        }
    }];
    [alert addAction:action];
    
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController mo_currentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)CJ_showSheetTitle:(NSString *)title
             actionTitles:(NSArray <NSString *>*)actionTitles
              actionBlock:(void(^)(NSInteger index, NSString *title))actionBlock
             cancelAction:(void(^)(void))cancelAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < actionTitles.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (actionBlock) {
                actionBlock(i,action.title);
            }
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelAction) {
            cancelAction();
        }
    }]];
    alert.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController mo_currentViewController] presentViewController:alert animated:YES completion:nil];
}


- (UIImageView *)addBackImageViewWithName:(NSString *)name {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:name];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    return imageView;
}
@end
