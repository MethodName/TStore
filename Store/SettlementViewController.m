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

@interface SettlementViewController ()<UITableViewDataSource,UITableViewDelegate>



@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;


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
    _mainSize = self.view.frame.size;
    
    /**
     导航按钮
     */
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
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
    
    
    
    
}

#pragma mark -设置分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _productList.count+1;
}

#pragma mark -表格每组行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
        return 44;
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
            [cell.name setText:@"请先填写收货人信息"];
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
        }else if (indexPath.row==3)//现金券
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.name setText:@"现金券"];
        }else if (indexPath.row==4)//红包
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.name setText:@"红包"];
        }else if (indexPath.row==5)//合计
        {
            [cell.name setText:@"合计"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
   
}





#pragma mark -返回上层
-(void)leftItemClick
{
    // [_delegate showSreachBar];
    //[_delegate searchBarEndEditing];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
