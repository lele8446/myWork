//
//  CJColumnView.h
//
//
//  Created by ChiJinLian on 15/7/24.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSString * kHiddenOptionBtn;       /*<-- 设置可选按钮是否隐藏 (不传默认隐藏)   */
extern const NSString * kFirstOffset;           /*<-- 第一个栏目起始位置 (不传默认0)  */
extern const NSString * kSpace;                 /*<-- 标题栏目间隔 (不传默认0)   */
extern const NSString * kTitleFontSize;         /*<-- 标题大小   */
extern const NSString * kTitleSelectedFontSize; /*<-- 标题选中大小   */
extern const NSString * kTitleColor;            /*<-- 标题颜色   */
extern const NSString * kTitleSelectedColor;    /*<-- 标题选中颜色   */
extern const NSString * kDivlineColor;          /*<-- 底部横线颜色   */
extern const NSString * kSelectLineColor;       /*<-- 选中标题底部横线颜色   */
extern const NSString * kSelectLineHeight;      /*<-- 选中标题底部横线高度 (不传默认2)  */
extern const NSString * kHorDivlineColor;       /*<-- 可选按钮分割线颜色   */
extern const NSString * kHiddenLine;            /*<-- 是否显示标题分割线（不传默认隐藏）   */
extern const NSString * kHiddenDivLine;         /*<-- 是否显示底部横线（不传默认显示）   */
extern const NSString * kHiddenSelcetLine;      /*<-- 是否显示选定底部横线（不传默认显示）   */
extern const NSString * kBackColor;             /*<-- 背景颜色   */

/* 栏目切换时，选中回调实用类,做相应界面切换操作* */
typedef UIView *(^PCColumnSelectedBlock)(NSUInteger selectIdx);
/* 点击可选按钮时，回调相应界面处理操作* */
typedef void (^PCColumnCustomBtnBlock)();

/* 栏目切换时，选中回调实用类,做相应界面切换操作
 *
 */
@interface CJColumnView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIView*       divline;//底部横线
@property (nonatomic, strong) IBOutlet UIView*       selectedView;//选择横条

@property (nonatomic,readonly) NSUInteger currentIndex;
@property (nonatomic,strong)   NSArray*   columnTitles;
@property (nonatomic,copy)     PCColumnSelectedBlock  doSelectBlock;
@property (nonatomic,copy)     PCColumnCustomBtnBlock customBlock;

/**
 *  初始化设置frame以及选中标题字体颜色、大小
 *
 *  @param frame 
 *  @param columnTitles @[标题数组]
 *  @param info  文字样式
 //样式示例
 //NSDictionary *info   = @{kTitleFontSize:@16,                    标题大小
 //                         kTitleSelectedFontSize:@17,            标题选中大小
 //                         kTitleColor:[UIColor blackColor],      标题颜色
 //                         kTitleSelectedColor:[UIColor redColor],标题选中颜色
 //                         kDivlineColor:[UIColor blackColor],    底部横线颜色
 //                         kHorDivlineColor:[UIColor blueColor],  可选按钮分割线颜色
 //                         kHiddenLine:@(YES),                    是否显示标题分割线（不传默认否）
 //                         kHiddenDivLine:@(NO),                  是否显示底部横线（不传默认显示）
 //                         kHiddenSelcetLine:@(NO),               是否选定底部横线（不传默认显示）
 //                         kBackColor:[UIColor blackColor]        背景颜色
 //                        }
 */
- (instancetype)initWithFrame:(CGRect)frame columnTitles:(NSArray *)columnTitles columnInfo:(NSDictionary *)info;


/*  简介：栏目按钮切换操作
 *  作用：类内部调用，不外放函数接口
 *  参数：
    ifCallBack:-- 用来判断是否需要通知回调,
               -- YES：
               -- NO ：使用场景：pagescroll滚动到了指定的page后，不用回调 */
-(void)selectAtIndex:(NSUInteger)index ifcallback:(BOOL)ifcallBack;
@end
