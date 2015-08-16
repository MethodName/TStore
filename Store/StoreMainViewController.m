//
//  StoreMainViewController.m
//  Store
//
//  Created by tangmingming on 15/8/13.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "StoreMainViewController.h"
#import "MainADScrollVIew.h"
#import "MainMeunView.h"
#import "TopProductsView.h"
#import "MJRefresh.h"
#import "Store_Products_Model.h"
#import "MainProductCell.h"
#import "ProductListTableViewController.h"

@interface StoreMainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

#pragma mark -屏幕大小
@property(assign,nonatomic)CGSize mainSize;

@property(strong,nonatomic)UITableView *tableView;

#pragma mark -底部ScrollView
@property(nonatomic,strong)UIView *headView;

#pragma mark -广告图片
@property(strong,nonatomic)NSMutableArray *adImages;

@property(nonatomic,strong)NSMutableArray *hotProductList;

@property(nonatomic,weak)UISearchBar *search;



@end

@implementation StoreMainViewController

#define NAVIGATION_ITEM_CELL 35

#define NAVIGATION_POSITION_Y 20




#pragma mark -视图加载后
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    _mainSize = self.view.frame.size;
    [self createView];
}



#pragma mark -创建视图
-(void)createView{
#pragma mark -左右按钮

    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[self OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[self OriginImage: [UIImage imageNamed:@"messageList.png"] scaleToSize:CGSizeMake(22, 32)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    
    
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
#pragma mark -搜索框
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width-30*4, 30)];
     [search setPlaceholder:@"请输入你想搜索的商品"];
    [search sizeToFit];
    [search setCenter:CGPointMake(self.navigationController.navigationBar.center.x, NAVIGATION_POSITION_Y)];
    [self.navigationController.navigationBar addSubview:search];
    [search setDelegate:self];
    _search = search;
    
#pragma mark -tableView
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height) style:UITableViewStylePlain];
    _tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[MainProductCell class] forCellReuseIdentifier:@"mainProductCell"];
    [self.tableView setRowHeight:100];
    _hotProductList = [NSMutableArray new];
    for (int i =0; i<9; i++) {
        Store_Products_Model *product = [Store_Products_Model new];
        [product setProductName:@"看家神器"];
        [product setProductDesc:@"无线wifi摄像头"];
        [product setProductPrice:15.0];
        product.ProductImages = [NSArray arrayWithObjects:@"product1.png", nil];
        [_hotProductList addObject:product];
    }

#pragma mark -headView
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height)];
    [_headView setBackgroundColor:[UIColor colorWithRed:(220/255.0) green:(220.0/255.0) blue:(220.0/255.0) alpha:1.0]];
    
#pragma mark -广告ScrollView
    MainADScrollVIew *ad = [[MainADScrollVIew alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.width*0.4)];
    [_headView addSubview:ad];
    _adImages = [[NSMutableArray alloc]init];
    for (int i =0; i<4; i++) {
        [_adImages addObject:[UIImage imageNamed:@"2.png"]];
    }
    [ad setImages:_adImages];
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(ad.frame.size.width-100, ad.frame.size.height-20, 100,20)];
    [page setNumberOfPages:4];
    [page setCurrentPage:1];
    [_headView addSubview:page];
    
    
#pragma mark  -菜单
    MainMeunView *meunView = [[MainMeunView alloc]initWithFrame:CGRectMake(0, ad.frame.origin.y+ad.frame.size.height, _mainSize.width, 100)];
    [_headView addSubview:meunView];
    [meunView setMenuItems:nil];
    
    
#pragma mark -置顶商品
    TopProductsView *topProductsView = [[TopProductsView alloc]initWithFrame:CGRectMake(0, meunView.frame.origin.y+meunView.frame.size.height+10, _mainSize.width, 150)];
    [_headView addSubview:topProductsView];
    
    Store_Products_Model *product1 = [Store_Products_Model new];
    [product1 setProductName:@"看家神器"];
    [product1 setProductDesc:@"无线wifi摄像头"];
    product1.ProductImages = [NSArray arrayWithObjects:@"product1.png", nil];
    
    Store_Products_Model *product2 = [Store_Products_Model new];
    [product2 setProductName:@"关爱之星"];
    [product2 setProductDesc:@"儿童卡通定位手机"];
    product2.ProductImages = [NSArray arrayWithObjects:@"product2.png", nil];
    
    NSArray *proArray = [[NSArray alloc]initWithObjects:product1,product2, nil];
    [topProductsView setProducts:proArray];
    [_headView setFrame:CGRectMake(0, 0, _mainSize.width, topProductsView.frame.origin.y+topProductsView.frame.size.height+2)];

    [_tableView setTableHeaderView:_headView];
}


#pragma mark -刷新数据
-(void)loadData{
    [_hotProductList removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i<9; i++) {
            Store_Products_Model *product = [Store_Products_Model new];
            [product setProductName:@"看家神器"];
            [product setProductDesc:@"无线wifi摄像头"];
            product.ProductImages = [NSArray arrayWithObjects:@"product1.png", nil];
            [product setProductPrice:15.0];
            [_hotProductList addObject:product];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        });
        
    });
    
}



#pragma mark -设置表格行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hotProductList.count;
}

#pragma mark -设置表格行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Store_Products_Model *product = _hotProductList[indexPath.row];
    
    MainProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainProductCell" forIndexPath:indexPath];
    if (cell.productImage == nil) {
        cell = [[MainProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainProductCell"];
    }
    [cell.productImage setImage: [UIImage imageNamed:product.ProductImages[0]]];
    [cell.productName setText:product.ProductName];
    [cell.productDetail setText:product.ProductDesc];
    [cell.productPrice setText:[NSString stringWithFormat:@"$%0.2lf",product.ProductPrice]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_search endEditing:YES];
    ProductListTableViewController *productListTableView = [[ProductListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:productListTableView animated:YES];
}

#pragma mark -搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_search endEditing:YES];
    ProductListTableViewController *productListTableView = [[ProductListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:productListTableView animated:YES];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_search endEditing:YES];
}

#pragma mark - 左边按钮
-(void)leftItemClick{
    
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
