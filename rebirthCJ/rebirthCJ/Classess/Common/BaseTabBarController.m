//
//  BaseTabBarController.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UINavigationController *rootController  =  (UINavigationController *)[self selectedViewController];
    UIViewController *topViewController     =  rootController.topViewController;
    if ([topViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerViewController") class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    UINavigationController *rootController  =   (UINavigationController *)[self selectedViewController];
    UIViewController *topViewController     =   rootController.topViewController;
    //判断是否横屏
    if ([topViewController isKindOfClass:[NSClassFromString(@"MPMoviePlayerViewController") class]]) {
        return YES;
    }
    
    return NO;
}

@end
