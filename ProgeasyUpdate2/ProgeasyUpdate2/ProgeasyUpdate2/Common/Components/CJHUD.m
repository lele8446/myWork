//
//  Created by lele8446 on 2024/4/17.
//

#import "CJHUD.h"
#import "CJKitConfig.h"
#import <Masonry/Masonry.h>

static MBProgressHUD *showHUD;

@implementation CJHUD

#pragma mark -
#pragma mark - Prompt Box
/** toast纯文字形式Hint框 (默认1.0秒展示时间)*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title {
    return [CJHUD CJ_showMessage:title toView:nil];
}

/** toast纯文字形式Hint框 (默认1.0秒展示时间) 指定View*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)message
                  toView:(UIView *)view {
    NSString *title = [self CJ_getTitleWithMessage:message];
    NSTimeInterval afterDelay = 1;
    NSInteger num = title.length-8;
    if (num > 0) {
        afterDelay = afterDelay + num*0.15;
    }
    return [CJHUD CJ_showMessage:title toView:view afterDelay:afterDelay];
}

+ (NSString *)CJ_getTitleWithMessage:(NSString *)message {
    if (message.length) {
//        if (message.length>20) {
//            message = [message substringToIndex:20];
//        }
        NSString *title = message;
        return title;
    } else {
        return message;
    }
}

+ (MBProgressHUD *) CJ_showMessage:(NSString *)message
                  toView:(UIView *)view
              afterDelay:(NSTimeInterval)afterDelay {
    
    NSString *title = [self CJ_getTitleWithMessage:message];
    
    if(title && title.length>0) {
        UIView *showView = view?:[UIApplication sharedApplication].keyWindow;
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        textHud.bezelView.layer.cornerRadius = 6;
        textHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        textHud.bezelView.color = [CJColorTitle_33 colorWithAlphaComponent:0.85];
//        textHud.userInteractionEnabled = NO;
        
        textHud.mode = MBProgressHUDModeText;
//        textHud.mode = MBProgressHUDModeCustomView;
        textHud.detailsLabel.font = [UIFont systemFontOfSize:16];
        textHud.detailsLabel.textColor = [UIColor whiteColor];
        textHud.detailsLabel.text = title;
        // 隐藏时候从父控件中移除
        textHud.removeFromSuperViewOnHide = YES;
        //展示1.0秒后隐藏
        [textHud hideAnimated:YES afterDelay:afterDelay];
        return textHud;
    }
    return nil;
}

/** toast复合型Hint框 (图片默认居中，默认1.0秒展示时间)*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title
                              image:(UIImage *)image {
    return [CJHUD CJ_showMessage:title image:image toView:nil];
}

/** toast复合型Hint框 (图片默认居中，默认1.0秒展示时间)*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)message
                              image:(UIImage *)image
                             toView:(UIView *)view {
    NSString *title = [self CJ_getTitleWithMessage:message];
    if(image) {
        UIView *showView = view?:[UIApplication sharedApplication].keyWindow;
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
//        textHud.userInteractionEnabled = NO;
        textHud.margin = 22;
        textHud.minSize = CGSizeMake(118, 118);
        // 设置图片
        textHud.mode = MBProgressHUDModeCustomView;
        textHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        textHud.bezelView.color = [CJColorTitle_33 colorWithAlphaComponent:0.85];
        UIView *customView = [[UIView alloc] init];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        [customView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(customView);
            make.width.height.mas_equalTo(36);
            make.top.mas_equalTo(6);
        }];
        
        textHud.customView = customView;
        //设置文本
        textHud.detailsLabel.font = [UIFont systemFontOfSize:16];
        textHud.detailsLabel.textColor = [UIColor whiteColor];;
        textHud.detailsLabel.text = title;
        textHud.detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        // 隐藏时候从父控件中移除
        textHud.removeFromSuperViewOnHide = YES;
        //默认展示1.0秒后隐藏
        NSTimeInterval afterDelay = 1;
        NSInteger num = title.length-8;
        if (num > 0) {
            afterDelay = afterDelay + num*0.15;
        }
        [textHud hideAnimated:YES afterDelay:afterDelay];
        return textHud;
        
    }else {
        return [CJHUD CJ_showMessage:title];
    }
    
}

/** 展示成功的Message，带图标*/
+ (MBProgressHUD *)CJ_showSuccessMessage:(NSString *)success {
    UIImage *image = [UIImage imageNamed:@"toast_ic_successful_center"];
    return [CJHUD CJ_showMessage:success image:image];
}

/** 展示成功的Message，带图标，指定View*/
+ (MBProgressHUD *)CJ_showSuccessMessage:(NSString *)success
                      toView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"toast_ic_successful_center"];
    return [CJHUD CJ_showMessage:success image:image toView:view];
}

