//
//  ProductListTableViewController.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListTableViewController.h"
#import "ProductListMenuView.h"
#import "MJRefresh.h"
#import "ScreeningView.h"
#import "SearchProductDelegate.h"
#import "SortView.h"
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
/**
 *  商品集合
 */
@property(nonatomic,strong)NSMutableArray *productList;
/**
 *  页面大小
 */
@property(nonatomic,assign)CGSize mainSize;
/**
 *  筛选视图
 */
@property(nonatomic,strong)ScreeningView *screeingView;
/**
 *  排序视图
 */
@property(nonatomic,strong)SortView *sortView;
/**
 *  加载动画指示器
 */
@property(nonatomic,strong) CustomHUD *hud;
/**
 *  加入购物车指示器
 */
@property(nonatomic,strong)CustomHUD *addshopHud;
/**
 *  购物车按钮
 */
@property(nonatomic,strong)ShopCarButton *shopCar;
/**
 *  网络请求路径
 */
@property(nonatomic,strong)  NSString *path;

@end

@implementation ProductListTableViewController

#pragma mark -视图加载后
- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建视图
    [self createView];
}


#pragma mark -创建视图
-(void)createView
{
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
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ProductListCell class] forCellReuseIdentifier:@"productListCell"];
    //加载数据
    [self loadData];
    
    //购物车按钮
    self.shopCar = [[ShopCarButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-45, 44, 44)];
    [self.shopCar addTarget:self action:@selector(pushToShopCarView) forControlEvents:UIControlEventTouchUpInside];
    [self.shopCar setShopcarCountWithNum:15];
    [self.view addSubview:self.shopCar];
    
    /*----------------------------------【添加手势】-------------------------------------*/
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];

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
    
    
#pragma mark -下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    [footer setImages:images1 forState:MJRefreshStateRefreshing];
    // 设置文字
    [footer setTitle:@"点击显示更多商品" forState:MJRefreshStateIdle]; //未刷新显示状态
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];//刷新时状态
    [footer setTitle:@"已没有更多商品" forState:MJRefreshStateNoMoreData];//没有更多数据时状态
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    // 设置尾部
    self.tableView.footer = footer;
    
    
    
    //指示器
    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    self.hud = hud;

    
}



#pragma mark -刷新数据
-(void)loadData
{
    //懒加载创建商品集合
    if (self.productList == nil)
    {
        self.productList = [NSMutableArray new];
    }
    //清空商品集合中所有数据
    [self.productList removeAllObjects];
    
    
    //请求数据
    
    //设置当前页与页大小【分页加载】
    self.pageSize = 10;
    self.pageIndex=1;
    //确定路径，参数
    self.path = [NSString stringWithFormat:@"%sStoreCollects/StoreCollectsList?userID=%d&pageIndex=%d&pageSize=%d",SERVER_ROOT_PATH,(int)[User shareUserID],_pageIndex,_pageSize];
    NSURL *url = [NSURL URLWithString:self.path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //NSLog(@"%@",dic);
                //                if ([dic[@"status"] intValue] == 1)//成功
                //                {
                //                    [self.addshopHud simpleComplete];
                //
                //                }
#warning 这里将商品信息显示
                for (int i =0; i<10; i++)
                {
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
                //重置下拉没有数据状态
                [self.tableView.footer resetNoMoreData];
                [self.tableView reloadData];
                [self.hud loadHide];
                [self.tableView.header endRefreshing];
            });
        }
    }];
    
}

#pragma mark -下拉刷新数据
-(void)loadMoreData
{
    
    for (int i =0; i<10; i++)
    {
        Product *product = [Product new];
        [product setProductID:@"SP201508210006"];
        [product setProductName:@"露天大草莓"];
        [product setProductDesc:@"很好吃的露天大🍓"];
        [product setProductImages:@"product1"];
        [product setProductSaleCount:15];
        [product setProductPrice:36.25];
        [product setPuName:@"斤"];
        [product setPsName:@"1.5斤/份"];
        [self.productList addObject:product];
    }
    //更新tableView
    [self.tableView reloadData];
    
    //如果没有新数据的时候
    //设置下拉为没有没有数据状态
    [self.tableView.footer noticeNoMoreData];
   
    //结束刷新
    //[self.tableView.footer endRefreshing];
}


#pragma mark -tableView分组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productList.count;
}


#pragma mark -tableView每行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product =_productList[indexPath.row];
    //tableView重用优化
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell" forIndexPath:indexPath];
    if (cell.productImage == nil)
    {
        cell = [[ProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
    }
    //设置cell上商品显示数据
    [cell setCellDataWith:product];
    
    //设置cell代理
    [cell setDelegate:self];
    return cell;
}



#pragma mark -加入购物车
-(void)addShopCarCWithProductID:(NSString *)productID
{
    //显示指示器
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    /**
     path: StoreCollects/addStoreCollects?productID=%@&userID=%d
     参数：商品编号，用户编号
     */
    //确定请求路径与参数【商品编号，用户编号】
    NSString *path = [NSString stringWithFormat:@"%sStoreCollects/addStoreCollects?productID=%@&userID=%d",SERVER_ROOT_PATH,productID,(int)[User shareUserID]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"status"] intValue] == 1)//成功
                {
                    //指示器显示完成
                    [self.addshopHud simpleComplete];
                }
                else//失败
                {
                    //弹出失败提示
                    [self.addshopHud stopAnimation];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
            });
        }
    }];

}


