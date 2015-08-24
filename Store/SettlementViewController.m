//
//  SettlementViewController.m
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SettlementViewController.h"
#import "ToolsOriginImage.h"
#import "ShopCarProductModel.h"
#import "SettlementHeadCell.h"
#import "SettlementProductCell.h"
#import "SettlementConfirmView.h"
#import "CustomHUD.h"
#import "AddressViewController.h"
#import "DeliveryTimeViewController.h"
#import "ProductDetailViewController.h"

@interface SettlementViewController ()<UITableViewDataSource,UITableViewDelegate,AddressViewControllerDelegate,MainSreachBarDelegate>



@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)SettlementConfirmView *settlementBar;

@property(nonatomic,strong)CustomHUD *simpleHud;

@property(nonatomic,strong)NSString *defaultAddress;


@end

@implementation SettlementViewController

#pragma mark -视图加载后
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
}


#pragma mark -创建视图
-(void)createView
{
    
    _defaultAddress = @"请先填写收货人信息";
    _mainSize = self.view.frame.size;
    
    /**
     导航按钮
     */
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage: [UIImage imageWithCGImage:[[UIImage imageNamed:@"leftBtn"] CGImage] scale:1.8 orientation:UIImageOrientationUp] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setTitle:@"结算中心"];
    
    
    /**
     初始化tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height-60) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSectionHeaderHeight:3];
    [_tableView setSectionFooterHeight:3];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 1)]];
    [_tableView registerClass:[SettlementHeadCell class] forCellReuseIdentifier:@"settlementCell"];
    [_tableView registerClass:[SettlementProductCell class] forCellReuseIdentifier:@"settlementProductCell"];
    [self.view addSubview:_tableView];
    
    /**
        确认栏
     */
    SettlementConfirmView *settlementBar = [[SettlementConfirmView alloc]initWithFrame:CGRectMake(0, _mainSize.height-60, _mainSize.width, 60)];
    [settlementBar.settlementBtn addTarget:self action:@selector(settlementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _settlementBar = settlementBar;
    //计算总金额
    double sumprice =0;
    for (int i =0; i<_productList.count; i++)
    {
          ShopCarProductModel * product = _productList[i];
          sumprice += product.ProductRealityPrice*product.ProductShopCarCout;
    }
    [settlementBar.sumPrice setText:[NSString stringWithFormat:@"￥%0.2lf",sumprice]];
    
    [self.view addSubview:settlementBar];
    
    /**
     添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
    
}

#pragma mark -设置分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _productList.count+1;
}

#pragma mark -表格每组行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 2;
    if (section >0) {
        row = 6;
    }
    return row;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0&&indexPath.row==1) {
        return 70;
    }else{
        return 40;
    }
}

#pragma mark -表格每行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*-------------------------head-------------------------------*/
    if (indexPath.section==0)
    {
        //地址和送货时间
        SettlementHeadCell *cell = [[SettlementHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settlementCell"];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0)
        {
            [cell.icon setImage:[UIImage imageNamed:@"location"]];
            [cell.name setText:_defaultAddress];
        }else if (indexPath.row==1) {
            [cell.icon setImage:[UIImage imageNamed:@"date"]];
            [cell.name setText:@"工作日、双休日与假日均可送货"];
        }
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         return cell;
    }
     /*-------------------------head  end-------------------------------*/
    else
    {
    /*-------------------------product-------------------------------*/
        ShopCarProductModel * product = _productList[indexPath.section-1];
        //SettlementProductCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"settlementProductCell"];
//        if (cell.productImage == nil)
//        {
          SettlementProductCell *   cell = [[SettlementProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settlementProductCell"];
//        }
        /**
         *  设置属性
         */
        if (indexPath.row==0)//店铺名字
        {
            [cell.name setText:@"隔壁老王的水果店(包邮)"];
        }else if (indexPath.row==1)//图片与价格数量
        {
            [cell.productImage setImage:[UIImage imageNamed:product.ProductImage]];
            [cell.productName setText:product.ProductName];
            [cell.price setText:[NSString stringWithFormat:@"￥%0.2lf元",product.ProductRealityPrice]];
            [cell.productCount setText:[NSString stringWithFormat:@"x%d",(int)product.ProductShopCarCout]];
        }else if (indexPath.row==2)//运费
        {
            [cell.name setText:@"运费"];
            [cell.detail setText:[NSString stringWithFormat:@"快递:￥%0.2lf元(已减免:%0.2lf)",0.0,0.0]];
        }else if (indexPath.row==3)//现金券
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.name setText:@"现金券"];
            [cell.detail setText:@"使用现金券"];
            [cell.detail setCenter:CGPointMake(cell.detail.center.x-15, cell.detail.center.y)];
        }else if (indexPath.row==4)//红包
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.name setText:@"红包"];
            [cell.detail setText:@"使用红包"];
            [cell.detail setCenter:CGPointMake(cell.detail.center.x-15, cell.detail.center.y)];
        }else if (indexPath.row==5)//合计
        {
            [cell.name setText:@"合计"];
            [cell.sumPrice setText:[NSString stringWithFormat:@"￥%0.2lf",product.ProductRealityPrice*product.ProductShopCarCout]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
   
}

#pragma mark -确认付款
-(void)settlementBtnClick
{
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(5.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleHud simpleComplete];
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

#pragma mark -tableView行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择地址
    if (indexPath.section ==0&&indexPath.row==0)
    {
        AddressViewController *addressView  =[[AddressViewController alloc]init];
        [addressView setDelegate:self];
        [self.navigationController pushViewController:addressView animated:YES];
    }
    else if(indexPath.section ==0&&indexPath.row==1){
        DeliveryTimeViewController *deliveryTimeView  =[[DeliveryTimeViewController alloc]init];
        [self.navigationController pushViewController:deliveryTimeView animated:YES];
    }
    
    
}


-(void)selectRowWithAddress:(NSString *)address
{
    _defaultAddress = address;
    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -返回上层
-(void)leftItemClick
{
    // [_delegate showSreachBar];
    //[_delegate searchBarEndEditing];
    if (_delegate != nil) {
        [_delegate hideNavigationBar];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
