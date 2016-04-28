//
//  UIBarButtonItem+Extension.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/28.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  自定义barButtonItem
 *
 *  @param imageName            StateNormal image
 *  @param highLightedImageName highLighted image
 *  @param target
 *  @param selector
 *
 *  @return 
 */
+ (instancetype)itemWithImage:(NSString *)imageName
            hightLightedImage:(NSString *)highLightedImageName
                       target:(id)target
                     selector:(SEL)selector;
@end
