//
//  ShopCarViewController.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarProductModel.h"
#import "ToolsOriginImage.h"
#import "ShopCarProductCell.h"
#import "StoreDefine.h"
#import "SettlementBar.h"
#import "SettlementViewController.h"
#import "CustomHUD.h"
#import "ProductDetailViewController.h"
#import "MainSreachBarDelegate.h"

@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,ShopCarProductCellDelegate,MainSreachBarDelegate>

/**购物车商品列表*/
@property(nonatomic,strong)NSMutableArray *productList;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,weak)SettlementBar *settlementBar;

@property(nonatomic,strong) CustomHUD *hud;

@property(nonatomic,strong)CustomHUD *simpleHud;


@end

@implementation ShopCarViewController

#pragma mark -视图加载后
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
}

#pragma mark -加载数据
-(void)loadData
{
    if (_productList == nil)
    {
        _productList = [NSMutableArray new];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i =0; i<10; i++)
            {
                ShopCarProductModel *product = [ShopCarProductModel new];
                [product setProductID:[NSString stringWithFormat:@"xx20150808000%d",i+1]];
                [product setProductName:@"神器你怕不怕"];
                [product setProductImage:@"product1"];
                [product setProductRealityPrice:(i+1)*15];
                [product setProductStock:15];
                [product setProductDesc:@"dsfasfsdfdgdgdsgdffdsafdsafdsafdsfdsafdsffdsafdsafdsfsda"];
                [product setProductShopCarCout:10];
                [product setIsSelected:NO];
                [product setCellNum:i];
                [_productList addObject:product];
            }
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新数据
            [_tableView reloadData];
            [_hud loadHide];
        });
    });
    
}

#pragma mark -创建视图
-(void)createView
{
    _mainSize = self.view.frame.size;
    
    /**
     导航按钮
     */
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage: [UIImage imageWithCGImage:[[UIImage imageNamed:@"leftBtn"] CGImage] scale:2.0 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setTitle:@"购物车"];		
    
    
    /**
     设置BarTitle的颜色
     */
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    /**
        初始化tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height-60) style:UITableViewStyleGrouped];
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
    [settlementBar setSettlementBarWithSumPrice:12.0 productCount:1];
    [settlementBar.settlementBtn addTarget:self action:@selector(settlementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _settlementBar = settlementBar;
    [self.view addSubview:settlementBar];
    /**
     添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
    
    CustomHUD *hud = [CustomHUD defaultCustomHUDWithFrame:self.view.frame];
    [self.view addSubview:hud];
    [hud startLoad];
    _hud = hud;
    
    
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
    ShopCarProductModel *product =_productList[indexPath.section];
    ShopCarProductCell *cell =[tableView dequeueReusableCellWithIdentifier:@"shopCarProductListCell"];
    if (cell.productImage == nil)
    {
        cell = [[ShopCarProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCarProductListCell"];
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
    //NSLog(@"%ld     %ld",(long)cellRow,(long)count);
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        //sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleHud simpleComplete];
            [self sumPrice];
            ShopCarProductModel *product =_productList[cellRow];
            [product setProductShopCarCout:count];
            NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:cellRow];
            [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
            [self sumPrice];
        });
    });
}

#pragma mark -行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *prodcutDetail = [[ProductDetailViewController alloc]init];
    [prodcutDetail setDelegate:self];
    [self.navigationController pushViewController:prodcutDetail animated:YES];
}

#pragma mark -选择商品
-(void)selectedBtnClick:(UIButton *)btn
{
     ShopCarProductModel *product =_productList[btn.tag];
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
        ShopCarProductModel *productI =_productList[i];
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
        ShopCarProductModel *product =_productList[i];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleHud simpleComplete];
            [_productList removeObject:_productList[btn.tag]];
            [self.tableView reloadData];
            [self sumPrice];
        });
    });

    
  
}


#pragma mark -计算总金额
-(void)sumPrice
{
    double sumPrice = 0.0;
    NSInteger sumCount = 0;
    for (int i =0; i<_productList.count; i++)
    {
         ShopCarProductModel *product =_productList[i];
        if (product.isSelected)//选中的商品
        {
            sumPrice+= product.ProductRealityPrice*product.ProductShopCarCout;
            sumCount+=product.ProductShopCarCout;
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
    NSMutableArray *newProductList = [[NSMutableArray alloc]init];
    for (int i =0; i<_productList.count; i++)
    {
        ShopCarProductModel *product =_productList[i];
        if (product.isSelected)//选中的商品
        {
            [newProductList addObject:product];
        }
    }
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        //sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleHud simpleComplete];
            [settlementView setProductList:newProductList];
            [self.navigationController pushViewController:settlementView animated:YES];
            });
    });

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

-(void)showNavigationBarAndStutsBar
{
    [self.navigationController.navigationBar setHidden:NO];
}


-(void)searchBarEndEditing{}
-(void)showSreachBar{};

#pragma mark -返回上层
-(void)leftItemClick
{
      [_delegate showSreachBar];
    //[_delegate searchBarEndEditing];
    if (_navigationBarDelegate != nil) {
        [_navigationBarDelegate hideNavigationBar];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
