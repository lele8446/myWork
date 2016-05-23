//
//  ViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithUri:(NSString *)uri ext:(NSDictionary *)ext {
    if (uri && uri.length > 0) {
        self =  [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    }else{
        self = [super initWithNibName:nil bundle:nil];
    }
    if (self) {
        self.ext = ext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.8686 green:0.9768 blue:0.9865 alpha:1.0];
    if (IOS_VERSION >= 7.0) {
        //不设置iOS7之后view将向四周延伸
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    NSLog(@"this is %@", NSStringFromClass([self class]));
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end
