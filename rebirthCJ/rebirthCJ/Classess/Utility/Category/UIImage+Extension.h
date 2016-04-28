//
//  UIImage+Extension.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/28.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  生成纯色图片
 *
 *  @param color
 *  @param width
 *  @param height
 *
 *  @return 
 */
+ (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;
@end
