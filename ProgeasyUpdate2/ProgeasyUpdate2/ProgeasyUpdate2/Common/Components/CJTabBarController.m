//
//  CJTabBarController.m
//

#import "CJTabBarController.h"
#import "UIImage+CJKit.h"
#import "CJNavigationController.h"

#define kCJTabCustomButtonTapped @"kCJTabCustomButtonTapped"

@interface CJTabModel ()
@end
@implementation CJTabModel
+ (CJTabModel *)modelWithVC:(UIViewController *)vc
                      title:(NSString *)title
                      image:(UIImage *)image
                selectImage:(UIImage *)selectImage
{
    CJTabModel *model = [[CJTabModel alloc]init];
    model.vc = vc;
    model.title = title;
    model.image = image;
    model.selectImage = selectImage;
    model.custom = NO;
    return model;
}
@end

@interface CustomTabBar : UITabBar
@end
@implementation CustomTabBar
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden) {
        return [super hitTest:point withEvent:event];
    }
    for (UIView *subview in self.subviews) {
        // 把 point 转成子 view 的坐标系
        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
        if (CGRectContainsPoint(subview.bounds, convertedPoint)) {
            UIView *result = [subview hitTest:convertedPoint withEvent:event];
            if (result) {
                return result;
            }
        }
    }

    return [super hitTest:point withEvent:event];
}

@end

@interface SMTabBarItem : UITabBarItem
@property (nonatomic, assign) BOOL loadUnselectImg;
@property (nonatomic, assign) BOOL loadSelectImg;
@property (nonatomic, copy) NSString *selectImgUrl;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, copy) NSString *unselectImgUrl;
@property (nonatomic, strong) UIImageView *unselectImgView;

@property (nonatomic, strong) UILabel *badgeLabel;
@end
@implementation SMTabBarItem
- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
    }
    return _selectImgView;
}
- (UIImageView *)unselectImgView {
    if (!_unselectImgView) {
        _unselectImgView = [UIImageView new];
    }
    return _unselectImgView;
}
- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _badgeLabel.backgroundColor = CJColorFromRGB16(0xFF4D4F,1);
        _badgeLabel.layer.cornerRadius = 10/2.0;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.hidden = YES;
    }
    return _badgeLabel;
}
@end

@interface CJTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate>
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, assign) NSInteger customIndex;
@property (nonatomic, strong) UIColor *tintColor;
@end

@implementation CJTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UITabBar *tabbar = self.tabBar;
    tabbar.layer.shadowOffset = CGSizeMake(0, -3);//默认为0,-3
    tabbar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    tabbar.layer.shadowOpacity = 0.15;//阴影透明度，默认0
    tabbar.layer.masksToBounds = NO;
    tabbar.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:tabbar.bounds cornerRadius:0].CGPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //从后台返回通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    UITabBar *tabbar = [[CustomTabBar alloc] init];
//    tabbar.tintColor = [UIColor redColor];
    tabbar.barTintColor = [UIColor whiteColor];
    tabbar.delegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
    //去除顶部横线
    self.tabBar.shadowImage = [UIImage cj_imageWithColor:[UIColor clearColor]];
    self.tabBar.backgroundImage = [UIImage cj_imageWithColor:[UIColor whiteColor]];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *apperance = [UITabBarAppearance new];
        apperance.backgroundImage = [UIImage cj_imageWithColor:[UIColor whiteColor]];
        apperance.backgroundColor = UIColor.whiteColor;
        apperance.shadowColor = UIColor.whiteColor;
        apperance.shadowImage = [UIImage cj_imageWithColor:[UIColor clearColor]];
        self.tabBar.standardAppearance = apperance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = apperance;
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }

    self.delegate = self;
    self.tabBar.translucent = NO;
    
    self.customIndex = -1;
    CGFloat width = 75;
    CGFloat btnWidth = (width-10);
    self.customView = [[UIView alloc]init];
    self.customView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) / 2, -width/3-5, width, width);
    self.customView.layer.cornerRadius = width/2;
    self.customView.backgroundColor = [UIColor whiteColor];
    self.customView.userInteractionEnabled = YES;
//    self.customView.layer.borderWidth = 0.0;
    self.customView.layer.shadowColor = CJColorSubtitle_66.CGColor;
    self.customView.layer.shadowOffset = CGSizeMake(0, 4);
    self.customView.layer.shadowOpacity = 0.25;
    self.customView.layer.shadowRadius = 8;
    
    self.customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customButton.frame = CGRectMake((width - btnWidth) / 2, (width - btnWidth) / 2, btnWidth, btnWidth);
    self.customButton.layer.cornerRadius = btnWidth/2;
    [self.customButton addTarget:self action:@selector(customButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:self.customButton];

    [self.tabBar addSubview:self.customView];
    [self.tabBar bringSubviewToFront:self.customView];
    self.customView.hidden = YES;
}

