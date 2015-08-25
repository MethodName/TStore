//
//  TopProductsView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "TopProductsView.h"
#import "ProductView.h"
#import "StoreProductsModel.h"
#import "Product.h"

@interface TopProductsView()

@property(nonatomic,strong)NSMutableArray *topProducts;



@end

@implementation TopProductsView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _topProducts = [NSMutableArray new];
        
#pragma mark -第一个商品
        ProductView * product1 = [[ProductView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/2-1, frame.size.height)];
        [product1 setBackgroundColor:[UIColor whiteColor]];
         [product1.productImage setFrame:CGRectMake(product1.frame.size.width*0.3, product1.frame.size.width*0.3, product1.frame.size.height*0.6, product1.frame.size.height*0.6)];
         [product1.productName setFrame:CGRectMake(15, 5, product1.frame.size.width*0.5, 20)];
        [product1.productName setTextColor:[UIColor orangeColor]];
        [product1.productDesc setFrame:CGRectMake(15, 25, product1.frame.size.width*0.8, 20)];
         [product1.productDesc setTextColor:[UIColor grayColor]];
         [product1.productDesc setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:product1];
        
#pragma mark -第二个商品
        ProductView *  product2 = [[ProductView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height/2-1)];
        [product2 setBackgroundColor:[UIColor whiteColor]];
        [product2.productImage setFrame:CGRectMake(10, product2.frame.size.width*0.05, product2.frame.size.height*0.7, product2.frame.size.height *0.7)];
        [product2.productName setFrame:CGRectMake(product2.frame.size.width*0.4, 15, product2.frame.size.width*0.5, 20)];
         [product2.productName setTextColor:[UIColor orangeColor]];
        [product2.productDesc setFrame:CGRectMake(product2.frame.size.width*0.4, 35, product2.frame.size.width*0.6, 20)];
        [product2.productDesc setTextColor:[UIColor grayColor]];
         [product2.productDesc setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:product2];
       
#pragma mark -第三个商品
         ProductView *  product3 = [[ProductView alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2)];
        [product3 setBackgroundColor:[UIColor whiteColor]];
        [product3.productName setTextColor:[UIColor orangeColor]];
        [product3.productImage setFrame:CGRectMake(10, product3.frame.size.width*0.05, product3.frame.size.height*0.7, product3.frame.size.height *0.7)];
        [product3.productName setFrame:CGRectMake(product3.frame.size.width*0.4, 15, product3.frame.size.width*0.5, 20)];
        [product3.productDesc setFrame:CGRectMake(product3.frame.size.width*0.4, 35, product3.frame.size.width*0.6, 20)];
        [product3.productDesc setTextColor:[UIColor grayColor]];
          [product3.productDesc setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:product3];
        
        [_topProducts addObjectsFromArray:@[product1,product2,product3]];
    }
    return self;
}


#pragma mark -设置商品
-(void)setProducts:(NSArray *)products
{
    for (int i =0; i<products.count; i++)
    {
        ProductView *productview = _topProducts[i];
        /**
         *  异步处理资源
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Product *product1 = products[i];
            NSString *str = product1.productImages;
            UIImage *img = [UIImage imageNamed:str];
            /**
             *  主线程更新UI
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [productview setProductID:product1.productID];
                [productview.productImage setImage:img];
                [productview.productName setText: product1.productName];
                [productview.productDesc setText:product1.productDesc];
            });
        });
        /**
         *  添加点击事件
         */
        [productview addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -通知父级跳转到商品详情
-(void)topImageTap:(ProductView *)productView
{
    [_delegate productDetailWithProductID:productView.ProductID];
}


@end
