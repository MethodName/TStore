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

@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate>

/**购物车商品列表*/
@property(nonatomic,strong)NSMutableArray *productList;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;


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
                [product setProductShopCarCout:1];
                [product setIsSelected:NO];
                [product setCellNum:i];
                [_productList addObject:product];
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新数据
            [_tableView reloadData];
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
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
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
    [_tableView setRowHeight:144];
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
    
    [self.view addSubview:settlementBar];
    /**
     添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
    
    
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
    if (cell.productImage == nil) {
        cell = [[ShopCarProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopCarProductListCell"];
    }
    [cell setShopCarListItemShopCarProductModel:product];
    [cell.selectedBtn setTag:indexPath.section];
    [cell.selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //选择状态
    if (product.isSelected)
    {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
    }
    else
    {
        [cell.selectedBtn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
    }

    
    
    return cell;
}

/*
 购物车：改变购物车视图中的数据的时候，对应先修改购物车的的数组重点的数据
 避免重复刷新的时候出现数据不对的问题
 
 */


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
}

#pragma mark -全选
-(void)selectAllBtnClick:(UIButton *)btn
{
    
    if (!btn.tag) {
         [btn setImage:[UIImage imageNamed:@"shopCarSelected"] forState:0];
    }else{
         [btn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
    }
      for (int i =0; i<_productList.count; i++)
    {
        ShopCarProductModel *product =_productList[i];
        [product setIsSelected:!btn.tag];
    }
    [btn setTag:!btn.tag];
    [self.tableView reloadData];
}






#pragma mark -返回上层
-(void)leftItemClick
{
   // [_delegate showSreachBar];
    //[_delegate searchBarEndEditing];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
