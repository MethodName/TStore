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
#import "MJRefresh.h"
#import "StoreDefine.h"
#import "User.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressViewCellDelegate,AddAddressViewControllerDelegate,EditAddressViewControllerDelegate,StoreNavigationBarDeleagte>

@property(nonatomic,strong)UITableView *tableView;

/**
 *  地址集合
 */
@property(nonatomic,strong)NSMutableArray *addressList;
/**
 *  屏幕大小
 */
@property(nonatomic,assign)CGSize mainSize;

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
/**
 *  指示器
 */
@property(nonatomic,strong)CustomHUD *simpleHud;

@end

@implementation AddressViewController

#pragma mark -视图加载后
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, _mainSize.width, _mainSize.height-128) style:UITableViewStyleGrouped];
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
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe];
}

#pragma mark -加载数据【网络】
-(void)loadData
{
    if (_addressList == nil) {
        _addressList =[NSMutableArray new];
    }
    [_addressList removeAllObjects];
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    
    /**
     *  StoreAddress/findAddressByUserID
     *  userID=用户ID
     */
    
    
    
    NSString *path = [NSString stringWithFormat:@"%sStoreAddress/findAddressByUserID?userID=%d",SERVER_ROOT_PATH,(int)[User shareUserID]];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSArray *array =(NSArray *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (_isRefresh) {
                [_addressList removeAllObjects];
            }
            for (int i =0; i<array.count; i++)
            {
                StoreAddressModel *address = [StoreAddressModel new];
                [address setValuesForKeysWithDictionary:array[i]];
                [_addressList addObject:address];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^
           {
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
               [_simpleHud stopAnimation];
           });
        }
        else
        {
            NSLog(@"%@",connectionError.debugDescription);
        }
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _addressList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark -行内容
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
    //将选中地址的值传上上层页面
    [_delegate selectRowWithProvinceCityDistrict:address.provinceCityDistrict AddressDetail:address.addressDetail Consignee:address.consignee Telephone:address.telephone ];
    //push页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -设置默认地址
-(void)setDefaultAddressWithBtn:(UIButton *)btn AddressID:(NSInteger)addressID State:(NSInteger)state
{
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    /*
     
     StoreAddress/updateAddressDefault
     userID=用户ID
     addressID=地址ID
     isDefault=是默认
     
     **/
    //确定路径，tag反转【是默认，变成不默认，不默认，变成默认】
    NSString *path = [NSString stringWithFormat:@"%sStoreAddress/updateAddressDefault?userID=%d&addressID=%d&isDefault=%d",SERVER_ROOT_PATH,(int)[User shareUserID],(int)addressID,(int)state];
    
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if ([dic[@"status"] integerValue]==1)
                               {
                                   for (int i= 0; i<_addressList.count; i++)
                                   {
                                       StoreAddressModel *address =_addressList[i];
                                       if(address.addressID != addressID)
                                       {
                                           [address setIsDefault:NO];
                                       }
                                       else
                                       {
                                           
                                           [address setIsDefault:state==1?YES:NO];
                                       }
                                    }

                                   //删除地址集合中的已经删除的地址
                                   //更新UI
                                   [self.tableView reloadData];
                                   //通知父级重新加载默认地址
                                   [_delegate reLoadDefaultAddress];
                                   //指示器完成
                                   [self.simpleHud simpleComplete];
                                }
                               else
                               {//失败时
                                   [self.simpleHud stopAnimation];
                                   UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                   [alertView show];
                               }
                               
                           });
        }
        else
        {
            //网络请求出错时
            NSLog(@"%@",connectionError.debugDescription);
        }
    }];

}

#pragma mark -编辑代理
-(void)editAddressWithAddress:(NSString *)address  Consignee:(NSString *)consignee Telephone:(NSString *)telephone AddressID:(NSInteger)addressID
{
    EditAddressViewController *editView = [[EditAddressViewController alloc]init];
    //赋值
    [editView setOldAddress:address];
    [editView setOldConsignee:consignee];
    [editView setOldTelephone:telephone];
    [editView setAddressID:addressID];
    //设置代理
    [editView setDelegate:self];
    //push到编辑页面
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
-(void)deleteAddressWithAddressID:(NSInteger)addressID
{
    //显示指示器
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];

    NSString *path = [NSString stringWithFormat:@"%sStoreAddress/delStoreAddress?addressID=%d",SERVER_ROOT_PATH,(int)addressID];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^
               {
                   if ([dic[@"status"] integerValue]==1)
                   {
                       //删除地址集合中的已经删除的地址
                       for (int i =0; i<_addressList.count; i++)
                       {
                           StoreAddressModel *address = _addressList[i];
                           if (address.addressID==addressID) {
                               [_addressList removeObject:address];
                               break;
                           }
                       }
                       
                       //更新UI
                       [self.tableView reloadData];
                       //指示器完成
                        [self.simpleHud simpleComplete];
                   }
                   else
                   {
                       [self.simpleHud stopAnimation];
                       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                       [alertView show];
                   }

               });
        }
        else
        {
            NSLog(@"%@",connectionError.debugDescription);
        }
    }];

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
