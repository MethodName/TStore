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

@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,SelectAddressViewControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)CGSize mainSize;

@property(nonatomic,strong)UILabel *address;

@property(nonatomic,strong)UITextField *consignee;

@property(nonatomic,strong)UITextField *telephone;

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
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[ToolsOriginImage OriginImage: [UIImage imageNamed:@"leftBtn.png"] scaleToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStyleBordered target:self action:@selector(leftItemClick)];
    [leftBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setTitle:@"添加地址"];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    /**
     tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height-44) style:UITableViewStyleGrouped];
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

-(void)addressWithStr:(NSString *)str
{
    [_address setText:str];
    [_address setTextAlignment:NSTextAlignmentLeft];
}


#pragma mark -完成
-(void)rightBtnClick
{
     [self.navigationController popViewControllerAnimated:YES];
    [_delegate backReLoadData];
}

#pragma mark -返回上层
-(void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
