//
//  TopProductsView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "TopProductsView.h"
#import "ProductView.h"
#import "Store_Products_Model.h"

@interface TopProductsView()

@property(nonatomic,strong)ProductView *product1;

@property(nonatomic,strong)ProductView *product2;

@property(nonatomic,strong)ProductView *product3;


@end

@implementation TopProductsView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        _product1 = [[ProductView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/2-1, frame.size.height)];
        [_product1 setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:_product1];
        
       _product2 = [[ProductView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height/2-1)];
        [_product2 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_product2];
        
        
        _product3 = [[ProductView alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2)];
        [_product3 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_product3];

    }
    return self;
}

-(void)setProducts:(NSArray *)products{
    Store_Products_Model *product1 = products[0];
    NSString *str = product1.ProductImages[0];
    UIImage *img = [UIImage imageNamed:str];
    Store_Products_Model *product2 = products[1];
    NSString *str2 = product2.ProductImages[0];
    UIImage *img2 = [UIImage imageNamed:str2];

   
#pragma mark -第一个商品
    [_product1.productImage setFrame:CGRectMake(_product1.frame.size.width*0.3, _product1.frame.size.width*0.3, _product1.frame.size.height*0.6, _product1.frame.size.height*0.6)];
    [_product1.productImage setImage:img];
    [_product1.productName setText: product1.ProductName];
    [_product1.productName setTextColor:[UIColor orangeColor]];
    [_product1.productName setFrame:CGRectMake(15, 5, _product1.frame.size.width*0.5, 20)];
    [_product1.productDesc setText:product1.ProductDesc];
    [_product1.productDesc setTextColor:[UIColor grayColor]];
    [_product1.productDesc setFont:[UIFont systemFontOfSize:10]];
    [_product1.productDesc setFrame:CGRectMake(15, 25, _product1.frame.size.width*0.8, 20)];
    
    
#pragma mark -第二个商品
    [_product2.productImage setFrame:CGRectMake(10, _product2.frame.size.width*0.05, _product2.frame.size.height*0.7, _product2.frame.size.height *0.7)];
    [_product2.productImage setImage:img2];
    [_product2.productName setText: product2.ProductName];
    [_product2.productName setTextColor:[UIColor redColor]];
    [_product2.productName setFrame:CGRectMake(_product2.frame.size.width*0.4, 15, _product2.frame.size.width*0.5, 20)];
    [_product2.productDesc setText:product2.ProductDesc];
    [_product2.productDesc setTextColor:[UIColor grayColor]];
    [_product2.productDesc setFont:[UIFont systemFontOfSize:10]];
    [_product2.productDesc setFrame:CGRectMake(_product2.frame.size.width*0.4, 35, _product2.frame.size.width*0.6, 20)];
    
#pragma mark -第三个商品
    [_product3.productImage setFrame:CGRectMake(10, _product3.frame.size.width*0.05, _product3.frame.size.height*0.7, _product3.frame.size.height *0.7)];
    [_product3.productImage setImage:img2];
    [_product3.productName setText: product2.ProductName];
    [_product3.productName setTextColor:[UIColor redColor]];
    [_product3.productName setFrame:CGRectMake(_product3.frame.size.width*0.4, 15, _product3.frame.size.width*0.5, 20)];
    [_product3.productDesc setText:product2.ProductDesc];
    [_product3.productDesc setTextColor:[UIColor grayColor]];
    [_product3.productDesc setFont:[UIFont systemFontOfSize:10]];
    [_product3.productDesc setFrame:CGRectMake(_product3.frame.size.width*0.4, 35, _product3.frame.size.width*0.6, 20)];

    
    
    
}

@end
