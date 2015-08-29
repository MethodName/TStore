//
//  AddressViewController.m
//  Store
//
//  Created by tangmingming on 15/8/22.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "AddressViewController.h"
#import "ToolsOriginImage.h"
#import "StoreAddressModel.h"
#import "AddressViewCell.h"
#import "CustomHUD.h"
#import "AddAddressViewController.h"
#import "EditAddressViewController.h"
#import "StoreNavigationBar.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressViewCellDelegate,AddAddressViewControllerDelegate,EditAddressViewControllerDelegate,StoreNavigationBarDeleagte>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *addressList;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)CustomHUD *simpleHud;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     [self createView];
    [self loadData];
   
}

#pragma mark -创建子视图
-(void)createView
{
    _mainSize = self.view.frame.size;
    /**
     导航按钮
     */
    [self.navigationController setNavigationBarHidden:YES];
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.rightBtn setHidden:YES];
    [navigationBar.title setText:@"地址管理"];
    [self.view addSubview:navigationBar];
    
    /**
     tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, _mainSize.width, _mainSize.height-98) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:_mainSize.width*0.4];
    [_tableView setSectionHeaderHeight:3];
    [_tableView setSectionFooterHeight:3];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0,0, _mainSize.width, 1)]];
    
    [_tableView registerClass:[AddressViewCell class] forCellReuseIdentifier:@"addressCell"];
    
    [self.view addSubview:_tableView];
    
    //新建按钮
    UIButton *addAddress = [[UIButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-39, _mainSize.width-30, 34)];
    [addAddress setBackgroundColor:[UIColor orangeColor]];
    [addAddress.titleLabel setTextColor:[UIColor whiteColor]];
    [addAddress setTitle:@"+新建地址" forState:0];
    [addAddress addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddress];
    
    
    /**
     添加手势
     */
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
}


-(void)loadData
{
    if (_addressList == nil) {
        _addressList =[NSMutableArray new];
    }
    [_addressList removeAllObjects];
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         sleep(1);
        for (int i= 0; i<10; i++) {
           
            StoreAddressModel *address = [StoreAddressModel new];
            [address setAddressID:i+1];
            [address setProvinceCityDistrict:@"湖南省长沙市"];
            [address setAddressDetail:@"岳麓区天顶街道中电软件园23栋华瑞软件学院5楼IOS4班"];
            [address setConsignee:@"唐明明"];
            [address setTelephone:@"15974244021"];
            [address setUserID:15];
            
           if(i==1)
               [address setIsDefault:YES];
            else
                [address setIsDefault:NO];
            
            [_addressList addObject:address];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [_simpleHud simpleComplete];
             [_tableView reloadData];
        });
        
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _addressList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    StoreAddressModel *address = _addressList[indexPath.section];
    if (cell.consignee == nil)
    {
        cell = [[AddressViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
    }
    [cell setAddressValueWithAddress:address];
    //设置按钮的tag值为当前行数，方便后面的修改操作
    [cell.defaultAddress setTag:indexPath.section];
    [cell setDelegate:self];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreAddressModel *address =_addressList[indexPath.section];
    [_delegate selectRowWithAddress:[NSString stringWithFormat:@"%@%@",address.ProvinceCityDistrict,address.AddressDetail]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -设置默认地址
-(void)setDefaultAddressWithBtn:(UIButton *)btn
{
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            //改变当前数组中的值
            for (int i= 0; i<_addressList.count; i++) {
                StoreAddressModel *address =_addressList[i];
                if(i==btn.tag)
                {
                    [address setIsDefault:YES];
                }
                else
                {
                    [address setIsDefault:NO];
                }
            }
            [self.simpleHud simpleComplete];
            //刷新数据
            [self.tableView reloadData];
        });
    });

}

#pragma mark -编辑代理
-(void)editAddressWithAddress:(NSString *)address  Consignee:(NSString *)consignee Telephone:(NSString *)telephone
{
    EditAddressViewController *editView = [[EditAddressViewController alloc]init];
    [editView setOldAddress:address];
    [editView setOldConsignee:consignee];
    [editView setOldTelephone:telephone];
    [editView setDelegate:self];
    [self.navigationController pushViewController:editView animated:YES];
}

#pragma mark -添加代理
-(void)addAddress
{
    AddAddressViewController *addView = [[AddAddressViewController alloc]init];
    [addView setDelegate:self];
    [self.navigationController pushViewController:addView animated:YES];
}

#pragma mark -返回到当前页的代理方法【刷新页面数据】
-(void)backReLoadData
{
    [self loadData];
}

#pragma mark -删除代理
-(void)deleteAddress
{
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟请求网络数据
        sleep(1.0);
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


#pragma mark -返回上层
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
