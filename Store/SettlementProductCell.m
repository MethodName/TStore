//
//  SettlementProductCell.m
//  Store
//
//  Created by tangmingming on 15/8/21.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "SettlementProductCell.h"

@implementation SettlementProductCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:@"settlementCell"])
    {
         CGFloat width = [UIScreen mainScreen].bounds.size.width;
        //商品图片
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 60)];
        //[_productImage setImage:[UIImage imageNamed:@"placeholderImage"]];
        //[_productImage setHidden:YES];
        [self.contentView addSubview:_productImage];
        //name
        _name = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, width*0.7, 20)];
        [_name setTextColor:[UIColor lightGrayColor]];
        [_name setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        [self.contentView addSubview:_name];
        
        //商品名字
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 100, 20)];
        [_productName setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        [_productName setTextColor:[UIColor orangeColor]];
        [self.contentView addSubview:_productName];
        
        //商品价格
        _price = [[UILabel alloc]initWithFrame:CGRectMake(width-215, 5, 200, 20)];
        [_price setTextAlignment:NSTextAlignmentRight];
        [_price setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        [self.contentView addSubview:_price];
        
        //商品数量
        _productCount = [[UILabel alloc]initWithFrame:CGRectMake(width-155, 25, 140, 20)];
         [_productCount setTextColor:[UIColor lightGrayColor]];
         [_productCount setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
         [_productCount setTextAlignment:NSTextAlignmentRight];
         [self.contentView addSubview:_productCount];
        
        //详细
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(width-(width*0.65+15), 12, width*0.65, 20)];
        [_detail setTextColor:[UIColor lightGrayColor]];
        [_detail setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [_detail setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_detail];
        
        
        //合计
        _sumPrice = [[UILabel alloc]initWithFrame:CGRectMake(width-(width*0.65+15), 12, width*0.65, 20)];
        [_sumPrice setTextColor:[UIColor redColor]];
        [_sumPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:13.0]];
        [_sumPrice setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_sumPrice];

    }
    
    return self;
}

@end
