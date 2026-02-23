//
//  CJScrollPageHeadView.m
//
//  Created by lele8446 on 2019/10/22.
//

#import "CJScrollPageHeadView.h"
#import <Masonry.h>
#import "CJKitConfig.h"

@interface CJScrollPageHeadView ()
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray <NSString *>*titleDatas;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttons;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end


@implementation CJScrollPageHeadView
- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}

- (UIFont *)selectFont {
    if (!_selectFont) {
        _selectFont = [UIFont boldSystemFontOfSize:16];
    }
    return _selectFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = frame.size.width;
        self.height = frame.size.height;
        [self setupUI];
        [self setSkinCoolor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSkinCoolor {
    self.selectColor = CJColorMain;
    self.titleColor = CJColorSubtitle_66;
    for (UIButton *button in self.buttons) {
        if (button.tag == self.selectedIndex) {
            [button setTitleColor:self.selectColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
    }
    self.indicatorView.backgroundColor = self.selectColor;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.lineView];
    [self.scrollView addSubview:self.indicatorView];
    [self addSubview:self.scrollView];
}

- (void)reloadData:(NSArray <NSString *>*)data {
    [self reloadData:data toIndex:0];
}

- (void)reloadData:(NSArray <NSString *>*)data toIndex:(NSInteger)index {
    self.titleDatas = data;
    for (UIButton * button in self.buttons) {
        [button removeFromSuperview];
    }
    self.buttons = nil;
    [self addButtonsToIndex:index];
}

- (void)addButtonsToIndex:(NSInteger)index {
    self.buttons = @[].mutableCopy;
    NSArray *models = self.titleDatas;
    CGFloat origeX  = 15;
    CGFloat maxBtnWidth = 0;
    for (int i = 0; i < models.count; i++) {
        NSString *title = models[i];
        UIButton *button = [[UIButton alloc] init];
        if (i == index) {
            button.titleLabel.font = self.selectFont;
            [button setTitleColor:self.selectColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            button.titleLabel.font = self.titleFont;
        }
        [button setTitle:title forState:UIControlStateNormal];
        CGSize size = [button sizeThatFits:CGSizeMake(1000, self.height)];
        CGFloat btnWidth = size.width+10;
        button.frame = CGRectMake(origeX, 0, btnWidth, self.height);
        maxBtnWidth = maxBtnWidth<btnWidth?btnWidth:maxBtnWidth;
        origeX = origeX + button.frame.size.width + 15;
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
    }
    
    UIButton *lastBtn = [self.buttons lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame)+15, 0);
    
    if (!self.leftAlign) {
        //如果按钮不需要滑动
        if (CGRectGetMaxX(lastBtn.frame) <= CJWindowWidth) {
            CGFloat btnWidth = CJWindowWidth/models.count;
            btnWidth = maxBtnWidth<btnWidth?btnWidth:maxBtnWidth;
            origeX  = 0;
            for (int i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(origeX, 0, btnWidth, self.height);
                origeX = origeX + btnWidth;
            }
            lastBtn = [self.buttons lastObject];
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame), 0);
        }
    }
    
    
    self.selectedIndex = index;
    [self scrollToIndex:self.selectedIndex refresh:YES];
    
    UIButton *current = self.buttons[_selectedIndex];
    current.titleLabel.font = self.selectFont;
    [current setTitleColor:self.selectColor forState:UIControlStateNormal];
    CGPoint center = self.indicatorView.center;
    center.x = current.center.x;
    self.indicatorView.center = center;
}

- (void)buttonPressed:(UIButton *)sender {
    NSInteger tag = sender.tag;
    //    NSLog(@"tag = %@",@(tag));
    [self scrollToIndex:tag];
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

- (void)scrollToIndex:(NSInteger)index {
    [self scrollToIndex:index refresh:NO];
}

- (void)scrollToIndex:(NSInteger)index refresh:(BOOL)refresh {
    if (!refresh) {
        if (index == self.selectedIndex) {
            return;
        }
    }
    
    UIButton *previous = self.buttons[_selectedIndex];
    previous.titleLabel.font = self.titleFont;
    [previous setTitleColor:self.titleColor forState:UIControlStateNormal];
    
    _selectedIndex = index;
    self.indicatorView.hidden = NO;
    UIButton *current = self.buttons[_selectedIndex];
    current.titleLabel.font = self.selectFont;
    [current setTitleColor:self.selectColor forState:UIControlStateNormal];
    
    CGPoint center = self.indicatorView.center;
    center.x = current.center.x;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.center = center;
    }];
    BOOL overstep = self.scrollView.contentSize.width > self.scrollView.frame.size.width;
    CGFloat offset = current.center.x -  UIScreen.mainScreen.bounds.size.width / 2;
    if (offset > 0 && offset < self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:true];
    } else if (offset < 0 || !overstep) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    } else {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0) animated:true];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollView.showsHorizontalScrollIndicator = false;
    }
    return _scrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.75, self.width, 0.75)];
        _lineView.backgroundColor = CJColorSeparator_E8;
    }
    return _lineView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(8, self.height - 2.5, 35, 2.5)];
        _indicatorView.hidden = YES;
    }
    _indicatorView.backgroundColor = self.selectColor;
    return _indicatorView;
}
@end
