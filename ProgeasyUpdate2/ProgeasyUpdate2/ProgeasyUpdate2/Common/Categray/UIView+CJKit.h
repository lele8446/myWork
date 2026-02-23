//
//  UIView+CJKit.h
//  CJImageEditor
//
//  Created by lele8446 on 2021/12/9.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (CJKit)
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@property (nonatomic) CGFloat frameCenterX;
@property (nonatomic) CGFloat frameCenterY;

#pragma mark - Line
/**
 *  在View上绘制线条
 *  [color默认18,18,18 | width默认1px]
 *  @param edge 边缘
 */
- (void)CJ_drawLine:(UIRectEdge)edge;
/**
 *  在View上绘制线条
 *  @param edge 边缘
 *  @param width 线条宽度
 *  @param color 线条颜色
 */
- (void)CJ_drawLine:(UIRectEdge)edge
               width:(CGFloat)width
               color:(UIColor *)color;

/**
 * 在指定view上绘制虚线
 * @param lineView       需要绘制成虚线的view
 * @param lineLength     虚线的宽度
 * @param lineSpacing    虚线的间距
 * @param lineColor      虚线的颜色
 **/
+ (void)CJ_drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

#pragma mark - corner
/**
 * 设置四边圆角
 * @param radius 圆角半径
 */
- (void)CJ_setCornerRadius:(CGFloat)radius;
/**
 * 设置视图圆角 (默认圆角8px)
 * @param rectCorner 圆角位置
 */
- (void)CJ_setCornerByRoundingCorners:(UIRectCorner)rectCorner;
/**
 * 设置视图圆角
 * @param rectCorner 圆角位置
 * @param cornerRadii 圆角半径
 */
- (CAShapeLayer *)CJ_setCornerByRoundingCorners:(UIRectCorner)rectCorner
                                    cornerRadii:(CGSize)cornerRadii;

/// UIView转图片
/// @param view view
+ (UIImage *)convertViewToImage:(UIView *)view;
@end

@interface UIView (CJTopView)
@property (nonatomic) CGRect windowFrame;
@end

@interface UITextView (CJ)
@property (nonatomic, assign) CGFloat oldFontSize;
@end

