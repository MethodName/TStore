//
//  ShopBar.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ShopBar.h"

@implementation ShopBar

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //购物车按钮
        _shopCar = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.1, 5, 34, 30)];
        [_shopCar setBackgroundImage:[UIImage imageNamed:@"productDetailshopCar"] forState:0];
        [_shopCar addTarget:self action:@selector(shopCarClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_shopCar];
        
        //购物车商品数据
        _shopCatCount = [[UILabel alloc]initWithFrame:CGRectMake(24, 0, 14, 14)];
        [_shopCatCount setBackgroundColor:[UIColor redColor]];
        [_shopCatCount setTextColor:[UIColor whiteColor]];
        [_shopCatCount setClipsToBounds:YES];
        [_shopCatCount setFont:[UIFont systemFontOfSize:11]];
        [_shopCatCount setHidden:YES];
        [_shopCatCount setTextAlignment:NSTextAlignmentCenter];
        [_shopCatCount.layer setCornerRadius:7.0];
        [_shopCar addSubview:_shopCatCount];
        
        //添加到购物车
        _addShopCar = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.3, 5, frame.size.width*0.3, 33)];
        [_addShopCar setBackgroundColor:[UIColor orangeColor]];
        [_addShopCar setTitle:@"加入购物车" forState:0];
        [_addShopCar.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:16.0]];
        [self addSubview:_addShopCar];
        
        //立即购买
        _bayShop = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.65, 5, frame.size.width*0.3, 33)];
        [_bayShop setBackgroundColor:[UIColor redColor]];
        [_bayShop setTitle:@"立即购买" forState:0];
        [_bayShop.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:16.0]];
        [self addSubview:_bayShop];
        
        [self setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.0]];
        //[self setBackgroundColor:[UIColor clearColor]];
        //阴影
        [self.layer setShadowColor:[UIColor lightGrayColor].CGColor ];
        [self.layer setShadowOffset:CGSizeMake(4, -2)];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:2];
    }
    return self;
}

#pragma mark - 设置购物车上显示数量
-(void)setShopCatCountNum:(NSInteger)num
{
      if (num>0&&num<10)
    {
         [_shopCatCount setHidden:NO];
         [_shopCatCount setText:[NSString stringWithFormat:@"%d",(int)num]];
    }
    else if(num>=10)
    {
        [_shopCatCount setHidden:NO];
        [_shopCatCount setText:@"9+"];
        [_shopCatCount setFont:[UIFont fontWithName:@"Thonburi-Bold" size:9.0]];
    }
}

#pragma mark -通知父级跳转到购物车
-(void)shopCarClick
{
    [_delegate pushToShopCarView];
}





@end
