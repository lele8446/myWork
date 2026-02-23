//
//  UIAlertController+CJKit.m
//  CJImageEditor
//
//  Created by lele8446 on 2022/3/20.
//

#import "UIAlertController+CJKit.h"
#import <objc/runtime.h>

@implementation UIAlertController (CJKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(CJ_AlertViewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
}

- (void)CJ_AlertViewWillAppear:(BOOL)animated {
    [self CJ_AlertViewWillAppear:animated];
    self.view.tintColor = CJColorMain;
}
@end
