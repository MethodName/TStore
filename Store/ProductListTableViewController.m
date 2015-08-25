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
#import "CustomHUD.h"
#import "ShopCarButton.h"
#import "ShopCarViewController.h"
#import "User.h"
#import "Product.h"

@interface ProductListTableViewController ()<UITableViewDataSource,UITableViewDelegate,SearchProductDelegate,MainSreachBarDelegate,ProductListCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *productList;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)ScreeningView *screeingView;

@property(nonatomic,strong)SortView *sortView;

@property(nonatomic,strong) CustomHUD *hud;

@property(nonatomic,strong)CustomHUD *addshopHud;

@property(nonatomic,strong)ShopCarButton *shopCar;

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
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage: [UIImage imageWithCGImage:[[UIImage imageNamed:@"leftBtn"] CGImage] scale:1.8 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"leftmuen"] CGImage] scale:2.0 orientation:UIImageOrientationUp]  style:UIBarButtonItemStyleBordered target:self action:nil];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    //选项
    ProductListMenuView *menuView = [ProductListMenuView defaultViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 56)];
    [self.view addSubview:menuView];
    [menuView.screening addTarget:self action:@selector(showScreeningView) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView.sort addTarget:self action:@selector(showSortView) forControlEvents:UIControlEventTouchUpInside];
      
    
#pragma mark -tableView初始化
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, _mainSize.width, _mainSize.height-120) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setRowHeight:TABLE_CELL_HEIGHT];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    //self.tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pushData)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ProductListCell class] forCellReuseIdentifier:@"productListCell"];
    
    [self pushData];
    
    //购物车按钮
    _shopCar = [[ShopCarButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-45, 44, 44)];
    [_shopCar addTarget:self action:@selector(pushToShopCarView) forControlEvents:UIControlEventTouchUpInside];
    [_shopCar setShopcarCountWithNum:15];
    [self.view addSubview:_shopCar];
    
    /*----------------------------------【添加手势】-------------------------------------*/
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];

    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    _hud = hud;

    
}

#pragma mark -Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}

#pragma mark -tableView每行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product =_productList[indexPath.row];
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell" forIndexPath:indexPath];
    if (cell.productImage == nil) {
        cell = [[ProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
    }
    [cell setCellDataWith:product];
   
    //设置cell代理
    [cell setDelegate:self];
    return cell;
}

#pragma mark -加入购物车
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

#pragma mark -刷新数据
-(void)pushData{
    if (_productList == nil) {
        _productList = [NSMutableArray new];
    }
    [_productList removeAllObjects];
    /**
     *  请求数据
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i<10; i++) {
            Product *product = [Product new];
            [product setProductID:@"SP201508210006"];
            [product setProductName:@"露天大草莓"];
            [product setProductDesc:@"很好吃的露天大🍓"];
            [product setProductImages:@"product1"];
            [product setProductSaleCount:15];
            [product setProductPrice:36.25];
            [product setPuName:@"斤"];
            [product setPsName:@"1.5斤/份"];
            [_productList addObject:product];
        }
        sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [_hud loadHide];
        });
    });
}

#pragma mark -显示筛选视图
-(void)showScreeningView
{
    if (!self.sortView.hidden) {
        [self showSortView];
    }
    [self.screeingView setHidden:NO];
    CGFloat y = 0;
    if (self.screeingView.sView.frame.origin.y==0)
    {
        y=-116;
    }
        
    [UIView animateWithDuration:0.15 animations:^{
       [self.screeingView.sView setFrame:CGRectMake(self.screeingView.sView.frame.origin.x, y, self.screeingView.sView .frame.size.width, self.screeingView.sView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (y==-116) {
            [_screeingView setHidden:YES];
        }
    }];

    
    
    
}

#pragma mark -显示排序视图
-(void)showSortView
{
    if (!self.screeingView.hidden) {
        [self showScreeningView];
    };
    [_sortView setHidden:NO];
    CGFloat y=0;
    if (self.sortView.sView.frame.origin.y==0)
    {
        y=-116;
        
    }
    //动画
    [UIView animateWithDuration:0.15 animations:^{
         [self.sortView.sView setFrame:CGRectMake(self.sortView.sView.frame.origin.x, y, self.sortView.sView .frame.size.width, self.sortView.sView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (y==-116) {
            [_sortView setHidden:YES];
        }
    }];
    
    
    
        
    
}

#pragma mark -排序，筛选，我的收藏
-(void)searchProductListWithType:(NSInteger)type
{
    [self.sortView.sView setFrame:CGRectMake(self.sortView.sView.frame.origin.x, -116, self.sortView.sView.frame.size.width, self.sortView.sView.frame.size.height)];
    [self.screeingView.sView setFrame:CGRectMake(self.screeingView.sView.frame.origin.x, -116, self.screeingView.sView.frame.size.width, self.sortView.sView.frame.size.height)];
    [self.screeingView setHidden:YES];
    [self.sortView setHidden:YES];
    
    
    if (type!=HIED_SELF_TAG) {
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
}

#pragma mark -ScreeningView懒加载
-(ScreeningView*)screeingView{
    if (_screeingView ==nil)
    {
        _screeingView = [[ScreeningView alloc]initWithFrame:CGRectMake(0, 116, _mainSize.width, _mainSize.height-116)];
      
        [_screeingView setDelegate:self];
        [_screeingView setHidden:YES];
        [self.view insertSubview:_screeingView aboveSubview:self.tableView];
    }
    return _screeingView;
}

#pragma mark -SortView懒加载
-(SortView*)sortView{
    if (_sortView ==nil)
    {
        _sortView = [[SortView alloc]initWithFrame:CGRectMake(0, 116, _mainSize.width, _mainSize.height-116)];
        [_sortView setDelegate:self];
        [_sortView setHidden:YES];
          [self.view insertSubview:_sortView aboveSubview:self.tableView];
    }
     return _sortView;
}

#pragma mark -点击单个商品
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏导航栏
    [_delegate hideSreachBar];
    [_delegate searchBarEndEditing];
    
    Product *product =_productList[indexPath.row];
    ProductDetailViewController *productDetail = [[ProductDetailViewController alloc]init];
    [productDetail setDelegate:self];
    [productDetail setProductID:product.productID];
   
    
    [self.navigationController pushViewController:productDetail animated:YES];
}


#pragma mark -跳转到购物车
-(void)pushToShopCarView
{
    [_delegate hideSreachBar];
    ShopCarViewController *shopCar = [[ShopCarViewController alloc]init];
    [shopCar setDelegate:self];
    [shopCar setUserID:10];//传入用户ID
    [self.navigationController pushViewController:shopCar animated:YES];
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

-(void)showNavigationBarAndStutsBar
{
    [self.navigationController.navigationBar setHidden:NO];
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



@end
