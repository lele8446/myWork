//
//  CJTool.h
//  CJMetro
//
//  Created by lele8446 on 2024/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 将obj安全转换为NSString

 @param obj obj
 @return NSString
 */
FOUNDATION_EXPORT NSString *CJSafeStr(id obj);
/**
 将obj安全转换为NSString
 
 @param obj obj
 @param defaultValue 默认值
 @return NSString
 */
FOUNDATION_EXPORT NSString *CJSafeStrWithDefault(id obj, NSString *defaultValue);

@interface CJTool : NSObject

@end

@interface NSString (CJ)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end
