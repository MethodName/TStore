//
//  ShopCarViewController.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ToolsOriginImage.h"
#import "ShopCarProductCell.h"
#import "StoreDefine.h"
#import "SettlementBar.h"
#import "SettlementViewController.h"
#import "CustomHUD.h"
#import "ProductDetailViewController.h"
#import "MainSreachBarDelegate.h"
#import "StoreNavigationBar.h"
#import "User.h"
#import "ProductShopCar.h"
#import "MJRefresh.h"

@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,ShopCarProductCellDelegate,StoreNavigationBarDeleagte>

/**购物车商品列表*/
@property(atomic,strong)NSMutableArray *productList;

/**
 *  存放图片的集合
 */
@property(atomic,strong)NSMutableDictionary *productImageList;
/**
 *  显示商品的表格
 */
@property(atomic,strong)UITableView *tableView;
/**
 *  屏幕大小
 */
@property(nonatomic,assign)CGSize mainSize;
/**
 *  结算栏
 */
@property(nonatomic,weak)SettlementBar *settlementBar;
/**
 *  加载指示器
 */
@property(nonatomic,strong) CustomHUD *hud;
/**
 *  简单指示器
 */
@property(nonatomic,strong)CustomHUD *simpleHud;
/**
 *  请求数据当前页
 */
@property(nonatomic,assign)NSInteger pageIndex;
/**
 *  请求数据页大小
 */
@property(nonatomic,assign)NSInteger pageSize;
/**
 *  是否在刷新状态
 */
@property(atomic,assign)BOOL isRefresh;


@end

@implementation ShopCarViewController

#pragma mark -视图加载后
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createView];
    
    _pageSize = 10;
    _pageIndex = 1;
     _productList = [NSMutableArray new];
      [self pullDownLoadData];
    _isRefresh  = NO;
}



#pragma mark -创建视图
-(void)createView
{
    _mainSize = self.view.frame.size;
    
    
    [self.navigationController setNavigationBarHidden:YES];
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.title setText:@"购物车"];
    //设置右边按钮图片
    [navigationBar.rightBtn setImage:[UIImage imageNamed:@"rightMuen"] forState:0];
    [navigationBar.rightBtn setImage:[UIImage imageNamed:@"rightMuen"] forState:1];
    
    
    
    [self.view addSubview:navigationBar];
    
    /**
     初始化tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, _mainSize.width, _mainSize.height-124) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:_mainSize.width*0.5];
    [_tableView setSectionHeaderHeight:3];
    [_tableView setSectionFooterHeight:3];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 1)]];
    [self.view addSubview:_tableView];
    
    /**
     注册自定义Cell
     */
    [self.tableView registerClass:[ShopCarProductCell class] forCellReuseIdentifier:@"shopCarProductListCell"];
    
    /**
     结算栏
     */
    SettlementBar *settlementBar = [[SettlementBar alloc]initWithFrame:CGRectMake(0, _mainSize.height-60, _mainSize.width, 60)];
    [settlementBar.selectAllBtn setTag:0];
    [settlementBar.selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [settlementBar setSettlementBarWithSumPrice:0.0 productCount:0];
    [settlementBar.settlementBtn addTarget:self action:@selector(settlementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _settlementBar = settlementBar;
    [self.view addSubview:settlementBar];
    
    
#pragma mark -下拉刷新
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

    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    /**
     添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
    
    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    _hud = hud;
    
    
}

#pragma mark -下拉加载数据
-(void)pullDownLoadData
{
    
   
    _isRefresh = YES;
    //清空商品集合中所有数据
   
    //上拉加载数据，当前页为1
    _pageIndex=1;
    [self loadData];
}

#pragma mark -上拉加载更多数据
-(void)loadMoreData
{
   
    _isRefresh = NO;
    //下拉加载更多数据，当前页++
    _pageIndex ++;
    [self loadData];}


#pragma mark -加载数据
-(void)loadData
{

    /**
        //StoreShopCar/findShopCarByUserID?=1&pageIndex=1&pageSize=10
        userID:用户ID
        pageIndex:当前页
        pageSize:也大小
     */
  
    NSString *path = [NSString stringWithFormat:@"%sStoreShopCar/findShopCarByUserID?userID=%d&pageIndex=%d&pageSize=%d",SERVER_ROOT_PATH,(int)[User shareUserID],(int)_pageIndex,(int)_pageSize];
    
   //NSLog(@"%@",path);
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //NSLog(@"%@",data);
            //将结果转成字典集合
            NSArray *array =(NSArray *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (_isRefresh) {
                 [_productList removeAllObjects];
            }
            for (int i =0; i<array.count; i++)
            {
                //添加商品
                ProductShopCar *product = [ProductShopCar new];
                [product setValuesForKeysWithDictionary:array[i]];
                [_productList addObject:product];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                //NSLog(@"更新UI");
                [self.tableView reloadData];
              
                [_tableView.header endRefreshing];
                
                //如果没有更多数据的时候
                if(array.count<10)
                {
                    //重置下拉没有数据状态
                    [self.tableView.footer noticeNoMoreData];
                }
                else if(array.count==10)
                {
                    //重置下拉没有数据状态
                    [self.tableView.footer resetNoMoreData];
                }
                [_hud loadHide];
            });
        }else{
              [_hud loadHide];
            NSLog(@"%@",connectionError.debugDescription);
        }
    }];
    
}



