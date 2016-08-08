//
//  BaseNavigationController.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIImage+Extension.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationBar背景颜色，并去除底部分割线
    UIImage *image = [UIImage createImageWithColor:[UIColor colorWithRed:0.7151 green:1.0 blue:0.5194 alpha:1.0] width:SCREEN_WIDTH height:64];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
    __weak BaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - rotation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.topViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerViewController") class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    //判断是否横屏
    if ([self.topViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerViewController") class]]) {
        return YES;
    }
    
    return NO;
}

//重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果不是根控制器，隐藏TabBar
    if (self.viewControllers.count > 0) {
        // 注意这里是push进来的ViewContoller隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
        // “返回”按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"naviBar_back" hightLightedImage:nil target:self selector:@selector(back)];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}
@end
