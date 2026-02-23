//
//  Created by lele8446 on 2024/4/17.
//

#import "CJNavigationController.h"
#import "UIViewController+CJKit.h"
#import "UIImage+CJKit.h"

@interface CJNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property(assign,nonatomic) BOOL hasPopGesture;

@end

@implementation CJNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    __weak typeof(self)weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
//    NSDictionary *dic = @{
//                          NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0],
//                          NSForegroundColorAttributeName:[UIColor whiteColor],
//                          };
//    [self.navigationBar setTitleTextAttributes:dic];
//    self.navigationBar.barTintColor = CJColorTitle_33;
//    self.navigationBar.tintColor = CJColorTitle_33;
//    self.navigationBar.shadowImage = [UIImage new];
//    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
//    [self.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    if (@available(iOS 13.0,*)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        appearance.backgroundColor = [UIColor whiteColor];
//        appearance.titleTextAttributes = dic;
//        self.navigationBar.standardAppearance = appearance;
//        self.navigationBar.scrollEdgeAppearance = appearance;
//    }
}

#pragma mark - rotation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
//    viewControllers.lastObject.hidesBottomBarWhenPushed = YES;
    [super setViewControllers:viewControllers animated:animated];
}

//重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果不是根控制器，隐藏TabBar
    if (self.viewControllers.count > 0) {
        // 注意这里是push进来的ViewContoller隐藏TabBar
        if(viewController.notRootShowBottomBarWhenPushed) {
            viewController.hidesBottomBarWhenPushed = NO;
        }else{
            viewController.hidesBottomBarWhenPushed = YES;
        }
        if (viewController.navigationItem.leftBarButtonItems.count > 0 || viewController.navigationItem.leftBarButtonItem) {
            
        }else{
            if ([viewController respondsToSelector:@selector(customLeftBarItems)]) {
                NSArray *customLeftBarItems = [viewController customLeftBarItems];
                if (!customLeftBarItems || customLeftBarItems.count == 0) {
                    viewController.navigationItem.leftBarButtonItems = nil;
                    viewController.navigationItem.leftBarButtonItem = nil;
                    viewController.navigationItem.title = @"";
                    viewController.navigationItem.hidesBackButton = YES;
                }else{
                    viewController.navigationItem.leftBarButtonItems = [viewController customLeftBarItems];
                }
            }
            else if ([viewController respondsToSelector:@selector(CJ_setLeftBackBarItem)]) {
                [viewController CJ_setLeftBackBarItem];
            }
        }
    }
    //处理左滑手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if(!animated){
        if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
            [self.delegate navigationController:self didShowViewController:viewController animated:animated];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (void)backPopViewcontroller:(id)sender {
    if(self.navigationController.topViewController == self &&
       self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //tab上面的vc禁用右滑返回
        if (navigationController.viewControllers.count > 0 && viewController == navigationController.viewControllers[0]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else {
            if (viewController.disablePopGesture) {
                self.interactivePopGestureRecognizer.enabled = NO;
            }else{
                self.interactivePopGestureRecognizer.enabled = YES;
            }
        }
    }
    
    if (isIPhoneX) {
        // 修改tabBra的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

#pragma mark - gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.navigationController.interactivePopGestureRecognizer == gestureRecognizer) {
        if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
            if ((scrollView.contentSize.width > CGRectGetWidth(self.view.bounds) && scrollView.contentOffset.x == 0)) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