#pragma mark -设置表格每组行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark -设置表格组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _productList.count;
}


#pragma mark -tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductShopCar *product =_productList[indexPath.section];
    
    ShopCarProductCell *cell =[tableView dequeueReusableCellWithIdentifier:@"shopCarProductListCell"];
    if (cell.productImage == nil)
    {
        cell = [[ShopCarProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCarProductListCell"];
    }
    
    if (_productImageList == nil)
    {
        _productImageList = [NSMutableDictionary new];
    }
    //如果存放图片的集合中没有当前商品的图片
    if (_productImageList[product.productID]==nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            //将图片路径分割出来
            NSArray *imageArr = [product.productImages  componentsSeparatedByString:@","];
            //确定图片的路径
            NSURL *photourl = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@",SERVER_IMAGES_ROOT_PATH,imageArr[0]]];
            //通过网络url获取uiimage
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
            if (img==nil)
            {
                [_productImageList setObject:[UIImage imageNamed:@"placeholderImage"] forKey:product.productID];
            }
            else
            {
                [_productImageList setObject:img forKey:product.productID];
            }

            dispatch_async(dispatch_get_main_queue(), ^
            {
                //更新UI
                [cell.productImage setImage:img];
            });
        });
    }
    else//图片集合中有当前商品的图片，直接使用集合中的图片，不去加载网络资源
    {
        [cell.productImage setImage:_productImageList[product.productID]];
    }

    
    [cell.addBtn setTag:indexPath.section];
    [cell.subBtn setTag:indexPath.section];
    [cell setShopCarListItemShopCarProductModel:product];
     //选择按钮
    [cell.selectedBtn setTag:indexPath.section];
    [cell.selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //删除按钮
    [cell.deleteBtn setTag:indexPath.section];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //选择状态
    if (product.isSelected)
    {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
    }
    else
    {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
    }
    [cell setDelegate:self];
    return cell;
}

/*
 购物车：改变购物车视图中的数据的时候，对应先修改购物车的的数组重点的数据
 避免重复刷新的时候出现数据不对的问题
 
 */

#pragma mark -改变商品数量代理
-(void)productCountChage:(NSInteger)count CellRow:(NSInteger)cellRow
{
    
    /**
     
     StoreShopCar/delStoreShopCar?userID=1&productID=SP201508210004
     
     StoreShopCar/addStoreShopCar?userID=1&productID=SP201508210004
     
     StoreShopCar/updateStoreShopCar?userID=1&productID=SP201508210004&bayCount=100

     
     */
    //NSLog(@"%ld     %ld",(long)cellRow,(long)count);
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    
    
    ProductShopCar *product =_productList[cellRow];
    NSString *path = [NSString stringWithFormat:@"%sStoreShopCar/updateStoreShopCar?productID=%@&userID=%d&bayCount=%d",SERVER_ROOT_PATH,product.productID,(int)[User shareUserID],(int)count];
  
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
        {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic[@"status"] intValue] == 1)//成功
                {
                    [product setBayCount:count];
                    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:cellRow];
                    [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
                    //更新结算的金额
                    [self sumPrice];
                    //指示器显示完成
                    [self.simpleHud simpleComplete];
                }
                else//失败
                {
                    //弹出失败提示
                    [self.simpleHud stopAnimation];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
            });
        }
    }];
    
    
}

#pragma mark -行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *prodcutDetail = [[ProductDetailViewController alloc]init];
    // 传入商品ID
     ProductShopCar *product =_productList[indexPath.section];
    [prodcutDetail setProductID:product.productID];
    //push页面
    [self.navigationController pushViewController:prodcutDetail animated:YES];
}

