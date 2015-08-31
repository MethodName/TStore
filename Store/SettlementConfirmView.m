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
        
        /**
         运费
         */
        UILabel *yunfei = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 40, 20)];
        [yunfei setFont:[UIFont systemFontOfSize:14.0]];
        [yunfei setTextColor:[UIColor grayColor]];
        [yunfei setText:@"运费:"];
        [self addSubview:yunfei];
        
        
        _freight = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, frame.size.width*0.4, 20)];
        [_freight setTextColor:[UIColor blackColor]];
        [_freight setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        [self addSubview:_freight];
        
        /**
        总金额
         */
        UILabel *heji = [[UILabel alloc]initWithFrame:CGRectMake(15, frame.size.height-25, 40, 20)];
        [heji setTextColor:[UIColor blackColor]];
        [heji setText:@"合计:"];
        [self addSubview:heji];
        
        _sumPrice = [[UILabel alloc]initWithFrame:CGRectMake(50, frame.size.height-25, frame.size.width*0.55, 20)];
        [_sumPrice setTextColor:[UIColor redColor]];
        [_sumPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:16.0]];
        [self addSubview:_sumPrice];
      
        
        // 确认按钮
        _settlementBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-(10+frame.size.width*0.3), 15, frame.size.width*0.3, 35)];
        [_settlementBtn setTitle:@"确定下单" forState:0];
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
