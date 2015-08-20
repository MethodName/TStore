//
//  ProductListCell.m
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductListCell.h"
#import "StoreDefine.h"


@implementation ProductListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = TABLE_CELL_HEIGHT;
        
        //图片
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, height-30, height-30)];
        //名字
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(height, 5, width-height, 20)];
        [_productName setFont:[UIFont systemFontOfSize:16]];
        //规格
        _PSName = [[UILabel alloc]initWithFrame:CGRectMake(height, 25, width-height, 20)];
        [_PSName setFont:[UIFont systemFontOfSize:13]];
        [_PSName setTextColor:[UIColor lightGrayColor]];
        //价格
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(height, height-20, width-height, 20)];
        [_productPrice setTextColor:[UIColor redColor]];
        [_productPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:14.0]];
        
        //加入购物车
        _addShopCar = [[UIButton alloc]initWithFrame:CGRectMake(width-55, height-50, 33, 28)];
        [_addShopCar setImage:[UIImage imageNamed:@"shopCar"] forState:0];
        
        //已售数量
        _productScaleCount = [[UILabel alloc]initWithFrame:CGRectMake(width-60, height-23, 80, 20)];
        [_productScaleCount setFont:[UIFont systemFontOfSize:12]];
        
        
        
        [self.contentView addSubview:_productImage];
        [self.contentView addSubview:_productName];
        [self.contentView addSubview:_PSName];
        [self.contentView addSubview:_productPrice];
        [self.contentView addSubview:_addShopCar];
        [self.contentView addSubview:_productScaleCount];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)setCellDataWith:(StoreProductsModel *)product{
    [self.imageView setImage:[UIImage imageNamed:product.ProductImages[0]]];
    [self.productName setText:product.ProductName];
    [self.PSName setText:product.PSName];
    [self.productPrice setText:[NSString stringWithFormat:@"￥%0.2lf",product.ProductPrice]];
    [self.productScaleCount setText:[NSString stringWithFormat:@"%d已售出",(int)product.ProductSaleCount]];
}




@end
