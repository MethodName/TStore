//
//  ProductDetailViewController.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductImagesScrollView.h"
#import "ProductDetailCell.h"
#import "ShopBar.h"
#import "ShopCarViewController.h"
#import "IconTitleButton.h"
#import "CustomHUD.h"
#import "ProductDetailintroductionViewController.h"
#import "SettlementViewController.h"
#import "ShopCarProductModel.h"
#import "StoreDefine.h"
#import "Product.h"
#import "User.h"



@interface ProductDetailViewController()<UITableViewDataSource,UITableViewDelegate,ShopBarDelegate,UIScrollViewDelegate,ShopCarViewControllerDelegate,MainSreachBarDelegate>

@property(nonatomic,strong)UITableView *tableView;

/**页面大小*/
@property(nonatomic,assign)CGSize mainSize;

/**每列名字*/
@property(nonatomic,strong)NSArray *nameArray;


@property(nonatomic,strong)Product *product;

@property(nonatomic,strong)ProductImagesScrollView *imagesScrollView;

@property(nonatomic,strong)CustomHUD *addshopHud;

@property(nonatomic,weak)UIPageControl *page;

@property(nonatomic,assign)BOOL isCollect;

@end

@implementation ProductDetailViewController

#pragma mark -视图加载后
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self createView];
    
}

#pragma mark -加载数据
-(void)loadData
{
     [self userIsCollect];
    /*
     根据商品ID获取商品信息 :StoreProduct/getStoreProductByID   
     参数:id
     */
    NSString *path = [NSString stringWithFormat:@"%s%@=%@",SERVER_ROOT_PATH,@"StoreProduct/getStoreProductByID?id",_productID];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
   [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       if (connectionError == nil)
       {
           //将结果转成字典集合
             NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           //NSLog(@"%@",json);
           _product= [Product new];
           [_product setValuesForKeysWithDictionary:dic];
           //分割出图片的数组
           NSArray *imageArr = [_product.productImages  componentsSeparatedByString:@","];
           //主线程更新表格数据
           dispatch_async(dispatch_get_main_queue(), ^{
                //设置pageControl的个数
               [_page setNumberOfPages:imageArr.count];
               //设置图片
                [_imagesScrollView setImages:imageArr];
               [self.tableView reloadData];
           });
           
       }
   }];
}

#pragma mark -检索用户是否收藏了当前商品
-(void)userIsCollect
{
    /*
     根据商品ID获取商品信息 :StoreCollects/checkCollectStatus
     参数:id
     */
    NSString *path = [NSString stringWithFormat:@"%s%@%@%@%d",SERVER_ROOT_PATH,@"StoreCollects/checkCollectStatus?productID=",_productID,@"&userID=",(int)[User shareUserID]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _isCollect  = (BOOL)[dic[@"status"] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    }];

}



#pragma mark -创建视图
-(void)createView
{
    //隐藏状态栏
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _mainSize = self.view.frame.size;
    
    /**
        导航按钮
     */
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
//    [leftBtn setTintColor:[UIColor whiteColor]];
//    [self.navigationItem setLeftBarButtonItem:leftBtn];
//    [self.navigationItem setTitle:@"商品详情"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    [leftBtn setImage: [UIImage imageNamed:@"leftBtn.png"] forState:0];
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**
       设置BarTitle的颜色
     */
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height+200) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSectionFooterHeight:2.0];
    [_tableView setSectionHeaderHeight:2.0];
   
     [self.view addSubview:_tableView];
    
    /**
        注册自定义Cell
     */
    [_tableView registerClass:[ProductDetailCell class] forCellReuseIdentifier:@"productDetailCell"];
    
    /**
     商品图片
     */
    ProductImagesScrollView *imagesScrollView = [[ProductImagesScrollView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.width*0.8)];
    [_tableView setTableHeaderView:imagesScrollView];
    [imagesScrollView setDelegate:self];
    _imagesScrollView = imagesScrollView;
    
    
    /**
     PageControl
     */
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(imagesScrollView.frame.size.width-100, imagesScrollView.frame.size.height-20, 100,20)];
    [page setCurrentPage:0];
    _page = page;
    [self.view addSubview:page];
    
    /**
        商品属性
     */
    _nameArray =@[@"商品：",@"价格：",@"运费：免运费",@"商品详细介绍",@"评价/晒单(0)"];
    
    
    /**
        购物栏
     */
    ShopBar *shopBar = [[ShopBar alloc]initWithFrame:CGRectMake(0, _mainSize.height-44, _mainSize.width, 44)];
    [self.view addSubview:shopBar];
    [shopBar setDelegate:self];
    [shopBar setShopCatCountNum:6];
    
     [self.view addSubview:leftBtn];
    
    /**
        添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
    
}

#pragma mark -tableView组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //每组行数第1组：3行   第二组：2行
    NSArray *arr = @[@(3),@(2)];
    return [arr[section] integerValue];
}


#pragma mark -tableView分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


#pragma mark -tableView行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailCell * cell = [[ProductDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailCell"];
    [cell.haoPing setHidden:YES];
    [cell.zhongPing setHidden:YES];
    [cell.chaPing setHidden:YES];
    if (indexPath.section == 0)
    {
       [cell.name setText:_nameArray[indexPath.row]];
        if (indexPath.row==0) {
            /**
             *  商品名字
             */
            [cell.productName setText:_product.productName];
            [cell.collectBtn setHidden:NO];
          
            /**
             *  判断商品是否被收藏
             */
            if (_isCollect)
            {
                [cell.collectBtn.iconImageView setImage:[UIImage imageNamed:@"collect_full"]];
            }
            else
            {
               [cell.collectBtn.iconImageView setImage:[UIImage imageNamed:@"collect_press"]];
            }
            [cell.chaPing setHidden:YES];
            //为收藏按钮添加点击事件
            [cell.collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row==1)
        {
            //显示价格
            [cell.productPrice setText:[NSString stringWithFormat:@"￥%0.2lf",_product.productPrice]];
        }
    }
    else if(indexPath.section==1)
    {
    
        [cell.name setText:_nameArray[indexPath.row+3]];
        if (indexPath.row==0)
        {
            //去商品详情页面
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1)
        {
            /**
             *  评论个数
             */
            [cell.haoPing setHidden:NO];
             [cell.zhongPing setHidden:NO];
             [cell.chaPing setHidden:NO];
            
            [cell.haoPing setTitle:[NSString stringWithFormat:@"好评(%d)",0] forState:0];
             [cell.zhongPing setTitle:[NSString stringWithFormat:@"中评(%d)",0] forState:0];
             [cell.chaPing setTitle:[NSString stringWithFormat:@"差评(%d)",0] forState:0];
        }
    }
    //表格行点击样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


