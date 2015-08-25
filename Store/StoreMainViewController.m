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
#import "MainProductCell.h"
#import "ProductListTableViewController.h"
#import "ToolsOriginImage.h"
#import "ProductDetailViewController.h"
#import "ProductTypes.h"
#import "ShopCarViewController.h"
#import "CustomHUD.h"
#import "ShopCarButton.h"
#import "MessageListViewController.h"
#import "Product.h"
#import "StoreDefine.h"
#import "User.h"


@interface StoreMainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MainMeunViewDelegate,MainSreachBarDelegate,TopProductsViewDelegate,MainADScrollVIewDelegate,MainProductCellDelegate>

#pragma mark -屏幕大小
@property(assign,nonatomic)CGSize mainSize;

@property(strong,nonatomic)UITableView *tableView;

#pragma mark -底部ScrollView
@property(nonatomic,strong)UIView *headView;

#pragma mark -广告图片
@property(strong,nonatomic)NSMutableArray *adImages;

@property(strong,nonatomic)MainADScrollVIew *ad;

@property(nonatomic,strong)MainMeunView *meunView;

@property(nonatomic,weak)TopProductsView *topProductsView;

@property(strong,nonatomic)NSMutableArray *productTypes;

@property(nonatomic,strong)NSMutableArray *hotProductList;

@property(nonatomic,weak)UISearchBar *search;

@property(nonatomic,strong)CustomHUD *hud;

@property(nonatomic,strong)CustomHUD *addshopHud;

@property(nonatomic,strong)ShopCarButton *shopCar;

@property(nonatomic,weak)UIPageControl *page;

@end

@implementation StoreMainViewController

#define NAVIGATION_ITEM_CELL 35

#define NAVIGATION_POSITION_Y 20




#pragma mark -视图加载后
- (void)viewDidLoad
{
    [User setShacreUserID:5];
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
    _topProductsView = topProductsView;
    [topProductsView setDelegate:self];
    

    
#pragma mark -重新设置headview大小
    [_headView setFrame:CGRectMake(0, 0, _mainSize.width, topProductsView.frame.origin.y+topProductsView.frame.size.height+2)];
   [_tableView setTableHeaderView:_headView];
    
    //购物车按钮
    _shopCar = [[ShopCarButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-45, 44, 44)];
    [_shopCar addTarget:self action:@selector(pushToShopCarView) forControlEvents:UIControlEventTouchUpInside];
    [_shopCar setShopcarCountWithNum:15];
    [self.view addSubview:_shopCar];
    
#pragma mark -刷新控件
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置普通状态的动画图片
    NSMutableArray *images1 = [NSMutableArray new];
    for (int i =0; i<28; i++) {
        NSString *path =[NSString stringWithFormat:@"Image.bundle/loading/%d.png",i+1];
        UIImage *img =[UIImage imageNamed:path];
        [images1 addObject:[UIImage imageWithCGImage:[img CGImage] scale:4.0 orientation:UIImageOrientationUp]];
    }
    [header setImages:images1 forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:images1 forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:images1 forState:MJRefreshStateRefreshing];
    // 设置header
    self.tableView.header = header;
    
#pragma mark -指示器
    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    _hud = hud;
    
    
    
//加载数据
    [self loadData];
}


#pragma mark -刷新数据
-(void)loadData{
    //广告
    if(_adImages==nil)
    {
        _adImages = [[NSMutableArray alloc]init];
    }
    //热销商品
    if (_hotProductList == nil)
    {
        _hotProductList = [NSMutableArray new];
    }
    [_hotProductList removeAllObjects];
    
    /**
     *  异步获取数据
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
#pragma mark -获取广告图片资源
        for (int i =0; i<4; i++) {
            [_adImages addObject:[UIImage imageNamed:@"ad.png"]];
        }

#pragma mark -分类信息
        if (_productTypes == nil)
        {
            _productTypes = [NSMutableArray new];
            NSArray *typeIcons = @[@"tuijian",@"shuiguo",@"nongjia",@"type"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (int i =0; i<3; i++) {
                    ProductTypes *type = [ProductTypes new];
                    [type setPTName:@"瓜果蔬菜"];
                    [type setPTID:1];
                    [type setPTIconUrl:typeIcons[i+1]];
                    [_productTypes addObject:type];
                }
            });
        }

#pragma mark -置顶商品
        NSMutableArray *proArray =[NSMutableArray new];
        for (int i =0; i<3; i++)
        {
            Product *product1 = [Product new];
            [product1 setProductName:@"看家神器"];
            [product1 setProductDesc:@"无线wifi摄像头"];
            [product1 setProductImages:@"product1"];
            [product1 setProductID:@"SP201508210006"];
            [proArray addObject:product1];
        }
       
        
   #pragma mark -热销商品
        for (int i =0; i<9; i++) {
            //获取热销商品资源
            Product *product = [Product new];
            [product setProductID:@"SP201508210006"];
            [product setProductName:@"大草莓"];
            [product setProductDesc:@"大草莓，小草莓，大大草莓"];
            product.productImages =@"shuiguo";
            [product setProductPrice:15.0];
            [product setProductSaleCount:(i+5)*3];
            [_hotProductList addObject:product];
        }

#pragma mark -主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^
        {
            
            //广告
             [_ad setImages:_adImages];
            //商品类别信息
            [_meunView setMenuItems:_productTypes];
            //置顶商品
             [_topProductsView setProducts:proArray];
            //商品列表信息
            [self.tableView reloadData];
            //停止刷新控件刷新
            [self.tableView.header endRefreshing];
            //隐藏加载动画
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
    Product *product = _hotProductList[indexPath.row];
    
    MainProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainProductCell" forIndexPath:indexPath];
    if (cell.productImage == nil) {
        cell = [[MainProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainProductCell"];
    }
    [cell setCellDataWithProduct:product];
    //设置Cell代理
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark -热销商品跳转到商品详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //隐藏seachBar
    [_search setHidden:YES];
    
    Product *product = _hotProductList[indexPath.row];
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [productDetail setDelegate:self];
    productDetail.productID =product.productID;
    [self.navigationController pushViewController:productDetail animated:YES];
}



#pragma mark -置顶商品跳转详细信息
-(void)productDetailWithProductID:(NSString *)proid
{
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [_search setHidden:YES]; 
    [productDetail setDelegate:self];
    [productDetail setProductID:proid];
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

#pragma mark -加入购物车（cell代理方法）
-(void)addShopCarCWithProductID:(NSString *)productID
{
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    
    NSString *path = [NSString stringWithFormat:@"%s%@%@%@%d",SERVER_ROOT_PATH,@"StoreCollects/addStoreCollects?productID=",productID,@"&userID=",(int)[User shareUserID]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"status"] intValue] == 1)//成功
                {
                    [self.addshopHud simpleComplete];
                }
                else//失败
                {
                    [self.addshopHud stopAnimation];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
            });
        }
    }];
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
