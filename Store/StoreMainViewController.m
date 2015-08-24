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
#import "StoreProductsModel.h"
#import "MainProductCell.h"
#import "ProductListTableViewController.h"
#import "ToolsOriginImage.h"
#import "ProductDetailViewController.h"
#import "ProductTypes.h"
#import "ShopCarViewController.h"
#import "CustomHUD.h"
#import "ShopCarButton.h"
#import "MessageListViewController.h"

@interface StoreMainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MainMeunViewDelegate,MainSreachBarDelegate,TopProductsViewDelegate,MainADScrollVIewDelegate>

#pragma mark -屏幕大小
@property(assign,nonatomic)CGSize mainSize;

@property(strong,nonatomic)UITableView *tableView;

#pragma mark -底部ScrollView
@property(nonatomic,strong)UIView *headView;

#pragma mark -广告图片
@property(strong,nonatomic)NSMutableArray *adImages;

@property(strong,nonatomic)MainADScrollVIew *ad;

@property(nonatomic,strong)MainMeunView *meunView;

@property(strong,nonatomic)NSMutableArray *productTypes;

@property(nonatomic,strong)NSMutableArray *hotProductList;

@property(nonatomic,weak)UISearchBar *search;

@property(nonatomic,strong)CustomHUD *hud;

@property(nonatomic,strong)CustomHUD *addshopHud;

@property(nonatomic,strong)ShopCarButton *shopCar;

@property(nonatomic,weak)UIPageControl *page;

@property(nonatomic,assign)NSInteger userID;


@end

@implementation StoreMainViewController

#define NAVIGATION_ITEM_CELL 35

#define NAVIGATION_POSITION_Y 20




#pragma mark -视图加载后
- (void)viewDidLoad
{
    _userID = 1;
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    _mainSize = self.view.frame.size;
    [self createView];
}



#pragma mark -创建视图
-(void)createView{
   
    
    
#pragma mark -左右按钮

   
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage: [UIImage imageWithCGImage:[[UIImage imageNamed:@"leftBtn"] CGImage] scale:1.8 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"messageList"] CGImage] scale:2.0 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    
    
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
#pragma mark -搜索框
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width-30*4, 44)];
    [search setPlaceholder:@"搜索商品"];
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
    
#pragma mark -headView
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height)];
    [_headView setBackgroundColor:[UIColor colorWithRed:(220/255.0) green:(220.0/255.0) blue:(220.0/255.0) alpha:1.0]];
    
#pragma mark -广告ScrollView
    _ad = [[MainADScrollVIew alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.width*0.4)];
    [_ad setSreachBarDelegate:self];
    [_ad setImageMoveDelegate:self];
    [_ad setDelegate:self];
    [_headView addSubview:_ad];
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(_ad.frame.size.width-100, _ad.frame.size.height-20, 100,20)];
    [page setNumberOfPages:4];
    [page setCurrentPage:0];
    _page = page;
    [_headView addSubview:page];
    
    
#pragma mark  -菜单
    _meunView = [[MainMeunView alloc]initWithFrame:CGRectMake(0, _ad.frame.origin.y+_ad.frame.size.height, _mainSize.width, 100)];
    [_meunView setDelegate:self];
    [_headView addSubview:_meunView];
   
    
    
#pragma mark -置顶商品
    TopProductsView *topProductsView = [[TopProductsView alloc]initWithFrame:CGRectMake(0, _meunView.frame.origin.y+_meunView.frame.size.height+10, _mainSize.width, 150)];
    [_headView addSubview:topProductsView];
    [topProductsView setDelegate:self];
    
    /*---------------------------------【置顶商品数据】--------------------------------------*/
    StoreProductsModel *product1 = [StoreProductsModel new];
    [product1 setProductName:@"看家神器"];
    [product1 setProductDesc:@"无线wifi摄像头"];
    product1.ProductImages = [NSArray arrayWithObjects:@"product1", nil];
    [product1 setProductID:@"1"];

    StoreProductsModel *product2 = [StoreProductsModel new];
    [product2 setProductName:@"关爱之星"];
    [product2 setProductDesc:@"儿童卡通定位手机"];
    product2.ProductImages = [NSArray arrayWithObjects:@"nongjia", nil];
    [product2 setProductID:@"2"];
    
    StoreProductsModel *product3 = [StoreProductsModel new];
    [product3 setProductName:@"关爱之星"];
    [product3 setProductDesc:@"儿童卡通定位手机"];
    product3.ProductImages = [NSArray arrayWithObjects:@"type", nil];
    [product3 setProductID:@"3"];
    
    NSArray *proArray = [[NSArray alloc]initWithObjects:product1,product2,product3, nil];
    [topProductsView setProducts:proArray];
    /*-----------------------------------------------------------------------*/
    
    //重新设置headview大小
    [_headView setFrame:CGRectMake(0, 0, _mainSize.width, topProductsView.frame.origin.y+topProductsView.frame.size.height+2)];
   [_tableView setTableHeaderView:_headView];
    
    //购物车按钮
    _shopCar = [[ShopCarButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-45, 44, 44)];
    [_shopCar addTarget:self action:@selector(pushToShopCarView) forControlEvents:UIControlEventTouchUpInside];
    [_shopCar setShopcarCountWithNum:15];
    [self.view addSubview:_shopCar];
    
    
    
    
    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    //[self.navigationController.navigationBar setHidden:YES];
    _hud = hud;
    //加载数据
    [self loadData];
    
    
}


