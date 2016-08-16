//
//  CJColumnView.m
//
//
//  Created by ChiJinLian on 15/7/24.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "CJColumnView.h"

const NSString * kHiddenOptionBtn        = @"hiddenOptionBtn";
const NSString * kSpace                  = @"space";
const NSString * kFirstOffset            = @"firstOffset";
const NSString * kTitleFontSize          = @"titleFontSize";
const NSString * kTitleSelectedFontSize  = @"titleSelectedFontSize";
const NSString * kTitleColor             = @"titleColor";
const NSString * kTitleSelectedColor     = @"titleSelectedColor";
const NSString * kDivlineColor           = @"divlineColor";
const NSString * kSelectLineColor        = @"selectLineColor";
const NSString * kHorDivlineColor        = @"horDivlineColor";
const NSString * kHiddenLine             = @"hiddenLine";
const NSString * kHiddenDivLine          = @"hiddenDivLine";
const NSString * kSelectLineHeight       = @"selectLineHeight";
const NSString * kHiddenSelcetLine       = @"hiddenSelcetLine";
const NSString * kBackColor              = @"backColor";

@interface CJColumnView ()
{
    // 样式
    CGFloat titleFontSize;
    CGFloat titleSelectedFontSize;
    UIColor *backColor;
    UIColor *titleColor;
    UIColor *titleSelectedColor;
    UIColor *divlineColor;
    UIColor *selectLineColor;
    CGFloat selectLineHeight;
    UIColor *horDivlineColor;
    BOOL hiddenLine;//是否显示标题分割线（不传默认否）
    BOOL hiddenDivLine;//是否显示底部横线（不传默认显示）
    BOOL hiddenSelcetLine;//是否显示选定横线（不传默认显示）
    CGAffineTransform transform;
    
}

@property (nonatomic, strong) NSMutableArray *btnTabList;
@property (nonatomic, assign) BOOL hiddenOptionBtn;

@property (nonatomic) CGFloat firstOffset; // 第一个栏目起始位置
@property (nonatomic) CGFloat space;  // 栏目间隔

/* 某些column 栏目右边有option 选项按钮*/
@property (nonatomic, strong) IBOutlet UIButton *optionBtn;
@property (nonatomic, strong) IBOutlet UIView *horizongtalDivline;

@end

@implementation CJColumnView

- (instancetype)initWithFrame:(CGRect)frame columnTitles:(NSArray *)columnTitles columnInfo:(NSDictionary *)info {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil][0];
    if (self) {
        self.frame = frame;
        
        backColor = info[kBackColor] ? info[kBackColor] : [UIColor whiteColor];
        self.backgroundColor = backColor;
        
        self.hiddenOptionBtn = info[kHiddenOptionBtn] ? [info[kHiddenOptionBtn] boolValue]:YES;
        self.optionBtn.hidden = self.hiddenOptionBtn;
        self.optionBtn.frame = CGRectMake(frame.size.width - CGRectGetHeight(self.frame), 0,  CGRectGetHeight(self.frame),  CGRectGetHeight(self.frame));
        self.optionBtn.backgroundColor    = [UIColor clearColor];
        [self.optionBtn setTitle:@"＋" forState:UIControlStateNormal];
        [self.optionBtn setTitle:@"＋" forState:UIControlStateHighlighted];
        [self.optionBtn addTarget:self action:@selector(onCustomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width - (self.hiddenOptionBtn?0:CGRectGetWidth(self.optionBtn.frame)), CGRectGetHeight(self.frame));
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = YES;
        
        divlineColor = info[kDivlineColor] ? info[kDivlineColor] : [UIColor blackColor];
        hiddenDivLine = info[kHiddenDivLine] ? [info[kHiddenDivLine] boolValue]:NO;
        self.divline.backgroundColor = divlineColor;
        self.divline.hidden = hiddenDivLine;
        
        CGRect trc1 = self.horizongtalDivline.frame;
        trc1.origin.x    = self.frame.size.width - CGRectGetWidth(self.optionBtn.frame)-0.5;
        trc1.size.height = CGRectGetHeight(self.frame);
        self.horizongtalDivline.frame = trc1;
        horDivlineColor = info[kHorDivlineColor] ? info[kHorDivlineColor] : [UIColor whiteColor];
        self.horizongtalDivline.backgroundColor = horDivlineColor;
        self.horizongtalDivline.hidden = self.hiddenOptionBtn;
        
        titleColor = info[kTitleColor] ? info[kTitleColor] : CJRGBAColor(55, 55, 55, 1);
        titleSelectedColor = info[kTitleSelectedColor] ? info[kTitleSelectedColor] : CJRGBAColor(255, 255, 255, 1);
        titleFontSize = info[kTitleFontSize] ? [info[kTitleFontSize] floatValue] : 16.0f;
        titleSelectedFontSize = info[kTitleSelectedFontSize] ? [info[kTitleSelectedFontSize] floatValue] : 17.0f;
        hiddenLine = info[kHiddenLine] ? [info[kHiddenLine] boolValue]:YES;
        hiddenSelcetLine = info[kHiddenSelcetLine] ? [info[kHiddenSelcetLine] boolValue]:NO;
        selectLineColor = info[kSelectLineColor] ? info[kSelectLineColor] : [UIColor grayColor];
        selectLineHeight = info[kSelectLineHeight] ? [info[kSelectLineHeight] floatValue] : 2;
        
        self.firstOffset = info[kFirstOffset] ? [info[kFirstOffset] floatValue] : 0.0;
        self.space = info[kSpace] ? [info[kSpace] floatValue] : 0.0;
        self.btnTabList = [NSMutableArray new];
        
        [self setColumnTitles:columnTitles];
    }
    return self;
}


-(void)dealloc{
    self.scrollView.delegate = nil;
}

