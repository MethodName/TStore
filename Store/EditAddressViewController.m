//
//  EditAddressViewController.m
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "EditAddressViewController.h"
#import "ToolsOriginImage.h"
#import "SelectAddressViewController.h"
#import "StoreNavigationBar.h"

@interface EditAddressViewController ()<UITableViewDelegate,UITableViewDataSource,SelectAddressViewControllerDelegate,StoreNavigationBarDeleagte>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)UILabel *address;

@property(nonatomic,strong)UITextField *consignee;

@property(nonatomic,strong)UITextField *telephone;

@end

@implementation EditAddressViewController

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
    [navigationBar.title setText:@"编辑地址"];
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
        [_address setTextAlignment:NSTextAlignmentLeft];
        [_address setTextColor:[UIColor lightGrayColor]];
        [_address setFont:[UIFont systemFontOfSize:14.0]];
        [_address setText:_oldAddress];
        [cell.contentView addSubview:_address];
        [cell.textLabel setText:@"地址"];
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row==0) {
            [cell.textLabel setText:@"收货人"];
            _consignee = [[UITextField alloc]initWithFrame:CGRectMake(80, 10, _mainSize.width*0.6, 30)];
            [_consignee setPlaceholder:@"收货人"];
            [_consignee setText:_oldConsignee];
            [cell.contentView addSubview:_consignee];
        }
        else if (indexPath.row==1)
        {
            [cell.textLabel setText:@"手机号"];
            _telephone = [[UITextField alloc]initWithFrame:CGRectMake(80, 10, _mainSize.width*0.6, 30)];
            [_telephone setPlaceholder:@"手机号"];
            [_telephone setText:_oldTelephone];
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

-(void)addressWithStr:(NSString *)str
{
    [_address setText:str];
    [_address setTextAlignment:NSTextAlignmentLeft];
}




#pragma mark -完成
-(void)rightClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [_delegate backReLoadData];
}

#pragma mark -返回上层
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
