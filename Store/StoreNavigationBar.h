//
//  StoreNavigationBar.h
//  Store
//
//  Created by tangmingming on 15/8/28.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreNavigationBarDeleagte <NSObject>

@optional
/**
 *  左边按钮代理方法
 */
-(void)leftClick;

/**
 *  右边按钮代理方法
 */
-(void)rightClick;

@end


@interface StoreNavigationBar : UINavigationBar


@property(nonatomic,weak)id<StoreNavigationBarDeleagte>barDelegate;

/**
 *  左边按钮
 */
@property(nonatomic,strong)UIButton *leftBtn;

/**
 *  右边按钮
 */
@property(nonatomic,strong)UIButton *rightBtn;
/**
 *  标题
 */
@property(nonatomic,strong)UILabel *title;
/**
 *  搜索框
 */
@property(nonatomic,strong)UISearchBar *searchBar;

@end