-(void)onCustomBtnAction:(id)sender
{
    if (self.customBlock) {
        self.customBlock();
    }
}

- (void)setColumnTitles:(NSArray *)columnTitles
{
    if (_columnTitles == columnTitles) {
        return;
    }
    _currentIndex = -1;
    _columnTitles = nil;
    _columnTitles = columnTitles;
    
    [self.btnTabList removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.scrollView addSubview:self.divline];
    
    self.selectedView.hidden   = hiddenSelcetLine;
    self.selectedView.backgroundColor = selectLineColor;
    [self.scrollView addSubview:self.selectedView];
    
    
    //2. 根据传入参数初始化界面
    //修改
    //按钮button宽度 ＝ 320/栏目数；若 320/栏目数 < 栏目标题长度的最大值，则button宽度 ＝  栏目标题长度的最大值
    CGFloat y = 4;
    CGFloat x = _firstOffset;
    NSUInteger tag = 0;
    UIFont* font   = [UIFont systemFontOfSize:titleSelectedFontSize];
    CGFloat btnTitlewidth = 0;
    for (NSString* title in _columnTitles)
    {
        NSDictionary *attributes = nil;
        if(IOS_VERSION >= 6.0){
            attributes = @{NSFontAttributeName: font};
        }
        
        CGRect stringFrame = CGRectMake(0, 0, 0, 0);
        if (IOS_VERSION < 7) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            stringFrame.size= [title sizeWithFont:font];
#pragma clang diagnostic pop
        }else{
            stringFrame = [title boundingRectWithSize:CGSizeMake(MAXFLOAT,self.scrollView.frame.size.height - y*2)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attributes
                                              context:nil];
        }
        
        btnTitlewidth = btnTitlewidth < stringFrame.size.width + 10?stringFrame.size.width + 10:btnTitlewidth;
    }
    CGFloat btnWidth = (self.scrollView.frame.size.width-self.space*(_columnTitles.count-1))/_columnTitles.count;
    if (btnWidth < btnTitlewidth) {
        btnWidth = btnTitlewidth;
    }
    
    for (int i = 0;i<_columnTitles.count;i++)
    {
        NSString *title = (NSString*)[_columnTitles objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag   = tag;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(onBtnSelectChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectZero;
        btn.frame = CGRectMake(x, y,btnWidth,CGRectGetHeight(self.scrollView.frame)-y*2);
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        transform = btn.transform;
        
        [self changeButtonStateNormal:btn title:title];
        [self changeButtonStateHighlighted:btn title:title];
        
        //按钮之间添加竖线，样式示例： “SUV ｜ 中型车 ｜ 小型车”
        if (i<_columnTitles.count-1) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+self.space/2-0.5, y+2, 1, CGRectGetHeight(btn.frame)-4)];
            lineView.backgroundColor = titleColor;
            lineView.hidden = hiddenLine;
            [self.scrollView addSubview:lineView];
        }
        
        [self.scrollView addSubview:btn];
        [self.btnTabList addObject:btn];
        
        x += btnWidth + _space;
        tag ++;
    }
    
    
    //scrollview contentSize去掉最后一个间距，防止栏目少，间距大时scrollview可以滚动
    x -= _space;
    self.divline.frame = CGRectMake(0, self.scrollView.frame.size.height - 1, x, 1);
    self.selectedView.frame = CGRectMake(5, self.scrollView.frame.size.height-selectLineHeight,btnWidth-10,selectLineHeight);
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    
}

- (void)changeButtonStateNormal:(UIButton *)btn title:(NSString *)title {
    // 标题大小，标题颜色    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
}

- (void)changeButtonStateHighlighted:(UIButton *)btn title:(NSString *)title {
    // 选择中标题大小，标题颜色
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:titleSelectedColor forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:titleSelectedFontSize];
}

- (void)changeButtonStateSelect:(UIButton *)btn title:(NSString *)title {
    // 选中标题大小，标题颜色
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleSelectedColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:titleSelectedFontSize];
    
}


/*  简介：栏目内按钮切换操作
 *  作用：
 */
-(void)onBtnSelectChange:(UIButton*)btn
{
    [self selectAtIndex:btn.tag ifcallback:YES];
}

/*  简介：栏目按钮切换操作
 *  作用：类内部调用，不外放函数接口
 *  参数：ifCallBack ：-- 用来判断是否需要通知回调,
 */
-(void)selectAtIndex:(NSUInteger)index ifcallback:(BOOL)ifcallBack
{
    if (index >= self.btnTabList.count) {
        return;
    }
    if (index == _currentIndex) {
//        return;
    }
    
    // 选择：
    UIButton* selbtn = [self.btnTabList objectAtIndex:index];
    _currentIndex = index;
    
    [UIView animateWithDuration:0.25 animations:^(void) {
         for (UIButton *tabBtn in self.btnTabList) {
             if (tabBtn.tag != selbtn.tag) {
                 [self changeButtonStateNormal:tabBtn title:tabBtn.titleLabel.text];
             }
         }
         [self changeButtonStateSelect:selbtn title:selbtn.titleLabel.text];
        self.selectedView.frame = CGRectMake(selbtn.frame.origin.x+5, self.scrollView.frame.size.height-selectLineHeight,selbtn.frame.size.width-10,selectLineHeight);
         self.selectedView.hidden   = hiddenSelcetLine;
        //CGRectOffset(selbtn.frame,10,0)；表示selbtn沿着（0，0）x轴向右移动10个像素
        [self.scrollView scrollRectToVisible:CGRectOffset(selbtn.frame,10,0) animated:YES];
     } completion:^(BOOL finished) {
         if (ifcallBack == YES && self.doSelectBlock) {
             self.doSelectBlock(_currentIndex);
         }
     }];

}

@end
