//
//  UIImage+CJKit.h
//  CJImageEditor
//
//  Created by lele8446 on 2021/12/9.
//

#import <UIKit/UIKit.h>


@interface UIImage (CJKit)

/**
 * 根据color生成1x1的纯色图片
 * @param color 颜色
 */
+ (UIImage *)cj_imageWithColor:(UIColor *)color;

/**
 * 根据color生成指定Size的纯色图片
 * @param color 颜色
 * @param size 所需图片Size
 */
+ (UIImage *)cj_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 修改图片颜色*/
- (UIImage *)cj_imageWithColor:(UIColor *)color;

- (UIImage *)cj_imageByResizeToSize:(CGSize)size;
@end
