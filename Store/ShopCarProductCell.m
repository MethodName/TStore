//
//  ShopCarProductCell.m
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ShopCarProductCell.h"
#import "StoreDefine.h"


@implementation ShopCarProductCell

#pragma mark -初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
         CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height =width*0.5;
        /**
         商品名字
         */
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 45, 22)];
        [name setText:@"商品："];
        [name setTextColor:[UIColor  colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0]];
        [name setFont:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:name];
        
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(55, 11, width-150, 22)];
        [_productName setFont:[UIFont fontWithName:@"Thonburi-Bold" size:15.0]];
        [_productName setTextColor:[UIColor orangeColor]];
        [self.contentView addSubview:_productName];
        
        //删除按钮
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(width-65, 7, 50, 25)];
        [_deleteBtn setTitle:@"删除" forState:0];
        [_deleteBtn.titleLabel setFont:[UIFont fontWithName:@"Thonburi-Bold" size:15.0]];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0] forState:0];
        [_deleteBtn.layer setBorderWidth:1.0];
        [_deleteBtn.layer setBorderColor:[[UIColor colorWithRed:(180/255.0) green:(180/255.0) blue:(180/255.0) alpha:1.0] CGColor]];
        [_deleteBtn.layer setCornerRadius:5.0];
        [self.contentView addSubview:_deleteBtn];
        
        
        
        //选择按钮
        _selectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(3, 30+49, 42, 40)];
        [_selectedBtn setImage:[UIImage imageNamed:@"shopCarNotSelected"] forState:0];
        [_selectedBtn setTag:0];
        [self.contentView addSubview:_selectedBtn];
        
        
        //图片
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5+44, height-60, height-60)];
        [self.contentView addSubview:_productImage];
        
        //简介
        
        UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(_productImage.frame.origin.x+_productImage.frame.size.width+20, 5+44, 60, 16)];
        [desc setTextColor:[UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1.0]];
        [desc setFont:[UIFont systemFontOfSize:14.0]];
        [desc setText:@"简介："];
        [self.contentView addSubview:desc];
        _productDetail = [[UILabel alloc]initWithFrame:CGRectMake(desc.frame.origin.x, desc.frame.origin.y+desc.frame.size.height, width*0.4, height*0.25)];
        [_productDetail setFont:[UIFont systemFontOfSize:13.0]];
        [_productDetail setTextColor:[UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1.0]];
        [_productDetail setNumberOfLines:0];
        [self.contentView addSubview:_productDetail];
        
        
        //价格
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(width-100, _productDetail.frame.origin.y+_productDetail.frame.size.height, 85, 20)];
        [_productPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [_productPrice setTextColor:[UIColor redColor]];
        [_productPrice setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_productPrice];
        
        //数量
        _productCount = [[UILabel alloc]initWithFrame:CGRectMake(width-65, height -30, 50, 25)];
        [_productCount setTextColor:[UIColor lightGrayColor]];
        [_productCount setFont:[UIFont systemFontOfSize:13.0]];
        [_productCount setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_productCount];

        
        
        //选择数量
        _subBtn = [[UIButton alloc] initWithFrame:CGRectMake(_productDetail.frame.origin.x+2, height-35, 30, 25)];
        [_subBtn setTitle:@"-" forState:0];
        [_subBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [_subBtn.layer setBorderWidth:1.0];
        [_subBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_subBtn addTarget:self action:@selector(productCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_subBtn];
        
        _centerNum = [[UIButton alloc] initWithFrame:CGRectMake(_productDetail.frame.origin.x+31, height-35, 30, 25)];
        [_centerNum.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_centerNum setTitleColor:[UIColor lightGrayColor] forState:0];
        [_centerNum.layer setBorderWidth:1.0];
        [_centerNum.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.contentView addSubview:_centerNum];
        
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(_productDetail.frame.origin.x+60, height-35, 30, 25)];
        [_addBtn setTitle:@"+" forState:0];
        [_addBtn setTitleColor:[UIColor lightGrayColor] forState:0];
        [_addBtn.layer setBorderWidth:1.0];
        [_addBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_addBtn addTarget:self action:@selector(productCountClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
    
        
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}


/**
 *  画线
 *
 *  @param rect
 */
-(void)drawRect:(CGRect)rect
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //1、获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint ps1[] = {CGPointMake(15, 44), CGPointMake(width-15, 44)};
    CGContextAddLines(context, ps1, sizeof(ps1)/sizeof(CGPoint));
    CGContextSetLineWidth(context, 0.8);
    [[UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0]set];
    CGContextDrawPath(context, kCGPathStroke);
}



#pragma mark -设置值
-(void)setShopCarListItemShopCarProductModel:(ShopCarProductModel *)product
{
    /**
     *  异步线程加载图片
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *photourl = [NSURL URLWithString:@"http://www.baoshanjie.com/data/attachment/forum/201505/02/133100uvpkv4gaeynpvjnh.jpg"];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];//通过网络url获取uiimage
        dispatch_async(dispatch_get_main_queue(), ^{
            [_productImage setImage:img];
        });
    });
    
    [_centerNum setTitle:[NSString stringWithFormat:@"%d",(int)product.ProductShopCarCout] forState:0];
    [_productName setText:product.ProductName];
    [_productDetail setText:product.ProductDesc];
    [_productCount setText:[NSString stringWithFormat:@"x%d",(int)product.ProductShopCarCout]];
    [_productPrice setText:[NSString stringWithFormat:@"￥%0.2lf",product.ProductRealityPrice]];
}

#pragma mark -改变商品数量
-(void)productCountClick:(UIButton *)btn
{
    NSString *countStr =_centerNum.titleLabel.text;
    NSInteger count =countStr.integerValue;
    if ([btn.titleLabel.text isEqualToString:@"-"])
    {
        if (count>1)
        {
            count--;
        }
    }
    else  if ([btn.titleLabel.text isEqualToString:@"+"])
    {
        if (count<100)
        {
            count++;
        }
    }
    [_delegate productCountChage:count CellRow:btn.tag];
}




@end
