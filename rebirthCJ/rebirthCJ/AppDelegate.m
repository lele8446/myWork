//
//  AppDelegate.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "CJDeviceVersion.h"
#import "UIImageView+AFNetworking.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setLaunchViewViewAnimation];
    
    UIViewController *ctr = [[UIViewController alloc]init];
    self.window.rootViewController = ctr;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setRootViewController {
    FirstViewController *oneCtr = [[FirstViewController alloc]initWithUri:@"FirstViewController" ext:nil];
    BaseNavigationController *oneNavigationController = [[BaseNavigationController alloc] initWithRootViewController:oneCtr];
    oneNavigationController.navigationBar.barStyle = UIBarStyleDefault;
    oneNavigationController.tabBarItem.title = @"one";
    oneNavigationController.tabBarItem.image = [UIImage imageNamed:@"1"];
    
    BaseViewController *twoCtr = [[BaseViewController alloc]initWithUri:nil ext:nil];
    BaseNavigationController *twoNavigationController = [[BaseNavigationController alloc] initWithRootViewController:twoCtr];
    twoNavigationController.navigationBar.barStyle = UIBarStyleDefault;
    twoNavigationController.tabBarItem.title = @"two";
    
    BaseViewController *threeCtr = [[BaseViewController alloc]initWithUri:nil ext:nil];
    BaseNavigationController *threeNavigationController = [[BaseNavigationController alloc] initWithRootViewController:threeCtr];
    threeNavigationController.navigationBar.barStyle = UIBarStyleDefault;
    threeNavigationController.tabBarItem.title = @"three";
    
    BaseViewController *fourCtr = [[BaseViewController alloc]initWithUri:nil ext:nil];
    BaseNavigationController *fourNavigationController = [[BaseNavigationController alloc] initWithRootViewController:fourCtr];
    fourNavigationController.navigationBar.barStyle = UIBarStyleDefault;
    fourNavigationController.tabBarItem.title = @"four";
    
    self.mainTabBarController = [[BaseTabBarController alloc] init];
    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:
                                                 oneNavigationController,
                                                 twoNavigationController,
                                                 threeNavigationController,
                                                 fourNavigationController, nil];
    self.window.rootViewController = self.mainTabBarController;
    
}

- (void)setLaunchViewViewAnimation {
    UIView *launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    launchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    
    UIImageView *backImage = [launchView viewWithTag:100];
    DeviceSize deviceSize = [CJDeviceVersion deviceSize];
    NSString *imageName = ({
        NSString *imageName;
        /* 这里的命名前缀LaunchImage跟Images.xcassets里面的LaunchImage文件夹名字相同
         * 命名后半部分－700-568是不变的
         */
        if (deviceSize == iPhone35inch) {
            imageName = @"LaunchImage.png";
        } else if (deviceSize == iPhone4inch) {
            imageName = @"LaunchImage-700-568h.png";
        } else if (deviceSize == iPhone47inch) {
            imageName = @"LaunchImage-800-667h@2x.png";
        } else if (deviceSize == iPhone55inch) {
            imageName = @"LaunchImage-800-Portrait-736h@3x.png";
        }
        imageName;
    });
    UIImage *backImg = [UIImage imageNamed:imageName];
    backImage.backgroundColor = [UIColor redColor];
    backImage.image = backImg;
    
    UIImage *image1 = [UIImage imageNamed:@"1"];
    UIImage *image2 = [UIImage imageNamed:@"2"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 30, 30)];
    
    imageView.animationImages = @[image1,image2];
    imageView.animationDuration = 0.5;//设置动画时间
    imageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [imageView startAnimating];//开始播放动画
    
    [launchView addSubview:imageView];
    
    UIImageView *loadImage = [[UIImageView alloc]initWithFrame:CGRectMake(150, 200, 100, 100)];
    [launchView addSubview:loadImage];
    NSString *uri = @"http://img0.pcauto.com.cn/pcauto/1604/26/g__1461665134579_240x160.jpg";
    NSURL *url = [[NSURL alloc]initWithString:uri];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak UIImageView *wLoadImage = loadImage;
    [loadImage setImageWithURLRequest:urlRequest
                     placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image){
                                  wLoadImage.image = image;
                                  [UIView animateWithDuration:0.6f delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                      launchView.alpha = 0.0f;
                                      launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
                                  } completion:^(BOOL finished) {
                                      [imageView stopAnimating];
                                      [launchView removeFromSuperview];
                                      [self setRootViewController];
                                  }];
                                  
                              }failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error){
                                  [UIView animateWithDuration:0.6f delay:1.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                      launchView.alpha = 0.0f;
                                      launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
                                  } completion:^(BOOL finished) {
                                      [imageView stopAnimating];
                                      [launchView removeFromSuperview];
                                      [self setRootViewController];
                                  }];
                              }];
    
    [self.window addSubview:launchView];
}
@end
