//
//  CJScrollPageHeadView.h
//
//  Created by lele8446 on 2019/10/22.
//

#import <UIKit/UIKit.h>


/**
 ChildViewController页面支持左右滑动的时候，顶部的菜单页面
 */
@interface CJScrollPageHeadView : UIView
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy)  void(^clickBlock)(NSInteger index);
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *selectFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, assign) BOOL leftAlign;

- (void)reloadData:(NSArray <NSString *>*)data;
- (void)reloadData:(NSArray <NSString *>*)data toIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index;
@end
