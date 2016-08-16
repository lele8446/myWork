//
//  DropdownSelectView.m
//  BitAutoCRM
//
//  Created by YiChe on 16/5/24.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "DropdownSelectView.h"

#define ViewAutoresizingFlexibleAll UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin

@interface DropdownSelectView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *maskView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectID;
@end


@implementation DropdownSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.hidden = YES;
    self.autoresizingMask = ViewAutoresizingFlexibleAll;
    
    //添加阴影View
    self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, self.bounds.size.width, 24)];
    self.shadowView.backgroundColor = [UIColor whiteColor];
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.shadowView.layer.shadowOffset = CGSizeMake(0,6);//shadowOffset阴影偏移,x向右偏移0，y向下偏移6，默认(0, -6),这个跟shadowRadius配合使用
    self.shadowView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.shadowView.layer.shadowRadius = 6;//阴影半径，默认6
    self.shadowView.autoresizingMask = ViewAutoresizingFlexibleAll;
    [self addSubview:self.shadowView];
    
    self.maskView = [[UIButton alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    self.maskView.autoresizingMask = ViewAutoresizingFlexibleAll;
    [self.maskView addTarget:self action:@selector(maskClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.maskView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizingMask = ViewAutoresizingFlexibleAll;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:self.tableView];
}

- (void)maskClick:(UIButton *)sender {
    [self hiddenDropdownSelectView];
}

- (void)reloadData:(NSArray *)data withSelectID:(NSInteger)selectID {
    self.dataArray = data;
    self.selectID = selectID;
    [self.tableView reloadData];
}

- (void)showDropdownSelectViewTo:(UIView *)view {
    [view addSubview:self];
    self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    self.shadowView.frame = CGRectMake(0,0, self.bounds.size.width, 0);
    self.hidden = NO;
    [self.tableView reloadData];
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^(void){
        self.maskView.alpha = 0.5;
        self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, CELL_HEIGHT*(self.dataArray.count));
        self.shadowView.frame = CGRectMake(0, CELL_HEIGHT*(self.dataArray.count)-24, self.bounds.size.width, 24);
    }completion:^(BOOL finished){
    }];
}

- (void)hiddenDropdownSelectView {
    self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, CELL_HEIGHT*(self.dataArray.count));
    self.shadowView.frame = CGRectMake(0, CELL_HEIGHT*(self.dataArray.count)-24, self.bounds.size.width, 24);
    [UIView animateWithDuration:0.25 animations:^(void){
        self.maskView.alpha = 0;
        self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        self.shadowView.frame = CGRectMake(0,0, self.bounds.size.width, 0);
    }completion:^(BOOL finished){
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(__unused NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:cell.frame];
        textLabel.autoresizingMask = ViewAutoresizingFlexibleAll;
        textLabel.tag = [@"textLabel" hash];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:textLabel];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:[@"textLabel" hash]];
    label.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    label.textColor = [UIColor colorWithRed:0.3255 green:0.3255 blue:0.3255 alpha:1.0];
    label.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == self.selectID) {
        label.textColor = [UIColor colorWithRed:0.0 green:0.4431 blue:0.7922 alpha:.8];
        label.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.9647 alpha:1.0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectID = indexPath.row;
    if (self.selectBlock) {
        self.selectBlock(self.selectID,YES);
    }
    [self hiddenDropdownSelectView];
}
@end