- (void)customButtonTapped {
    self.selectedIndex = self.customIndex;
    [self selectCuctomIndex:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kCJTabCustomButtonTapped object:nil];
    });
    
    self.customButton.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.35 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:2/7.0 animations:^{
            self.customButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/7.0 relativeDuration:3/7.0 animations:^{
            self.customButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:5/7.0 relativeDuration:2/7.0 animations:^{
            self.customButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (NSString *)tabControllerTitle:(UIViewController *)ctr {
    NSString *title = ctr.title;
    if (title.length == 0) {
        title = ctr.tabBarItem.title;
    }
    if (title.length == 0) {
        title = ctr.navigationItem.title;
    }
    if (title.length == 0) {
        title = @"";
    }
    return title;
}

- (void)addChildModels:(NSArray <CJTabModel *>*)vcs tintColor:(UIColor *)tintColor {
    self.tintColor = tintColor;
    NSMutableArray *childViewControllers = [NSMutableArray array];
    
    NSInteger count = vcs.count;
    for (NSInteger i = 0; i < count; i ++) {
        CJTabModel *model = vcs[i];
        CJNavigationController *nav = [self addOneChildViewController:model.vc title:model.title image:model.image selectImage:model.selectImage tintColor:tintColor custom:model.custom index:i];
        [childViewControllers addObject:nav];
    }
    [self setViewControllers:childViewControllers animated:YES];
}

- (CJNavigationController *)addOneChildViewController:(UIViewController *)vc
                                                title:(NSString *)title
                                                image:(UIImage *)image
                                          selectImage:(UIImage *)selectImage
                                            tintColor:(UIColor *)tintColor
                                               custom:(BOOL)custom
                                                index:(NSInteger)index
{
    CJNavigationController *nav = [[CJNavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title = title;
    nav.tabBarItem = [[SMTabBarItem alloc]initWithTitle:title image:nil selectedImage:nil];
    [(SMTabBarItem *)nav.tabBarItem setLoadSelectImg:NO];
    [(SMTabBarItem *)nav.tabBarItem setLoadUnselectImg:NO];
    nav.tabBarItem.enabled = !custom;
    if(!custom){
        nav.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        self.customIndex = index;
        self.customView.hidden = NO;
        nav.tabBarItem.title = @"";
        UIImage *img = [image cj_imageWithColor:CJColorSubtitle_66];
        [self.customButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.customButton setImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [self selectCuctomIndex:YES];
    }
    
    [self setupTabBarItemSkin:nav.tabBarItem tintColor:tintColor];
    return nav;
}

- (void)setupTabBarItemSkin:(UITabBarItem *)tabBarItem tintColor:(UIColor *)tintColor {

        NSDictionary *selTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:11.0f],
                                            NSForegroundColorAttributeName : tintColor
                                            };
        NSDictionary *norTextAttributes = @{
                                            NSFontAttributeName : [UIFont systemFontOfSize:11.0f],
                                            NSForegroundColorAttributeName : UIColor.blackColor
                                            };
        
        [tabBarItem setTitleTextAttributes:norTextAttributes forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:selTextAttributes forState:UIControlStateSelected];
        if (@available(iOS 13.0, *)) {
            UITabBar.appearance.unselectedItemTintColor = UIColor.blackColor;
            UITabBar.appearance.tintColor = tintColor;
        }
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self selectCuctomIndex:NO];
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            __block UIImageView *imgView = nil;
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj2 isKindOfClass:UIImageView.class]) {
                    imgView = obj2;
                    *stop = YES;
                }
            }];
            if (imgView.image == item.selectedImage) {
                imgView.transform = CGAffineTransformIdentity;
                [UIView animateKeyframesWithDuration:0.35 delay:0 options:0 animations:^{
                    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:2/7.0 animations:^{
                        imgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    }];
                    [UIView addKeyframeWithRelativeStartTime:2/7.0 relativeDuration:3/7.0 animations:^{
                        imgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    }];
                    [UIView addKeyframeWithRelativeStartTime:5/7.0 relativeDuration:2/7.0 animations:^{
                        imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                } completion:nil];
            }
        }
    }];
}

- (void)showSMTabBarItemBadge:(NSString *)itemTitle {
    __weak typeof(SMTabBarItem *)wTabBarItem = nil;
    for (SMTabBarItem *item in self.tabBar.items) {
        if ([item.title isEqualToString:itemTitle]) {
            wTabBarItem = item;
            break;
        }
    }
    
    if ([wTabBarItem isKindOfClass:[SMTabBarItem class]]) {
        [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                __block UIImageView *imgView = nil;
                [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj2 isKindOfClass:UIImageView.class]) {
                        imgView = obj2;
                        *stop = YES;
                    }
                }];
                if (imgView.image == wTabBarItem.selectedImage || imgView.image == wTabBarItem.image) {
                    [imgView addSubview:wTabBarItem.badgeLabel];
                    wTabBarItem.badgeLabel.hidden = NO;
                    CGFloat x = imgView.frame.size.width;
                    wTabBarItem.badgeLabel.frame = CGRectMake(x-6, -4, 10, 10);
                }
            }
        }];
    }
}
- (void)hiddenSMTabBarItemBadge:(NSString *)itemTitle {
    __weak typeof(SMTabBarItem *)wTabBarItem = nil;
    for (SMTabBarItem *item in self.tabBar.items) {
        if ([item.title isEqualToString:itemTitle]) {
            wTabBarItem = item;
            break;
        }
    }
    if ([wTabBarItem isKindOfClass:[SMTabBarItem class]]) {
        wTabBarItem.badgeLabel.hidden = YES;
        [wTabBarItem.badgeLabel removeFromSuperview];
    }
}

- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)selectCuctomIndex:(BOOL)select {
    if (!select) {
        self.customButton.selected = NO;
//        self.customView.layer.borderColor = CJColorSeparator_E8.CGColor;
        self.customView.layer.shadowColor = CJColorSubtitle_66.CGColor;
    }else{
        self.customButton.selected = YES;
//        self.customView.layer.borderColor = [self.tintColor colorWithAlphaComponent:0.25].CGColor;
        self.customView.layer.shadowColor = self.tintColor.CGColor;
    }
}
@end
