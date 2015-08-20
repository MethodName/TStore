//
//  IconTitleButton.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "IconTitleButton.h"

@implementation IconTitleButton

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        _iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.4, frame.size.height*0.4)];
        [_iconImageView setCenter:CGPointMake(22, frame.size.height*0.35)];
        [_iconImageView setUserInteractionEnabled:YES];
        [self addSubview:_iconImageView];
        
        _titleText = [[UILabel alloc]initWithFrame:CGRectMake( 0,frame.size.height*0.5, frame.size.width, frame.size.height*0.5)];
        [_titleText setTextAlignment:NSTextAlignmentCenter];
        [_titleText setFont:[UIFont systemFontOfSize:15.0]];
        [_titleText setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_titleText];
        [_titleText setUserInteractionEnabled:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}






@end
