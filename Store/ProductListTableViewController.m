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

@property(nonatomic,strong)NSMutableDictionary *productImageList;
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

/**
 *  商品数据类型数据类型
 */
@property(nonatomic,assign)NSInteger dataType;

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
    
    //筛选
    [menuView.screening addTarget:self action:@selector(showScreeningView) forControlEvents:UIControlEventTouchUpInside];
    
    //排序
    [menuView.sort addTarget:self action:@selector(showSortView) forControlEvents:UIControlEventTouchUpInside];
    
    //我的收藏
    [menuView.collection addTarget: self action:@selector(showUserClllection) forControlEvents:UIControlEventTouchUpInside];
    
    
    
#pragma mark -tableView初始化
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, _mainSize.width, _mainSize.height-120) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setRowHeight:TABLE_CELL_HEIGHT];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ProductListCell class] forCellReuseIdentifier:@"productListCell"];
   
    
    //购物车按钮
    self.shopCar = [[ShopCarButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-45, 44, 44)];
    [self.shopCar addTarget:self action:@selector(pushToShopCarView) forControlEvents:UIControlEventTouchUpInside];
    [self.shopCar setShopcarCountWithNum:15];
    [self.view addSubview:self.shopCar];
    
    /*----------------------------------【添加手势】-------------------------------------*/
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];

#pragma mark -上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownLoadData)];
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
    
    
#pragma mark -上拉加载更多数据
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
    
    //加载数据
    //设置当前页与页大小【分页加载】
    self.pageSize = 10;
    self.pageIndex=1;
    //物业编号
    self.pmcID = 0;
    //默认排序字段
    self.order = @"productID";
    //降序，升序
    self.descend = 0;
    if (_productName == nil)
    {
        _productName = @"";
    }
    //默认数据类型
    _dataType = PRODUCTLIST_DATA_TYPE1;
    
   
    
    //NSLog(@"%@",self.path);
    //懒加载创建商品集合
    if (self.productList == nil)
    {
        self.productList = [NSMutableArray new];
    }
    
    [self pullDownLoadData];
}



#pragma mark -刷新数据
-(void)loadData
{
    
    if (_dataType == PRODUCTLIST_DATA_TYPE2) {
          self.path = [NSString stringWithFormat:@"%sStoreCollects/StoreCollectsList?userID=%d&pageIndex=%d&pageSize=%d",SERVER_ROOT_PATH,(int)[User shareUserID],_pageIndex,_pageSize];
    }
    else if (_dataType ==PRODUCTLIST_DATA_TYPE1)
    {
            //请求数据
            //确定路径，参数
            /*
             path:
             StoreProduct/findStoreProductList
             args:
             productName=商品名称（模糊查询）
             ptID=类型ID（0或不写查全部）
             pmcID=物业ID（0或不写查全部）
             order=排序的字段
             desc=（1降序 0升序）
             pageIndex=第几页
             pageSize=每页条数
             */
            self.path = [NSString stringWithFormat:@"%sStoreProduct/findStoreProductList?ptID=%d&pageIndex=%d&pageSize=%d&productName=%@&pmcID=%d&order=%@&desc=%d",
                         SERVER_ROOT_PATH,
                         (int)_ptID,
                         _pageIndex,
                         _pageSize,
                         _productName,
                         (int)_pmcID,
                         _order,
                         (int)_descend];
    }
    //NSLog(@"%@",self.path);
    
    NSURL *url = [NSURL URLWithString:self.path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"%@",dic);
            //收藏商品
            NSArray *collects = dic[@"storeProducts"];//storeProducts

            for (int i =0; i<collects.count; i++)
            {
                //添加商品
                Product *product = [Product new];
                [product setValuesForKeysWithDictionary:collects[i]];
                [_productList addObject:product];
            }
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.tableView reloadData];
                [self.hud loadHide];
                [self.addshopHud simpleComplete];
                [self.tableView.header endRefreshing];
                //如果没有更多数据的时候
                if(collects.count==0)
                {
                    //重置下拉没有数据状态
                    [self.tableView.footer noticeNoMoreData];
                }
                else
                {
                    //重置下拉没有数据状态
                    [self.tableView.footer resetNoMoreData];
                }

            });
        }
    }];
}



#pragma mark -下拉加载数据
-(void)pullDownLoadData
{
    //清空商品集合中所有数据
    [_productImageList removeAllObjects];
    [_productList removeAllObjects];

    
    
     //上拉加载数据，当前页为1
    _pageIndex=1;
    [self loadData];
}

#pragma mark -下拉刷新数据
-(void)loadMoreData
{
    //下拉加载更多数据，当前页++
    [_productList removeLastObject];
    [_productImageList removeAllObjects];
    _pageIndex ++;
    [self loadData];
    
}


#pragma mark -收藏商品
-(void)showUserClllection
{
    //显示指示器
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    _dataType = PRODUCTLIST_DATA_TYPE2;
    //清空商品集合中所有数据
    [_productImageList removeAllObjects];
    [_productList removeAllObjects];

    //加载数据
    [self loadData];
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
    if (cell == nil)
    {
        cell = [[ProductListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
    }
    //设置cell上商品显示数据
    [cell setCellDataWith:product];
    
    if (_productImageList == nil) {
        _productImageList = [NSMutableDictionary new];
    }
    //如果存放图片的集合中没有当前商品的图片
    if (_productImageList[product.productID]==nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //将图片路径分割出来
            NSArray *imageArr = [product.productImages  componentsSeparatedByString:@","];
            //确定图片的路径
            NSURL *photourl = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@",SERVER_IMAGES_ROOT_PATH,imageArr[0]]];
            //通过网络url获取uiimage
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
            [_productImageList setObject:img forKey:product.productID];
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI
                [cell.productImage setImage:img];
            });
        });
    }
    else//图片集合中有当前商品的图片，直接使用集合中的图片，不去加载网络资源
    {
         [cell.productImage setImage:_productImageList[product.productID]];
    }
    
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
        

        //修改加载数据类型为正常类型
        _dataType = PRODUCTLIST_DATA_TYPE1;
        //
        switch (type)
        {
            case SORT_SCALECOUNT_TAG:
                _order = @SORT_SCALECOUNT;
                break;
            case SORT_PRICE_TAG:
                _order = @SORT_PRICE;
                break;
            case SORT_UPDATE_TAG:
                _order = @SORT_UPDATE;
                break;
            default:
                break;
        }
        [_productImageList removeAllObjects];
        [_productList removeAllObjects];
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
