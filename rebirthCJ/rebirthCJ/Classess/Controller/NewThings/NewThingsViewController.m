//
//  NewThingsViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/5/20.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "NewThingsViewController.h"
#import "CJColumnView.h"


@interface NewThingsViewController ()

@property (nonatomic, strong) CJColumnView *columnview;//栏目

@end

@implementation NewThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新鲜事";
    
    // 栏目
    NSDictionary *info = @{
                           kTitleFontSize:@15,
                           kTitleSelectedFontSize:@17,
                           kTitleColor:[UIColor blackColor],
                           kTitleSelectedColor:[UIColor redColor],
                           kHiddenDivLine:@(YES),
                           kDivlineColor:[UIColor colorWithRed:0.0 green:0.0045 blue:0.0 alpha:1.0],
                           kHiddenSelcetLine:@(NO),
                           kSelectLineColor:[UIColor redColor],
                           kSelectLineHeight:@2,
                           kBackColor:[UIColor whiteColor],
                           };
    __weak typeof(self) wself = self;
    self.columnview = [[CJColumnView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) columnTitles:@[@"最新",@"今日热门"] columnInfo:info];
    self.columnview.doSelectBlock = ^(NSUInteger selectIdx){
//        [wself columnSelectChange:selectIdx];
        NSLog(@"点击了 %@",@(selectIdx));
        return wself.view;
        
    };
    self.columnview.customBlock = ^(void){
        NSLog(@"点击了扩展按钮");
    };
    
    [self.view addSubview:self.columnview];
    [self.columnview selectAtIndex:0 ifcallback:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
