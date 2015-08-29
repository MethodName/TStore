//
//  StoreNavigationBar.m
//  Store
//
//  Created by tangmingming on 15/8/28.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "StoreNavigationBar.h"

@interface StoreNavigationBar()




@end


@implementation StoreNavigationBar

/**
 *  初始化方法
 *
 *  @param frame 范围
 *
 *  @return 当前对象
 */
-(id)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame])
    {
        //左边按钮
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 44, 44)];
        [_leftBtn setImage:[UIImage imageNamed:@"back"] forState:0];
        [_leftBtn setImage:[UIImage imageNamed:@"back"] forState:1];
        [self addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //左边按钮
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-55, 20, 44, 44)];
        [_rightBtn setImage:[UIImage imageNamed:@"messages"] forState:0];
        [_rightBtn setImage:[UIImage imageNamed:@"messages"] forState:1];
        [self addSubview:_rightBtn];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //搜索框
        _searchBar  = [[UISearchBar alloc]initWithFrame:CGRectMake(55, 20, frame.size.width-110, 44)];
        [_searchBar setPlaceholder:@"商品搜索"];
        [self addSubview:_searchBar];
        
        //标题
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-100, 44)];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [_title setTextColor:[UIColor whiteColor]];
        [_title setCenter:CGPointMake(self.center.x, self.center.y+10)];
        [self addSubview:_title];
        
        [self setBarTintColor:[UIColor orangeColor]];
        
    }
    return self;
}


/**
 *  左边按钮点击
 */
-(void)rightBtnClick
{
    [self.barDelegate rightClick];
}

/**
 *  右边按钮点击
 */
-(void)leftBtnClick
{
    [self.barDelegate leftClick];
}

@end
