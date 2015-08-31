//
//  PlayTypeViewController.m
//  Store
//
//  Created by tangmingming on 15/8/31.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "PlayTypeViewController.h"
#import "StoreNavigationBar.h"
#import "PlayTypeCell.h"

@interface PlayTypeViewController ()<StoreNavigationBarDeleagte,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)CGSize mainSize;

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)UILabel *sumPriceLabel;


@property(nonatomic,strong)UIButton *commitBtn;

@property(nonatomic,assign)NSInteger payType;



@end

@implementation PlayTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createView];
}

-(void)createView
{
    _mainSize = [UIScreen mainScreen].bounds.size;
    
    
    //默认支付状态为-1未选
    _payType = -1;
    
    /**
     导航按钮
     */
    StoreNavigationBar *navigationBar= [[StoreNavigationBar alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 64)];
    [navigationBar setBarDelegate:self];
    [navigationBar.searchBar setHidden:YES];
    [navigationBar.rightBtn setHidden:YES];
    [navigationBar.title setText:@"在线支付"];
    [self.view addSubview:navigationBar];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, _mainSize.width, _mainSize.height-164) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_tableView];
    
    
    //表格头
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 44)];
    [headView setBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0]];
    
    
    //总金额
    UILabel *ed = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 70, 20)];
    [ed setText:@"订单总额"];
    [ed setTextColor:[UIColor orangeColor]];
    [ed setTextAlignment:NSTextAlignmentLeft];
    
    [headView addSubview:ed];
    
    _sumPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 12, _mainSize.width*0.6, 20)];
    [_sumPriceLabel setTextColor:[UIColor orangeColor]];
    [_sumPriceLabel setTextAlignment:NSTextAlignmentLeft];
    [_sumPriceLabel setText:@"￥120.54"];
    [headView addSubview:_sumPriceLabel];
    
    
    [_tableView setTableHeaderView:headView];
    
    
    
    _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, _mainSize.height-80, _mainSize.width-30, 44)];
    [_commitBtn setTitle:@"确认支付" forState:0];
    [_commitBtn setBackgroundColor:[UIColor orangeColor]];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_commitBtn.layer setCornerRadius:4.0];
    
    [self.view addSubview:_commitBtn];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row;
    if (section==0) {
        row = 2;
    }else {
        row = 4;
    }
    return row;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 5)];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
   
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, _mainSize.width, 5)];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }else if(indexPath.section==1&&indexPath.row==0){
        return 44;
    }
    else{
        return 60;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayTypeCell *cell = [[PlayTypeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"playTypeCell"];
  
    
    NSArray *iconArray = @[@"wxplay",@"ziplay",@"qqplay"];
    NSArray *nameArray = @[@"微信支付",@"支付宝",@"QQ钱包"];
    NSArray *detailArray = @[@"推荐已经安装微信客户端的用户使用",@"推荐已经安装支付宝客户端的用户使用",@"推荐已经安装QQ客户端的用户使用"];
    if (indexPath.section==0)
    {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0)
        {
             [cell.textLabel setText:@"使用红包"];
        }
        else
        {
             [cell.textLabel setText:@"使用代金券"];
        }
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
       [cell.textLabel setText:@"使用第三方平台支付"];
    }
    else
    {
        [cell.selectBtn setHidden:NO];
        if (indexPath.row+1==_payType) {
              [cell.selectBtn setImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"pay_select"] CGImage] scale:3.0 orientation:UIImageOrientationUp] forState:0];
        }else{
              [cell.selectBtn setImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"pay_select_press"] CGImage] scale:3.0 orientation:UIImageOrientationUp] forState:0];
        }
       
        UIImage *img =[UIImage imageWithCGImage:[[UIImage imageNamed:iconArray[indexPath.row-1]] CGImage] scale:1.8 orientation:UIImageOrientationUp];
        [cell.imageView setImage:img];
        
         [cell.textLabel setText:nameArray[indexPath.row-1]];
        [cell.detailTextLabel setText:detailArray[indexPath.row-1]];

    }
    
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark -行选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row>0)
    {
         _payType = indexPath.row+1;
        [self.tableView reloadData];
    }
   
}


#pragma mark -确认支付
-(void)commitClick
{
    
    
    /**
     *  支付完成后，在回调block中修改订单的状态和结算的金额
     *
     */
    
    
    if (_payType == 1)//微信支付
    {
        
    }
    else if(_payType == 2)//支付宝
    {
        
    }
    else if(_payType == 3)//QQ钱包
    {
        
    }
}







#pragma mark -放回到主页
-(void)leftClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
