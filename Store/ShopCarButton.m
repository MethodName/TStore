//
//  ShopCarButton.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ShopCarButton.h"

@interface ShopCarButton ()

@property(nonatomic,strong)UILabel *shopCarCount;



@end

@implementation ShopCarButton



-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       
        
        //购物车商品数据
        _shopCarCount = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, 18, 18)];
        [_shopCarCount setBackgroundColor:[UIColor redColor]];
        [_shopCarCount setTextColor:[UIColor whiteColor]];
        [_shopCarCount setClipsToBounds:YES];
        [_shopCarCount setFont:[UIFont systemFontOfSize:11]];
        [_shopCarCount setHidden:YES];
        [_shopCarCount setTextAlignment:NSTextAlignmentCenter];
        [_shopCarCount.layer setCornerRadius:9.0];
        [self addSubview:_shopCarCount];
        
        //[self.imageView setFrame:CGRectMake(7, 5, 30, 34)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(7, 5, 7, 5)];
        [self setImage:[UIImage imageNamed:@"productDetailshopCar"] forState:0];
        //阴影
        [self.layer setShadowColor:[UIColor lightGrayColor].CGColor ];
        [self.layer setShadowOffset:CGSizeMake(0, -2)];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:2];
        
        [self setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.3]];
        [self.layer setCornerRadius:22];
    }
    return self;
}

#pragma mark -设置购物车按钮显示购物车中商品数量
-(void)setShopcarCountWithNum:(NSInteger) count
{
    if (count==0)
    {
        [_shopCarCount setHidden:YES];
    }
   else  if (count>0&&count<10)
    {
        [_shopCarCount setHidden:NO];
        [_shopCarCount setText:[NSString stringWithFormat:@"%d",(int)count]];
    }
    else if(count>=10)
    {
        [_shopCarCount setHidden:NO];
        [_shopCarCount setText:@"9+"];
        [_shopCarCount setFont:[UIFont fontWithName:@"Thonburi-Bold" size:9.0]];
    }
}


@end