/** 展示失败的Message，带图标*/
+ (MBProgressHUD *)CJ_showErrorMessage:(NSString *)error {
    UIImage *image = [UIImage imageNamed:@"toast_ic_error_center"];
    return [CJHUD CJ_showMessage:error image:image];
}

/** 展示失败的Message，带图标，指定View*/
+ (MBProgressHUD *)CJ_showErrorMessage:(NSString *)error
                    toView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:@"toast_ic_error_center"];
    return [CJHUD CJ_showMessage:error image:image toView:view];
}

/** 展示Loading hud (默认在window居中展示)*/
+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title {
    return [CJHUD CJ_showLoadMessage:title interaction:YES];
}

/** 展示Loading hud (默认在window居中展示)*/
+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title
                           interaction:(BOOL)interaction {
    UIView *showView = [UIApplication sharedApplication].keyWindow;
    return [CJHUD CJ_showLoadMessage:title toView:showView interaction:interaction];
}

/** 展示Loading hud (view为nil时默认在window居中展示)*/
+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title
                                toView:(UIView *)view
                           interaction:(BOOL)interaction
{
    
    [CJHUD CJ_hideLoadHUD];
    
    UIView *showView = (view?view:[UIApplication sharedApplication].keyWindow);
    showHUD = [[MBProgressHUD alloc] initWithView:showView];
    showHUD.margin = 15.0f;
    showHUD.userInteractionEnabled = interaction;
    [showView addSubview:showHUD];
    
    /** 展示环形loading动画 */
    [showHUD setMode:MBProgressHUDModeCustomView];
    showHUD.bezelView.color = [CJColorTitle_33 colorWithAlphaComponent:0.74];
    showHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    showHUD.bezelView.layer.cornerRadius = 6;
     
//    CGFloat loadWidth = 46.0f;
    CGFloat loadWidth = (title.length>0)?100:46.0f;
    CGFloat loadHeight = 46.0f;
    
    UIView *loadView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, loadWidth, 46.0f)];
    [loadView setBackgroundColor:[UIColor clearColor]];
    
//    UIImage *loadImage =CJBundleImageNamed(@"CJRemind_loading", @"CJUIKit");
    UIImageView *loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake((loadWidth - 36.0f)/2, 5.0f, 36.0f, 36.0f)];
//    [loadImgView setImage:loadImage];
    
    UIImage *image = [UIImage imageNamed:@"common_pb_loading"];
    loadImgView.image = image;
    loadImgView.frame = CGRectMake(0, 0, 60, 60);
    
    CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = 1.0;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    [loadImgView.layer addAnimation:animation forKey:@"CJHubLoadAnimation"];
    [loadView addSubview:loadImgView];
    loadImgView.center = loadView.center;
    
    [showHUD setCustomView:loadView];
    
    [showHUD.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(loadWidth);
        make.height.mas_equalTo(loadHeight);
        make.center.equalTo(showHUD);
    }];

    
    /* - - - - */
    if(title && title.length > 0) {
        showHUD.detailsLabel.font = [UIFont systemFontOfSize:16];
        showHUD.detailsLabel.textColor = [UIColor whiteColor];
        showHUD.detailsLabel.text = title;
    }
    
    [showHUD showAnimated:YES];
    return showHUD;
}

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)CJ_showProgressHubWithTitle:(NSString *)title {
    
   return [CJHUD CJ_showProgressHubWithTitle:title toView:nil];
}

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)CJ_showProgressHubWithTitle:(NSString *)title toView:(UIView *)view {
    
    [CJHUD CJ_hideLoadHUD];
    UIView *showView = (view?view:[UIApplication sharedApplication].keyWindow);

    showHUD = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    showHUD.mode = MBProgressHUDModeAnnularDeterminate;
    showHUD.label.text = title;
//    showHUD.userInteractionEnabled = NO;

    [showHUD showAnimated:YES];
    return showHUD;
}

/** 显示上传进度的progress*/
+ (void)CJ_showProgress:(float)progress {
    showHUD.progress = progress;
}

/** 直接取消loading hud*/
+ (void) CJ_hideLoadHUD {
    if(showHUD != nil && showHUD.superview != nil) {
        [showHUD hideAnimated:YES];
        [showHUD removeFromSuperview];
        showHUD = nil;
    }
}

/** 取消loading hud 并Toast展示相应的文案*/
+ (void) CJ_hideLoadHUDWithRemindTitle:(NSString *)remindTitle {
    
    [CJHUD CJ_hideLoadHUD];
    
    [CJHUD CJ_showMessage:remindTitle];
    
}

@end
