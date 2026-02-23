//
//  CJTabBarController.h
//
//

#import <UIKit/UIKit.h>
#import "CJKitConfig.h"

@interface CJTabModel : NSObject
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, assign) BOOL custom;

+ (CJTabModel *)modelWithVC:(UIViewController *)vc
                      title:(NSString *)title
                      image:(UIImage *)image
                selectImage:(UIImage *)selectImage;
@end

@interface CJTabBarController : UITabBarController

- (void)addChildModels:(NSArray <CJTabModel *>*)vcs tintColor:(UIColor *)tintColor;

@end
