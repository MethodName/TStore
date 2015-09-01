//
//  DeliveryTimeViewController.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "DeliveryTimeViewController.h"
#import "ToolsOriginImage.h"
#import "StoreNavigationBar.h"
@interface DeliveryTimeViewController ()<StoreNavigationBarDeleagte>

@end

@implementation DeliveryTimeViewController
/**
 *  视图加载后
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
}

#pragma mark -创建子视图
-(void)createView
{
    /**
     导航按钮
     */
    [self.navigationController setNavigationBarHidden:YES];
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.rightBtn setHidden:YES];
    [navigationBar.title setText:@"送货时间"];
    [self.view addSubview:navigationBar];
    
}







#pragma mark -返回上层
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
