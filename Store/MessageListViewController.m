//
//  MessageListViewController.m
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MessageListViewController.h"
#import "ToolsOriginImage.h"
#import "StoreNavigationBar.h"

@interface MessageListViewController ()<StoreNavigationBarDeleagte>

@end

@implementation MessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
}

#pragma mark -创建子视图
-(void)createView
{
    [self.navigationController setNavigationBarHidden:YES];
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.title setText:@"消息中心"];
    
    [self.view addSubview:navigationBar];
    
}

#pragma mark -返回上层
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
    
}




@end
