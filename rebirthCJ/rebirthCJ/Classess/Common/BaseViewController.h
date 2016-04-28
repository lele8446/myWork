//
//  ViewController.h
//  rebirthCJ
//
//  Created by YiChe on 16/4/26.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) NSDictionary *ext;

/**
 *  初始化方法
 *
 *  @param uri 对应的xib名称，不存在则传nil
 *  @param ext 需要传递的参数
 *
 *  @return
 */
- (instancetype)initWithUri:(NSString *)uri ext:(NSDictionary *)ext;
@end

