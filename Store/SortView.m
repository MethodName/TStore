//
//  SortView.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SortView.h"
#import "StoreDefine.h"


@implementation SortView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        NSArray *array = @[@"销量",@"价格",@"上架时间"];
        UIView *sView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width*0.33, -104, frame.size.width*0.33, 105)];
        [sView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:sView];
        for (int i =0; i<array.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45*i, frame.size.width*0.33, 44)];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn.layer setCornerRadius:2.0];
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
            [btn setTitle:array[i] forState:0];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            switch (i)
            {
                case 0:
                    [btn setTag:SORT_SCALECOUNT_TAG];
                    break;
                case 1:
                    [btn setTag:SORT_PRICE_TAG];
                    break;
                case 2:
                    [btn setTag:SORT_UPDATE_TAG];
                    break;
                default:
                    [btn setTag:HIED_SELF_TAG];
                    break;
            }
            
            [btn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
            
            [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
            
            [sView addSubview:btn];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf)];
            [self addGestureRecognizer:tap];

        }
        _sView = sView;
        
    }
    return self;
}

#pragma mark -排序代理方法
-(void)sort:(UIButton *)btn
{
    [_delegate searchProductListWithType:btn.tag];
}

-(void)hideSelf{
    [_delegate searchProductListWithType:HIED_SELF_TAG];
}

@end
