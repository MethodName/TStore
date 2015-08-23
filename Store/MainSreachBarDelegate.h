//
//  MainSreachBarDelegate.h
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainSreachBarDelegate <NSObject>

@optional
/*
    隐藏显示主页的SreachBar
 */
-(void)showSreachBar;

-(void)hideSreachBar;

-(void)showNavigationBarAndStutsBar;

-(void)hideNavigationBar;

/*
    SreachBar结束编辑
 */
-(void)searchBarEndEditing;

@end
