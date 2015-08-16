//
//  ProductListTableViewController.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListTableViewController.h"
#import "ProductListMenuView.h"

@interface ProductListTableViewController ()

@property(nonatomic,strong)NSMutableArray *productList;

@end

@implementation ProductListTableViewController

#pragma mark -视图加载后
- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self createView];
}


#pragma mark -创建视图
-(void)createView{
    //导航按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[self OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[self OriginImage: [UIImage imageNamed:@"messageList.png"] scaleToSize:CGSizeMake(22, 32)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    ProductListMenuView *menuView = [ProductListMenuView defaultViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.tableView setTableHeaderView:menuView];
    
    
    
    
}

-(void)leftItemClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}






#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    
    
    return cell;
}



-(UIImage*)OriginImage:(UIImage *)image   scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
