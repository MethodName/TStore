//
//  MainSreachBarDelegate.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainSreachBarDelegate <NSObject>

/*
    隐藏显示主页的SreachBar
 */
-(void)showSreachBar;

@optional
-(void)hideSreachBar;

/*
    SreachBar结束编辑
 */
-(void)searchBarEndEditing;

@end
