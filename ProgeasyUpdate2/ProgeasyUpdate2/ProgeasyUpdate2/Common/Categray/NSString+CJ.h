//
//  NSString+CJ.h
//  CJTranslate
//
//  Created by lele8446 on 2024/8/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CJ)
- (CGSize)sizeForFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end

NS_ASSUME_NONNULL_END