/**
 *  shopBar   delegate
 */
#pragma mark -进入到购物车页面
-(void)pushToShopCarView
{
    [self.navigationController.navigationBar setHidden:NO];
    ShopCarViewController *shopCar = [[ShopCarViewController alloc]init];
    [shopCar setNavigationBarDelegate:self];
    [shopCar setUserID:10];//传入用户ID
    [self.navigationController pushViewController:shopCar animated:YES];
}

/**
 *  添加购物车
 */
#pragma mark -添加商品到购物车
-(void)addShopCar
{
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    
    NSString *path = [NSString stringWithFormat:@"%s%@%@%@%d",SERVER_ROOT_PATH,@"StoreCollects/addStoreCollects?productID=",_productID,@"&userID=",(int)[User shareUserID]];
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

#pragma mark -收藏
-(void)collectBtnClick:(IconTitleButton *)btn
{
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    //添加收藏路径
    NSString * path =@"StoreCollects/addStoreCollects?productID=";
    //如果是已经收藏的，就使用删除收藏的路径
    if (_isCollect)
    {
        path =@"StoreCollects/delStoreCollects?productID=";
    }
    
    path = [NSString stringWithFormat:@"%s%@%@%@%d",SERVER_ROOT_PATH,path,_productID,@"&userID=",(int)[User shareUserID]];
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
                    _isCollect = !_isCollect;
                    //更新UI
                    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
                    //关闭指示器
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

#pragma mark -tableView行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //商品详细介绍
    if (indexPath.section == 1&&indexPath.row ==0)
    {
        ProductDetailintroductionViewController *proDetail =[[ProductDetailintroductionViewController alloc]init];
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:proDetail animated:YES];
    }
}



/**
 *  购买商品
 */
#pragma mark -立即购买
-(void)buyProduct
{
    SettlementViewController *settlementView = [[SettlementViewController alloc]init];
    NSMutableArray *newProductList = [[NSMutableArray alloc]init];
    
    ShopCarProductModel *product =[ShopCarProductModel new];
    [product setProductID:_product.productID];
    //[product setProductImage:_product.ProductImages[0]];
    [product setProductDesc:_product.productDesc];
    [product setProductName:_product.productName];
    [product setProductRealityPrice:_product.productRealityPrice];
    [product setProductShopCarCout:1];
    [newProductList addObject:product];
    
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        //sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.navigationBar setHidden:NO];
            [self.addshopHud simpleComplete];
            [settlementView setProductList:newProductList];
            [settlementView setDelegate:self];
            [self.navigationController pushViewController:settlementView animated:YES];
        });
    });
}


#pragma mark -图片ScrollView滑动代理事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [_page setCurrentPage:index];
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
    [_delegate showNavigationBarAndStutsBar];
    [_delegate showSreachBar];
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate searchBarEndEditing];
  
}


/**
 *  隐藏导航栏和状态栏
 */
-(void)hideNavigationBar
{
    [self.navigationController.navigationBar setHidden:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}



@end
