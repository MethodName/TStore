//
//  ProductListTableViewController.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListTableViewController.h"
#import "ProductListMenuView.h"
//#import "MJRefresh.h"
#import "ScreeningView.h"
#import "SearchProductDelegate.h"
#import "SortView.h"
#import "StoreProductsModel.h"
#import "StoreDefine.h"
#import "ProductListCell.h"
#import "ToolsOriginImage.h"
#import "ProductDetailViewController.h"

@interface ProductListTableViewController ()<UITableViewDataSource,UITableViewDelegate,SearchProductDelegate,MainSreachBarDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *productList;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)ScreeningView *screeingView;

@property(nonatomic,strong)SortView *sortView;

@end

@implementation ProductListTableViewController

#pragma mark -视图加载后
- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self createView];
}


#pragma mark -创建视图
-(void)createView{
    _mainSize = self.view.frame.size;
    
    //导航按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"messageList.png"] scaleToSize:CGSizeMake(22, 32)] style:UIBarButtonItemStyleBordered target:self action:nil];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    ProductListMenuView *menuView = [ProductListMenuView defaultViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    [self.view addSubview:menuView];
    [menuView.screening addTarget:self action:@selector(showScreeningView) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView.sort addTarget:self action:@selector(showSortView) forControlEvents:UIControlEventTouchUpInside];
      
    
#pragma mark -tableView初始化
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, _mainSize.width, _mainSize.height-108) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setRowHeight:TABLE_CELL_HEIGHT];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    //self.tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pushData)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ProductListCell class] forCellReuseIdentifier:@"productListCell"];
    
    [self pushData];
    
    /*----------------------------------【添加手势】-------------------------------------*/
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];

    
    
}

#pragma mark -Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}

#pragma mark -tableView每行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell" forIndexPath:indexPath];
    if (cell.productImage == nil) {
        cell = [[ProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
    }
    [cell setCellDataWith:_productList[indexPath.row]];
    [cell.addShopCar addTarget:self action:@selector(addShopCarClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark -加入购物车
-(void)addShopCarClick:(UIButton*)btn
{
    NSLog(@"加入购物车%d",(int)btn.tag);
}

#pragma mark -刷新数据
-(void)pushData{
    if (_productList == nil) {
        _productList = [NSMutableArray new];
    }
    [_productList removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i<10; i++) {
            StoreProductsModel *product = [StoreProductsModel new];
            [product setProductName:@"露天大樱桃"];
            [product setProductDesc:@""];
            [product setProductImages:[NSArray arrayWithObjects:@"product2", nil]];
            [product setProductSaleCount:15];
            [product setProductPrice:36.25];
            [product setPUName:@"斤"];
            [product setPSName:@"1.5斤/份"];
            [_productList addObject:product];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //[self.tableView.header endRefreshing];
        });

    });
}

#pragma mark -显示筛选视图
-(void)showScreeningView
{
    if (self.sortView.hidden==NO&&self.screeingView.hidden==YES) {
        [self.sortView setHidden:YES];
    }
    [self.screeingView setHidden:!self.screeingView.hidden];
}

#pragma mark -显示排序视图
-(void)showSortView
{
    if (self.sortView.hidden==YES&&self.screeingView.hidden==NO) {
        [self.screeingView setHidden:YES];
    }
    [self.sortView setHidden:!self.sortView.hidden];

}

#pragma mark -筛选所有
-(void)searchProductListWithType:(NSInteger)type
{
    [self.screeingView setHidden:YES];
    [self.sortView setHidden:YES];
}

#pragma mark -ScreeningView懒加载
-(ScreeningView*)screeingView{
    if (_screeingView ==nil)
    {
        _screeingView = [[ScreeningView alloc]initWithFrame:CGRectMake(0, 104, _mainSize.width, _mainSize.height-104)];
        [self.view addSubview:_screeingView];
        [_screeingView setDelegate:self];
        [_screeingView setHidden:YES];
    }
    return _screeingView;
}

#pragma mark -SortView懒加载
-(SortView*)sortView{
    if (_sortView ==nil)
    {
            _sortView = [[SortView alloc]initWithFrame:CGRectMake(0, 104, _mainSize.width, _mainSize.height-104)];
            [self.view addSubview:_sortView];
            [_sortView setDelegate:self];
            [_sortView setHidden:YES];
    }
     return _sortView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [productDetail setDelegate:self];
    [_delegate hideSreachBar];
    [_delegate searchBarEndEditing];
    [self.navigationController pushViewController:productDetail animated:YES];
}



#pragma mark -返回上层
-(void)leftItemClick
{
    [_delegate searchBarEndEditing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)searchBarEndEditing
{
    [_delegate searchBarEndEditing];
}

-(void)showSreachBar
{
    [_delegate showSreachBar];
}






@end