#pragma mark -刷新数据
-(void)loadData{
    //广告
    if(_adImages==nil){
        _adImages = [[NSMutableArray alloc]init];
        //获取广告图片资源
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i =0; i<4; i++) {
                [_adImages addObject:[UIImage imageNamed:@"ad.png"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_ad setImages:_adImages];
            });
        });
    }

    //分类
    if (_productTypes == nil)
    {
        _productTypes = [NSMutableArray new];
        //获取广告图片资源
        NSArray *typeIcons = @[@"tuijian",@"shuiguo",@"nongjia",@"type"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i =0; i<3; i++) {
                ProductTypes *type = [ProductTypes new];
                [type setPTName:@"瓜果蔬菜"];
                [type setPTID:1];
                [type setPTIconUrl:typeIcons[i+1]];
                [_productTypes addObject:type];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_meunView setMenuItems:_productTypes];
            });
        });

    }
    
    //热销商品
    if (_hotProductList == nil) _hotProductList = [NSMutableArray new];
    [_hotProductList removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i<9; i++) {
            //获取热销商品资源
            StoreProductsModel *product = [StoreProductsModel new];
            [product setProductName:@"大草莓"];
            [product setProductDesc:@"大草莓，小草莓，大大草莓"];
            product.ProductImages = [NSArray arrayWithObjects:@"shuiguo", nil];
            [product setProductPrice:15.0];
            [product setProductSaleCount:(i+5)*3];
            [_hotProductList addObject:product];
            
        }
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            //[self.navigationController.navigationBar setHidden:NO];
            [_hud loadHide];
        });
        
    });
    
}



#pragma mark -设置表格行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hotProductList.count;
}

#pragma mark -设置表格行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreProductsModel *product = _hotProductList[indexPath.row];
    
    MainProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainProductCell" forIndexPath:indexPath];
    if (cell.productImage == nil) {
        cell = [[MainProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainProductCell"];
    }
    [cell setCellDataWithProduct:product];
    [cell.addShopCar addTarget:self action:@selector(addShopCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

#pragma mark -点击商品列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [_search setHidden:YES];
    [productDetail.navigationController setTitle:@"商品详情"];
    [productDetail setDelegate:self];
    [self.navigationController pushViewController:productDetail animated:YES];
}



#pragma mark -跳转商品详细信息
-(void)productDetailWithProductID:(NSString *)proid
{
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [_search setHidden:YES]; 
    [productDetail setDelegate:self];
    [self.navigationController pushViewController:productDetail animated:YES];
}

#pragma mark -搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_search endEditing:YES];
    ProductListTableViewController *productListTableView = [[ProductListTableViewController alloc]init];
    [productListTableView setDelegate:self];
    [self.navigationController pushViewController:productListTableView animated:YES];
}

#pragma mark -商品类别搜索
-(void)productListWithType:(NSInteger)type
{
    [_search endEditing:YES];
    ProductListTableViewController *productListTableView = [[ProductListTableViewController alloc]init];
    [productListTableView setDelegate:self];
    [self.navigationController pushViewController:productListTableView animated:YES];
}

#pragma mark -加入购物车
-(void)addShopCarClick:(UIButton*)btn
{
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.addshopHud simpleComplete];
        });
    });
}

#pragma mark -跳转到购物车
-(void)pushToShopCarView
{
    [_search setHidden:YES];
    ShopCarViewController *shopCar = [[ShopCarViewController alloc]init];
    [shopCar setDelegate:self];
    [shopCar setUserID:10];//传入用户ID
    [self.navigationController pushViewController:shopCar animated:YES];
}



#pragma mark -CustomHUD 懒加载
-(CustomHUD *)addshopHud
{
    if (_addshopHud == nil) {
        _addshopHud= [CustomHUD defaultCustomHUDSimpleWithFrame:self.view.frame];
        [self.view addSubview:_addshopHud];
        [_addshopHud setHidden:YES];
    }
    return _addshopHud;
}

#pragma mark -PageControl显示当前页代理
-(void)imageMoveWithIndex:(NSInteger)index
{
    [_page setCurrentPage:index];
}

#pragma mark -显示sreachBar代理方法
-(void)showSreachBar
{
    [_search setHidden:NO];
}

-(void)hideSreachBar
{
    [_search setHidden:YES];
}

-(void)searchBarEndEditing
{
    [_search endEditing:YES];
}

-(void)showNavigationBarAndStutsBar
{
    [self.navigationController.navigationBar setHidden:NO];
}


#pragma mark - 左边按钮
-(void)leftItemClick
{
    NSLog(@"返回上级");
}


-(void)rightItemClick
{
    [_search setHidden:YES];
    MessageListViewController *messageListView = [[MessageListViewController alloc]init];
    [messageListView setDelegate:self];
    [self.navigationController pushViewController:messageListView animated:YES];
}








@end
