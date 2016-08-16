//
//  NewThingsViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/5/20.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "NewThingsViewController.h"
#import "CJColumnView.h"
#import "PageScrollView.h"
#import "DropdownSelectView.h"

@interface NewThingsViewController ()<PageScrollViewDelegate,PageScrollViewDataSource>

@property (nonatomic, strong) CJColumnView *columnview;//栏目
@property (nonatomic, weak) IBOutlet PageScrollView *pageView;
@property (nonatomic, strong) DropdownSelectView *selectView;//栏目

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;

@end

@implementation NewThingsViewController

- (void)dealloc {
    self.pageView.delegate = nil;
    self.pageView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新鲜事";
    
    self.view1 = [[UIView alloc]initWithFrame:self.pageView.bounds];
    self.view1.backgroundColor = [UIColor redColor];
    
    self.view2 = [[UIView alloc]initWithFrame:self.pageView.bounds];
    self.view2.backgroundColor = [UIColor greenColor];
    
    self.view3 = [[UIView alloc]initWithFrame:self.pageView.bounds];
    self.view3.backgroundColor = [UIColor grayColor];
    
    self.view4 = [[UIView alloc]initWithFrame:self.pageView.bounds];
    self.view4.backgroundColor = [UIColor blueColor];
    
    // 栏目
    NSDictionary *info = @{
                           kTitleFontSize:@15,
                           kTitleSelectedFontSize:@17,
                           kTitleColor:[UIColor blackColor],
                           kTitleSelectedColor:[UIColor redColor],
                           kHiddenDivLine:@(NO),
                           kDivlineColor:[UIColor colorWithRed:0.0 green:0.0045 blue:0.0 alpha:1.0],
                           kHiddenSelcetLine:@(NO),
                           kSelectLineColor:[UIColor redColor],
                           kSelectLineHeight:@2,
                           kBackColor:[UIColor whiteColor],
                           };
    __weak typeof(self) wself = self;
    self.columnview = [[CJColumnView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) columnTitles:@[@"最新",@"今日热门",@"最新",@"今日热门"] columnInfo:info];
    self.columnview.doSelectBlock = ^(NSUInteger selectIdx){
        [wself.pageView scrollToIndexView:selectIdx animation:YES];
        NSLog(@"点击了 %@",@(selectIdx));
        if (selectIdx == 1) {
            [wself.selectView showDropdownSelectViewTo:[UIApplication sharedApplication].keyWindow];
        }
        return wself.view;
    };
    [self.view addSubview:self.columnview];
    [self.columnview selectAtIndex:0 ifcallback:NO];
    
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    self.pageView.bounces = YES;
    [self.pageView reloadData];
    
    self.selectView = [[DropdownSelectView alloc]initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    [self.selectView reloadData:@[@"漩涡",@"不知道",@"开玩乐",@"真好笑"] withSelectID:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PageScrollViewDataSource
- (NSInteger)numberOfPages {
    return 4;
}

- (UIView *)pageScrollView:(PageScrollView *)pageView viewForIndex:(NSInteger)index {
    UIView *view = nil;
    switch (index) {
        case 0:
            view = self.view1;
            break;
        case 1:
            view = self.view2;
            break;
        case 2:
            view = self.view3;
            break;
        case 3:
            view = self.view4;
            break;
        default:
            break;
    }
    view.frame = pageView.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    return view;
}

- (void)pageScrollView:(PageScrollView *)pageView didLoadItemAtIndex:(NSInteger)index {
    [self.columnview selectAtIndex:index ifcallback:NO];
}
@end
