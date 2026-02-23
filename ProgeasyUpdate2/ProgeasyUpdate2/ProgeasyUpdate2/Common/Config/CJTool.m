//
//  CJTool.m
//  CJMetro
//
//  Created by lele8446 on 2024/4/25.
//

#import "CJTool.h"

FOUNDATION_EXPORT NSString *CJSafeStr(id obj) {
    return CJSafeStrWithDefault(obj, @"");
}

FOUNDATION_EXPORT NSString *CJSafeStrWithDefault(id obj, NSString *defaultValue) {
    if (!obj || obj==nil || obj==NULL || (NSNull *)(obj)==[NSNull null] || ([obj isKindOfClass:[NSString class]] && [obj length]==0)) {
        return (defaultValue && defaultValue.length > 0)?defaultValue:@"";
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
}

@implementation CJTool

@end

@implementation NSString (CJ)
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}
@end
