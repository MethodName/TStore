//
//  SelectAddressViewController.m
//  Store
//
//  Created by tangmingming on 15/8/23.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "ToolsOriginImage.h"
#import "StoreNavigationBar.h"

@interface SelectAddressViewController ()<UITableViewDataSource,UITableViewDelegate,StoreNavigationBarDeleagte>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)UILabel *address;

/**小区*/
@property(nonatomic,strong)UITextField *community;

/**房屋*/
@property(nonatomic,strong)UITextField *housing;



@end

@implementation SelectAddressViewController

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
    [navigationBar.rightBtn setTitle:@"确定" forState:0];
    [navigationBar.title setText:@"选择地址"];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addAddressCell"];
   	 [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        if (indexPath.row==0) {
            [cell.textLabel setText:@"已选小区"];
            _community = [[UITextField alloc]initWithFrame:CGRectMake(80, 10, _mainSize.width*0.7, 25)];
            [_community setPlaceholder:@"永安安置小区"];
            [cell.contentView addSubview:_community];
        }
        else if (indexPath.row==1)
        {
            [cell.textLabel setText:@"输入栋号房号"];
           
            _housing = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, _mainSize.width*0.55, 25)];
            [_housing setPlaceholder:@"如1栋1单元101室"];
            [cell.contentView addSubview:_housing];
        }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



#pragma mark -确定
-(void)rightClick
{
     [self.navigationController popViewControllerAnimated:YES];
    [_delegate addressWithStr:[NSString stringWithFormat:@"%@%@",_community.text,_housing.text]];
}

#pragma mark -返回上层
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end












/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */

/**
 * 　　　　　　　　┏┓　　　┏┓
 * 　　　　　　　┏┛┻━━━┛┻┓
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃　　　━　　　┃
 * 　　　　　　　┃　＞　　　＜　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃    ...　⌒　...　 ┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┗━┓　　　┏━┛
 * 　　　　　　　　　┃　　　┃　Code is far away from bug with the animal protecting
 * 　　　　　　　　　┃　　　┃   神兽保佑,代码无bug
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┗━━━┓
 * 　　　　　　　　　┃　　　　　　　┣┓
 * 　　　　　　　　　┃　　　　　　　┏┛
 * 　　　　　　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　　　　　　┃┫┫　┃┫┫
 * 　　　　　　　　　　┗┻┛　┗┻┛
 */

/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */





