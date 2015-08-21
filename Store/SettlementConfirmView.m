//
//  SettlementConfirmView.m
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SettlementConfirmView.h"

@implementation SettlementConfirmView

#pragma mark -初始化
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        UILabel *heji = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 40, 20)];
        [heji setTextColor:[UIColor blackColor]];
        [heji setText:@"合计"];
        [self addSubview:heji];
        
        _sumPrice = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, frame.size.width*0.4, 20)];
        [_sumPrice setTextColor:[UIColor redColor]];
        [_sumPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:16.0]];
        [self addSubview:_sumPrice];
      
        
        // 确认按钮
        _settlementBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-(10+frame.size.width*0.3), 15, frame.size.width*0.3, 30)];
        [_settlementBtn setTitle:@"确定" forState:0];
        [_settlementBtn.layer setCornerRadius:2.0];
        [_settlementBtn setBackgroundColor:[UIColor orangeColor]];
        
        [self addSubview:_settlementBtn];
        
        //阴影
        [self.layer setShadowColor:[UIColor lightGrayColor].CGColor ];
        [self.layer setShadowOffset:CGSizeMake(-4, -2)];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:4];
        
        
    }
    return self;
}


@end
