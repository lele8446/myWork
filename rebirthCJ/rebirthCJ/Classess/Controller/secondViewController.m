//
//  secondViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/5/3.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "secondViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface secondViewController ()

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareClick:(id)sender {
    
}

- (IBAction)loginClick:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   NSLog(@"userInfo = %@",userInfo);
                               }
                            }];
}

- (IBAction)loginClick2:(id)sender {

}
@end
