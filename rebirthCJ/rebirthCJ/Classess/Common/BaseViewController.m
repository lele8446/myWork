//
//  ViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

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
    
    //二级页面，开启iOS7系统之后的滑动返回效果
    if ([self.navigationController   respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    //自定义返回按钮与左滑手势返回有冲突，在viewWillDisappear:与viewDidAppear:中进行处理
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)leftBackPopViewcontroller {
    [self.navigationItem setLeftBarButtonItem:[self creatLeftMenuBarButtonItem:NO]];
}

- (void)leftBackRootViewController {
    [self.navigationItem setLeftBarButtonItem:[self creatLeftMenuBarButtonItem:YES]];
}

- (UIBarButtonItem *)creatLeftMenuBarButtonItem:(BOOL)backRootView {
    UIImage *selectedImage=[UIImage imageNamed: @"left_back"];
    //设置图片颜色，不然UIBarButtonItem背景图颜色会取tintColor的颜色
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (backRootView) {
        //自定义返回按钮的图标
        return [[UIBarButtonItem alloc]initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(backRootViewcontroller:)];
    }else{
        //自定义返回按钮的图标
        return [[UIBarButtonItem alloc]initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewcontroller:)];
    }
}

- (void)backPopViewcontroller:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backRootViewcontroller:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
