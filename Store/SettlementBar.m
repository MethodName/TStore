//
//  SettlementBar.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SettlementBar.h"

@implementation SettlementBar

#pragma mark -初始化
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //全选
        //选择按钮
        _selectAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 25, 25)];
        [_selectAllBtn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
        [self addSubview:_selectAllBtn];
        
        UILabel *selAll = [[UILabel alloc]initWithFrame:CGRectMake(37, 20, 40, 20)];
        [selAll setTextColor:[UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0]];
        [selAll setText:@"全选"];
        [self addSubview:selAll];
        
        //总金额
        UILabel *heji = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.24, 10, 30, 20)];
        [heji setTextColor:[UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0]];
        [heji setText:@"合计"];
        [heji setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [self addSubview:heji];
        
        _sumPrice = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.24+30, 10, frame.size.width*0.3, 20)];
        [_sumPrice setTextColor:[UIColor redColor]];
        [_sumPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [self addSubview:_sumPrice];
        
        UILabel *yufen = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.24, 30, 80, 30)];
        [yufen setTextColor:[UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0]];
        [yufen setText:@"不含运费"];
        [yufen setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [self addSubview:yufen];
        
        
        //结算按钮
        _settlementBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-(10+frame.size.width*0.3), 15, frame.size.width*0.3, 30)];
        [_settlementBtn setTitle:@"结算" forState:0];
        [_settlementBtn setEnabled:NO];
        [_settlementBtn.layer setCornerRadius:2.0];
        [_settlementBtn setBackgroundColor:[UIColor lightGrayColor]];
       
        [self addSubview:_settlementBtn];
        
        //阴影
        [self.layer setShadowColor:[UIColor lightGrayColor].CGColor ];
        [self.layer setShadowOffset:CGSizeMake(-4, -2)];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:4];

        
    }
    return self;
}

-(void)setSettlementBarWithSumPrice:(double)sumPrice productCount:(NSInteger)count
{
    [_sumPrice setText:[NSString stringWithFormat:@"￥%0.2lf",sumPrice]];
    [_settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",(int)count] forState:0];
}




@end
