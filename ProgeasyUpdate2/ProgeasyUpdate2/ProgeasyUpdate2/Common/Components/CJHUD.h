//
//  Created by lele8446 on 2024/4/17.
//

#import "MBProgressHUD.h"


@interface CJHUD : MBProgressHUD

#pragma mark -
#pragma mark - Prompt Box
/** toast纯文字形式Hint框 (默认1.0秒展示时间，超过8个字的Hint语，每多一个字增加0.06s的展示时间)*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title;

/** toast纯文字形式Hint框 (默认1.0秒展示时间，超过8个字的Hint语，每多一个字增加0.06s的展示时间) 指定View*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title
                  toView:(UIView *)view;

/** toast纯文字形式Hint框 (自定义展示时间) 指定View*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title
                  toView:(UIView *)view
              afterDelay:(NSTimeInterval)afterDelay;

/** toast复合型Hint框 (图片默认居中，默认1.0秒展示时间，超过8个字的Hint语，每多一个字增加0.06s的展示时间)*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title
                              image:(UIImage *)image;

/** toast复合型Hint框 (图片默认居中，默认1.0秒展示时间，超过8个字的Hint语，每多一个字增加0.06s的展示时间)，指定View*/
+ (MBProgressHUD *) CJ_showMessage:(NSString *)title
                              image:(UIImage *)image
                             toView:(UIView *)view;

/** 展示成功的Message，带图标*/
+ (MBProgressHUD *)CJ_showSuccessMessage:(NSString *)success;

/** 展示成功的Message，带图标，指定View*/
+ (MBProgressHUD *)CJ_showSuccessMessage:(NSString *)success
                      toView:(UIView *)view;

/** 展示失败的Message，带图标*/
+ (MBProgressHUD *)CJ_showErrorMessage:(NSString *)error;

/** 展示失败的Message，带图标，指定View*/
+ (MBProgressHUD *)CJ_showErrorMessage:(NSString *)error
                    toView:(UIView *)view;

+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title;
/** 展示Loading hud (默认在window居中展示)*/
+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title
                           interaction:(BOOL)interaction;

/** 展示Loading hud (view为nil时默认在window居中展示)*/
+ (MBProgressHUD *) CJ_showLoadMessage:(NSString *)title
                                toView:(UIView *)view
                           interaction:(BOOL)interaction;

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)CJ_showProgressHubWithTitle:(NSString *)title;

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)CJ_showProgressHubWithTitle:(NSString *)title toView:(UIView *)view;

/** 显示上传进度的progress*/
+ (void)CJ_showProgress:(float)progress;

/** 直接取消loading hud*/
+ (void) CJ_hideLoadHUD;

/** 取消loading hud 并Toast展示相应的文案*/
+ (void) CJ_hideLoadHUDWithRemindTitle:(NSString *)remindTitle;

@end

