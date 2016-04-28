//
//  FirstViewController.m
//  rebirthCJ
//
//  Created by YiChe on 16/4/27.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    BaseViewController *twoCtr = [[BaseViewController alloc]initWithNibName:nil bundle:nil];
    twoCtr.navigationItem.title = @"子页面";
    [self.navigationController pushViewController:twoCtr animated:YES];
}

@end
