//
//  ProductListMenuView.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListMenuView.h"

@implementation ProductListMenuView

+(ProductListMenuView *)defaultViewWithFrame:(CGRect)frame{
    ProductListMenuView *defaulfView = [[ProductListMenuView alloc]initWithFrame:frame];
    [defaulfView setBackgroundColor:[UIColor whiteColor]];
    UIView *dView  = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-5, frame.size.width, 5)];
    [dView setBackgroundColor:[UIColor lightGrayColor]];
    [defaulfView addSubview:dView];
    return defaulfView;
}

-(void)drawRect:(CGRect)rect{
    //1、获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint ps[] = {CGPointMake(self.frame.size.width*0.33, 5), CGPointMake(self.frame.size.width*0.33, self.frame.size.height-10)};
    CGContextAddLines(context, ps, sizeof(ps)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 2.0);
    [[UIColor lightGrayColor]set];
    CGContextDrawPath(context, kCGPathStroke);
}


@end
