//
//  DeliveryTimeViewController.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "DeliveryTimeViewController.h"
#import "ToolsOriginImage.h"

@interface DeliveryTimeViewController ()

@end

@implementation DeliveryTimeViewController

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
   UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage: [UIImage imageWithCGImage:[[UIImage imageNamed:@"leftBtn"] CGImage] scale:2.0 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setTitle:@"送货时间"];
    
    
}







#pragma mark -返回上层
-(void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
