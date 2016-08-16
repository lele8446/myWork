//
//  DropdownSelectView.h
//  BitAutoCRM
//
//  Created by YiChe on 16/5/24.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 40*[[UIScreen mainScreen] bounds].size.width/320.0

typedef void(^SelectViewBlock)(NSInteger selectID, BOOL haveData);

@interface DropdownSelectView : UIView
@property (nonatomic, copy) SelectViewBlock selectBlock;

- (void)reloadData:(NSArray *)data withSelectID:(NSInteger)selectID;

- (void)showDropdownSelectViewTo:(UIView *)view;

- (void)hiddenDropdownSelectView;

@end
