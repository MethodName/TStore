//
//  ProductListMenuView.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListMenuView.h"

@implementation ProductListMenuView

+(ProductListMenuView *)defaultViewWithFrame:(CGRect)frame
{
    ProductListMenuView *defaulfView = [[ProductListMenuView alloc]initWithFrame:frame];
    [defaulfView setBackgroundColor:[UIColor whiteColor]];
    UIView *dView  = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-5, frame.size.width, 5)];
    [dView setBackgroundColor:[UIColor colorWithRed:(220.0/255.0) green:(220.0/255.0) blue:(220.0/255.0) alpha:1.0]];
    
    [defaulfView addSubview:dView];
    
    defaulfView.screening = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, frame.size.width/3-1, 44)];
    [defaulfView.screening setTitle:@"筛选》" forState:0];
    [defaulfView.screening setTitleColor:[UIColor lightGrayColor] forState:0];
    [defaulfView.screening.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [defaulfView addSubview:defaulfView.screening];
    
    defaulfView.sort = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.33+1, 4, frame.size.width/3-1, 44)];
    [defaulfView.sort setTitle:@"排序》" forState:0];
    [defaulfView.sort setTitleColor:[UIColor lightGrayColor] forState:0];
    [defaulfView.sort.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [defaulfView addSubview:defaulfView.sort];

    defaulfView.collection = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.66+1, 4, frame.size.width/3-1, 44)];
    [defaulfView.collection setTitle:@"我的收藏》" forState:0];
    [defaulfView.collection setTitleColor:[UIColor lightGrayColor] forState:0];
    [defaulfView.collection.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [defaulfView addSubview:defaulfView.collection];

    
    
    return defaulfView;
}

#pragma mark -画线
-(void)drawRect:(CGRect)rect
{
    //1、获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint ps1[] = {CGPointMake(self.frame.size.width*0.33, 5), CGPointMake(self.frame.size.width*0.33, self.frame.size.height-10)};
    CGContextAddLines(context, ps1, sizeof(ps1)/sizeof(CGPoint));
    
    CGPoint ps2[] = {CGPointMake(self.frame.size.width*0.66, 5), CGPointMake(self.frame.size.width*0.66, self.frame.size.height-10)};
    CGContextAddLines(context, ps2, sizeof(ps2)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 1.0);
    [[UIColor colorWithRed:(220.0/255.0) green:(220.0/255.0) blue:(220.0/255.0) alpha:1.0]set];
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark -标记赛选
-(void)tagScreening
{
      [self.collection setTitleColor:[UIColor lightGrayColor] forState:0];
      [self.sort setTitleColor:[UIColor lightGrayColor] forState:0];
     [self.screening setTitleColor:[UIColor orangeColor] forState:0];
}

#pragma mark -标记排序
-(void)tagSort
{
    [self.collection setTitleColor:[UIColor lightGrayColor] forState:0];
    [self.screening setTitleColor:[UIColor lightGrayColor] forState:0];
    [self.sort setTitleColor:[UIColor orangeColor] forState:0];
}

#pragma mark -标记我的收藏
-(void)tagCollection
{
    [self.sort setTitleColor:[UIColor lightGrayColor] forState:0];
    [self.screening setTitleColor:[UIColor lightGrayColor] forState:0];
     [self.collection setTitleColor:[UIColor orangeColor] forState:0];
}




@end
