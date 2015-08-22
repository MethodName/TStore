//
//  ProductDetailViewController.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ToolsOriginImage.h"
#import "ProductImagesScrollView.h"
#import "ProductDetailCell.h"
#import "StoreProductsModel.h"
#import "ShopBar.h"
#import "ShopCarViewController.h"
#import "IconTitleButton.h"
#import "CustomHUD.h"
#import "ProductDetailintroductionViewController.h"


@interface ProductDetailViewController()<UITableViewDataSource,UITableViewDelegate,ShopBarDelegate,UIScrollViewDelegate,ShopCarViewControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;

/**页面大小*/
@property(nonatomic,assign)CGSize mainSize;

/**每列名字*/
@property(nonatomic,strong)NSArray *nameArray;

/**商品对象*/
@property(nonatomic,strong)StoreProductsModel *product;

@property(nonatomic,strong)CustomHUD *addshopHud;

@property(nonatomic,weak)UIPageControl *page;

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
    _product = [StoreProductsModel new];
    [_product setProductID:@"xx201508080001"];
    [_product setProductName:@"大草莓"];
    [_product setProductPrice:15.2];
   
    NSMutableArray *imgArray = [NSMutableArray new];
    for (int i =0; i<4; i++) {
        [imgArray addObject:@"ad"];
    }
    [_product setProductImages:imgArray];
    
}

#pragma mark -创建视图
-(void)createView
{
    
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
    [imagesScrollView setImages:_product.ProductImages];
    
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(imagesScrollView.frame.size.width-100, imagesScrollView.frame.size.height-20, 100,20)];
    [page setNumberOfPages:4];
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
            [cell.productName setText:_product.ProductName];
            [cell.collectBtn setHidden:NO];
            [cell.collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row==1){
            [cell.productPrice setText:[NSString stringWithFormat:@"￥%0.2lf",_product.ProductPrice]];
        }
    }
    else if(indexPath.section==1)
    {
    
        [cell.name setText:_nameArray[indexPath.row+3]];
        if (indexPath.row==0)
        {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1)
        {
            [cell.haoPing setHidden:NO];
             [cell.zhongPing setHidden:NO];
             [cell.chaPing setHidden:NO];
            
            [cell.haoPing setTitle:[NSString stringWithFormat:@"好评(%d)",0] forState:0];
             [cell.zhongPing setTitle:[NSString stringWithFormat:@"中评(%d)",0] forState:0];
             [cell.chaPing setTitle:[NSString stringWithFormat:@"差评(%d)",0] forState:0];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


/**
 *  shopBar   delegate
 */
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
-(void)addShopCar
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

#pragma mark -收藏
-(void)collectBtnClick:(IconTitleButton *)btn
{
    [self.addshopHud setHidden:NO];
    [self.addshopHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.addshopHud simpleComplete];
            if ( btn.tag==0)
            {
                [btn.iconImageView setImage:[UIImage imageNamed:@"collect_full"]];
                [btn setTag:1];
            }
            else
            {
                [btn.iconImageView setImage:[UIImage imageNamed:@"collect_press"]];
                [btn setTag:0];
            }

        });
    });

    
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
-(void)buyProduct
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


-(void)hideNavigationBar{
    [self.navigationController.navigationBar setHidden:YES];
}



#pragma mark -返回上层
-(void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate showSreachBar];
    [_delegate searchBarEndEditing];
    [_delegate showNavigationBarAndStutsBar];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}



@end