#pragma mark -选择商品
-(void)selectedBtnClick:(UIButton *)btn
{
     ProductShopCar *product =_productList[btn.tag];
    if (!product.isSelected)
    {
        [btn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
        [product setIsSelected:YES];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
        [product setIsSelected:NO];
    }
    //全选按钮自动选择和取消
    int count = 0;
    for (int i =0; i<_productList.count; i++)
    {
        ProductShopCar *productI =_productList[i];
        if (!productI.isSelected)
        {
            [_settlementBar.selectAllBtn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
            [_settlementBar.selectAllBtn setTag:0];
            break;
        }else{
            count++;
        }
    }
    //NSLog(@"%d",count);全选按钮自动选中
    if (count==_productList.count)
    {
         [_settlementBar.selectAllBtn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
         [_settlementBar.selectAllBtn setTag:1];
    }
    [self sumPrice];
}

#pragma mark -全选
-(void)selectAllBtnClick:(UIButton *)btn
{
    if (!btn.tag)
    {
         [btn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
    }
    else
    {
         [btn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
    }
      for (int i =0; i<_productList.count; i++)
    {
        ProductShopCar *product =_productList[i];
        [product setIsSelected:!btn.tag];
    }
    [btn setTag:!btn.tag];
    [self sumPrice];
    [self.tableView reloadData];
}


#pragma mark -删除商品
-(void)deleteBtnClick:(UIButton *)btn
{
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    
    
    ProductShopCar *product =_productList[btn.tag];
    NSString *path = [NSString stringWithFormat:@"%sStoreShopCar/delStoreShopCar?productID=%@&userID=%d&",SERVER_ROOT_PATH,product.productID,(int)[User shareUserID]];
   
    
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError == nil)
         {
             //将结果转成字典集合
             NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 if ([dic[@"status"] intValue] == 1)//成功
                 {
                     //删除集合中的商品
                     [_productList removeObject:product];
                     //更新表格
                     [self.tableView reloadData];
                     //更新结算的金额
                     [self sumPrice];
                     //指示器显示完成
                     [self.simpleHud simpleComplete];
                 }
                 else//失败
                 {
                     //弹出失败提示
                     [self.simpleHud stopAnimation];
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alertView show];
                 }
             });
         }
     }];
    

    
  
}


-(void)refreshCellWithRow:(NSInteger)row
{
    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:row];
    [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -计算总金额
-(void)sumPrice
{
    double sumPrice = 0.0;
    NSInteger sumCount = 0;
    for (int i =0; i<_productList.count; i++)
    {
         ProductShopCar *product =_productList[i];
        if (product.isSelected)//选中的商品
        {
            sumPrice+= product.productRealityPrice*product.bayCount;
            sumCount+=product.bayCount;
        }
    }
    [_settlementBar.sumPrice setText:[NSString stringWithFormat:@"￥%0.2lf",sumPrice]];
    [_settlementBar.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%d)",(int)sumCount] forState:0];
    if (sumCount>0)
    {
        [_settlementBar.settlementBtn setBackgroundColor:[UIColor orangeColor]];
        [_settlementBar.settlementBtn setEnabled:YES];
    }else{
        [_settlementBar.settlementBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_settlementBar.settlementBtn setEnabled:NO];
    }
    
}

#pragma mark -结算
-(void)settlementBtnClick
{
    SettlementViewController *settlementView = [[SettlementViewController alloc]init];
    settlementView.settlementType = 2;
    NSMutableArray *newProductList = [[NSMutableArray alloc]init];
    for (int i =0; i<_productList.count; i++)
    {
        ProductShopCar *product =_productList[i];
        if (product.isSelected)//选中的商品
        {
            [newProductList addObject:product];
        }
    }
    
    [settlementView setProductList:newProductList];
    [settlementView setImageList:_productImageList];
    
    [self.navigationController pushViewController:settlementView animated:YES];
    
}


#pragma mark -CustomHUD 懒加载
-(CustomHUD *)simpleHud
{
    if (_simpleHud == nil) {
        _simpleHud= [CustomHUD defaultCustomHUDSimpleWithFrame:self.view.frame];
        [self.view addSubview:_simpleHud];
        [_simpleHud setHidden:YES];
    }
    return _simpleHud;
}


#pragma mark -返回上层
-(void)leftClick
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick{}



@end
