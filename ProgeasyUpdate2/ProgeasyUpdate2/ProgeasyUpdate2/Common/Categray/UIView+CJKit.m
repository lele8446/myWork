//
//  UIView+CJKit.m
//  CJImageEditor
//
//  Created by lele8446 on 2021/12/9.
//

#import "UIView+CJKit.h"

@implementation UIView (CJKit)
- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}

- (CGFloat)frameCenterX {
    return self.center.x;
}

- (void)setFrameCenterX:(CGFloat)frameCenterX {
    CGPoint center = self.center;
    center.x = frameCenterX;
    self.center = center;
}

- (CGFloat)frameCenterY {
    return self.center.y;
}

- (void)setFrameCenterY:(CGFloat)frameCenterY {
    CGPoint center = self.center;
    center.y = frameCenterY;
    self.center = center;
}

#pragma mark - Line
/**
 *  在View上绘制线条
 *  [color默认18,18,18 | width默认1px]
 *  @param edge 边缘
 */
- (void)CJ_drawLine:(UIRectEdge)edge {
    [self CJ_drawLine:edge width:1.0 color:[UIColor colorWithRed:18.0f/255.0 green:18.0f/255.0 blue:18.0f/255.0 alpha:1.0f]];
}
/**
 *  在View上绘制线条
 *  @param edge 边缘
 *  @param width 线条宽度
 *  @param color 线条颜色
 */
- (void)CJ_drawLine:(UIRectEdge)edge
               width:(CGFloat)width
               color:(UIColor *)color {
    NSMutableArray *rectList = [NSMutableArray array];
    if(edge & UIRectEdgeTop) {//包含头部
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, self.frameWidth, width)]];
    }
    if(edge & UIRectEdgeBottom) {//包含底部
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, self.frameHeight - width, self.frameWidth, width)]];
    }
    if(edge & UIRectEdgeLeft) {//包含左
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, width,self.frameHeight)]];
    }
    if(edge & UIRectEdgeRight) {//包含右
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(self.frameWidth-width, 0.0f, width,self.frameHeight)]];
    }
    
    //绘制
    for (NSValue *rectValue in rectList) {
        CGRect rect = [rectValue CGRectValue];
        CALayer *layer = [CALayer layer];
        layer.frame = rect;
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)CJ_drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark - corner
/**
 * 设置四边圆角
 * @param radius 圆角半径
 */
- (void)CJ_setCornerRadius:(CGFloat)radius {
    [self.layer setCornerRadius:radius];
}

/**
 * 设置视图圆角 (默认圆角8px)
 * @param rectCorner 圆角位置
 */
- (void)CJ_setCornerByRoundingCorners:(UIRectCorner)rectCorner {
    [self CJ_setCornerByRoundingCorners:rectCorner cornerRadii:CGSizeMake(8.0f, 8.0f)];
}

/**
 * 设置视图圆角
 * @param rectCorner 圆角位置
 * @param cornerRadii 圆角半径
 */
- (CAShapeLayer *)CJ_setCornerByRoundingCorners:(UIRectCorner)rectCorner
                                    cornerRadii:(CGSize)cornerRadii {
    //指定某个角变为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    return maskLayer;
}

+ (UIImage *)convertViewToImage:(UIView *)view {
    @autoreleasepool {
        UIImage *imageRet = nil;
        //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    //    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
        CGSize size = CGSizeMake(view.frame.size.width, view.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, 1);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        imageRet = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    //    NSData *data = UIImageJPEGRepresentation(togetherImage, scale);
//        NSData *data = UIImagePNGRepresentation(imageRet);
//        imageRet = [UIImage imageWithData:data];
        return imageRet;
    }
}
@end

@implementation UIView (CJTopView)
static char CJwindowFrameKey;

- (void)setWindowFrame:(CGRect)windowFrame {
    NSValue *value = [NSValue valueWithCGRect:windowFrame];
    objc_setAssociatedObject(self, &CJwindowFrameKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGRect)windowFrame {
    NSValue *value = objc_getAssociatedObject(self, &CJwindowFrameKey);
    return [value CGRectValue];
}

@end


@implementation UITextView (CJ)
static char UITextViewOldFontSizeKey;

- (void)setOldFontSize:(CGFloat)oldFontSize {
    NSNumber *num = [NSNumber numberWithFloat:oldFontSize];
    objc_setAssociatedObject(self, &CJwindowFrameKey, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)oldFontSize {
    NSNumber *num = objc_getAssociatedObject(self, &CJwindowFrameKey);
    return [num floatValue];
}
@end
