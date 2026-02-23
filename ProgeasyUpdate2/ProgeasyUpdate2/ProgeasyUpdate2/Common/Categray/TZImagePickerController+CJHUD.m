//
//  TZImagePickerController+CJHUD.m
//  CJImageEditor
//
//  Created by lele8446 on 2022/2/24.
//

#import "TZImagePickerController+CJHUD.h"
#import "CJKitConfig.h"
#import "UIView+CJKit.h"
#import "CJHUD.h"
#import "NSBundle+DAUtils.h"
#import "NSBundle+TZImagePicker.h"

@implementation TZImagePickerController (CJHUD)
- (void)showProgressHUD {
    [CJHUD CJ_showLoadMessage:nil toView:nil interaction:YES];
}
- (void)hideProgressHUD {
    [CJHUD CJ_hideLoadHUD];
}
- (void)dismiss {
    [TZImagePickerConfig sharedInstance].delegate = nil;
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updateLanguageBundle {
    NSBundle *bundle = [self tz_mainBundle];
    if (bundle) {
        self.languageBundle = bundle;
    }
}

- (NSBundle *)tz_mainBundle {
    NSString *path = [[NSBundle tz_imagePickerBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
    if (path.length) {
        return [NSBundle bundleWithPath:path];
    }
    return nil;
}
@end
