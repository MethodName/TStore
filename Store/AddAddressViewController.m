//
//  AddAddressViewController.m
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "AddAddressViewController.h"
#import "ToolsOriginImage.h"
#import "SelectAddressViewController.h"
#import "StoreNavigationBar.h"
#import "StoreDefine.h"
#import "User.h"
#import "StoreAddressModel.h"
#import "CustomHUD.h"

@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,SelectAddressViewControllerDelegate,StoreNavigationBarDeleagte>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)UILabel *address;

@property(nonatomic,strong)UITextField *consignee;

@property(nonatomic,strong)UITextField *telephone;

@property(nonatomic,strong)StoreAddressModel *addressObj;

@property(nonatomic,strong)CustomHUD *simpleHud;

@end

@implementation AddAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
}

#pragma mark -创建子视图
-(void)createView
{
    
    _mainSize = self.view.frame.size;
    /**
     导航按钮
     */
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.rightBtn setImage:nil forState:0];
    [navigationBar.rightBtn setImage:nil forState:1];
    [navigationBar.rightBtn setTitle:@"完成" forState:0];
    [navigationBar.title setText:@"添加地址"];
    
    [self.view addSubview:navigationBar];
    
    /**
     tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, _mainSize.width, _mainSize.height-108) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSectionHeaderHeight:3];
    [_tableView setSectionFooterHeight:3];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0,0, _mainSize.width, 5)]];
    
    [self.view addSubview:_tableView];
    
    
    _addressObj = [StoreAddressModel new];
    [_addressObj setUserID:[User shareUserID]];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addAddressCell"];
    if (indexPath.section==0)
    {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _address = [[UILabel alloc]initWithFrame:CGRectMake(80, 8, _mainSize.width-110, 25)];
        [_address setTextAlignment:NSTextAlignmentRight];
        [_address setTextColor:[UIColor lightGrayColor]];
        [_address setFont:[UIFont systemFontOfSize:14.0]];
        [_address setText:@"请设置"];
        [cell.contentView addSubview:_address];
        [cell.textLabel setText:@"地址"];
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"收货人"];
            _consignee = [[UITextField alloc]initWithFrame:CGRectMake(80, 10, _mainSize.width*0.6, 30)];
            [_consignee setPlaceholder:@"收货人"];
            [cell.contentView addSubview:_consignee];
        }
        else if (indexPath.row==1)
        {
            [cell.textLabel setText:@"手机号"];
            _telephone = [[UITextField alloc]initWithFrame:CGRectMake(80, 10, _mainSize.width*0.6, 30)];
            [_telephone setPlaceholder:@"手机号"];
            [cell.contentView addSubview:_telephone];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        SelectAddressViewController *selectAddressView = [[SelectAddressViewController alloc]init];
        [selectAddressView setDelegate:self];
        [self.navigationController pushViewController:selectAddressView animated:YES];
    }
}

-(void)addressWithCommunity:(NSString *)community Housing:(NSString *)housing
{
    [_address setText:[NSString stringWithFormat:@"%@%@",community,housing]];
    [_address setTextAlignment:NSTextAlignmentLeft];
    //拿到地址返回的值
    [_addressObj setProvinceCityDistrict:community];
    [_addressObj setAddressDetail:housing];
}


#pragma mark -完成
-(void)rightClick
{
   
    /**
        验证收货人和联系电话是否为空
     */
    _addressObj.consignee =[_consignee.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_addressObj.consignee.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收货人不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    _addressObj.telephone =[_telephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_addressObj.telephone.length==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }

    //显示指示器
    [self.simpleHud setHidden:NO];
    [self.simpleHud startSimpleLoad];
    //添加新地址
    /*
     path:   StoreAddress/addStoreAddress
     
     args:
     userID=用户ID
     provinceCityDistrict=省市区
     addressDetail=地址详情
     consignee=收件人
     telephone=电话号码
     **/
    NSString *path = [NSString stringWithFormat:@"%sStoreAddress/addStoreAddress?userID=%d",SERVER_ROOT_PATH,(int)_addressObj.userID];
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = [NSString stringWithFormat:@"provinceCityDistrict=%@&addressDetail=%@&consignee=%@&telephone=%@",_addressObj.provinceCityDistrict,_addressObj.addressDetail,_addressObj.consignee,_addressObj.telephone];//设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];

    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil)
        {
            //将结果转成字典集合
            NSDictionary *dic =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^
           {
               if ([dic[@"status"] integerValue]==1)
               {
                   [self.navigationController popViewControllerAnimated:YES];
                   [_delegate backReLoadData];
               }
               else
               {
                   UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                   [alertView show];
               }
           });
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:connectionError.debugDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
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
