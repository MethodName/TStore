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

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *addressList;

@property(nonatomic,assign)CGSize mainSize;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadData];
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
    [self.navigationItem setTitle:@"地址管理"];
    
    
    /**
     tableView
     */
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, _mainSize.height-44) style:UITableViewStyleGrouped];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i= 0; i<10; i++) {
            StoreAddressModel *address = [StoreAddressModel new];
            [address setAddressID:i+1];
            [address setProvinceCityDistrict:@"湖南省长沙市"];
            [address setAddressDetail:@"岳麓区天顶街道中电软件园"];
            [address setConsignee:@"methodname"];
            [address setTelephone:@"15974244021"];
            [address setUserID:15];
            
           if(i==1)
               [address setIsDefault:YES];
            else
                [address setIsDefault:NO];
            
            [_addressList addObject:address];
        }
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    });
   
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _addressList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    StoreAddressModel *address = _addressList[indexPath.section];
    if (cell.consignee == nil)
    {
        cell = [[AddressViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
    }
    [cell setAddressValueWithAddress:address];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreAddressModel *address =_addressList[indexPath.section];
    [_delegate selectRowWithAddress:[NSString stringWithFormat:@"%@%@",address.ProvinceCityDistrict,address.AddressDetail]];
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark -返回上层
-(void)leftItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