#pragma mark -显示筛选视图
-(void)showScreeningView
{
    if (!self.sortView.hidden)
    {
        [self showSortView];
    }
    [self.screeingView setHidden:NO];
    CGFloat y = 0;
    if (self.screeingView.sView.frame.origin.y==0)
    {
        y=SCREENINGVIEW_HIDE_Y;
    }
     //显示隐藏筛选的view动画
    [UIView animateWithDuration:ANIMATION_TIME_QUICK animations:^{
       [self.screeingView.sView setFrame:CGRectMake(self.screeingView.sView.frame.origin.x, y, self.screeingView.sView .frame.size.width, self.screeingView.sView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (y==SCREENINGVIEW_HIDE_Y) {
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
    [self.sortView setHidden:NO];
    CGFloat y=0;
    if (self.sortView.sView.frame.origin.y==0)
    {
        y=SCREENINGVIEW_HIDE_Y;
    }
    //显示隐藏排序view的动画
    [UIView animateWithDuration:ANIMATION_TIME_QUICK animations:^
    {
         [self.sortView.sView setFrame:CGRectMake(self.sortView.sView.frame.origin.x, y, self.sortView.sView .frame.size.width, self.sortView.sView.frame.size.height)];
    }
    completion:^(BOOL finished)
    {
        if (y==SCREENINGVIEW_HIDE_Y) {
            [_sortView setHidden:YES];
        }
    }];
}

#pragma mark -排序，筛选，我的收藏
-(void)searchProductListWithType:(NSInteger)type
{
    //隐藏排序，筛选View
    [self.sortView.sView setFrame:CGRectMake(self.sortView.sView.frame.origin.x, -116, self.sortView.sView.frame.size.width, self.sortView.sView.frame.size.height)];
    [self.screeingView.sView setFrame:CGRectMake(self.screeingView.sView.frame.origin.x, -116, self.screeingView.sView.frame.size.width, self.sortView.sView.frame.size.height)];
    [self.screeingView setHidden:YES];
    [self.sortView setHidden:YES];
    
    //如果不是点击了空白处
    if (type!=HIED_SELF_TAG)
    {
        [self.addshopHud setHidden:NO];
        [self.addshopHud startSimpleLoad];
        
#warning 设置排序，筛选的值
        
        
        //加载数据
        [self loadData];
    }
}

#pragma mark -ScreeningView懒加载
-(ScreeningView*)screeingView
{
    if (_screeingView ==nil)
    {
        //初始化位置，大小
        _screeingView = [[ScreeningView alloc]initWithFrame:CGRectMake(0, SCREENINGVIEW_BEGIN_Y, _mainSize.width, _mainSize.height-SCREENINGVIEW_BEGIN_Y)];
      
        [_screeingView setDelegate:self];
        [_screeingView setHidden:YES];
        //设置view的位置
        [self.view insertSubview:_screeingView aboveSubview:self.tableView];
    }
    return _screeingView;
}

#pragma mark -SortView懒加载
-(SortView*)sortView
{
    if (_sortView ==nil)
    {
        //初始化位置大小
        _sortView = [[SortView alloc]initWithFrame:CGRectMake(0, SCREENINGVIEW_BEGIN_Y, _mainSize.width, _mainSize.height-SCREENINGVIEW_BEGIN_Y)];
        [_sortView setDelegate:self];
        [_sortView setHidden:YES];
        //设置view的位置
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
    //传入商品编号
    [productDetail setProductID:product.productID];
    //push页面
    [self.navigationController pushViewController:productDetail animated:YES];
}


#pragma mark -跳转到购物车
-(void)pushToShopCarView
{
    [_delegate hideSreachBar];
    ShopCarViewController *shopCar = [[ShopCarViewController alloc]init];
    [shopCar setDelegate:self];
    //传入用户编号
    [shopCar setUserID:10];
    //push页面
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


#pragma mark -返回上层
-(void)leftItemClick
{
    //取消主页sreachBar的编辑状态
    [_delegate searchBarEndEditing];
    //pop页面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarEndEditing
{
    //取消主页（delegate）sreachBar的编辑状态
    [_delegate searchBarEndEditing];
}

-(void)showSreachBar
{
    //显示主页（delegate）的sreachBar
    [_delegate showSreachBar];
}

-(void)showNavigationBarAndStutsBar
{
    //显示主页（delegate）的navigationBar
    [self.navigationController.navigationBar setHidden:NO];
}




@end





#pragma mark -以下为程序神秘加成部分
/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

/**
 * 　　　　　　　　┏┓　　　┏┓
 * 　　　　　　　┏┛┻━━━┛┻┓
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃　　　━　　　┃
 * 　　　　　　　┃　＞　　　＜　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃    ...　⌒　...　 ┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┗━┓　　　┏━┛
 * 　　　　　　　　　┃　　　┃　Code is far away from bug with the animal protecting
 * 　　　　　　　　　┃　　　┃   神兽保佑,代码无bug
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┗━━━┓
 * 　　　　　　　　　┃　　　　　　　┣┓
 * 　　　　　　　　　┃　　　　　　　┏┛
 * 　　　　　　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　　　　　　┃┫┫　┃┫┫
 * 　　　　　　　　　　┗┻┛　┗┻┛
 */

/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
