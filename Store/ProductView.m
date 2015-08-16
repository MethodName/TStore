//
//  ProductView.m
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductView.h"

@implementation ProductView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        _productImage = [[UIImageView alloc]init];
        [self addSubview:_productImage];
        _productName = [[UILabel alloc]init];
        [self addSubview:_productName];
        _productDesc = [[UILabel alloc]init];
        [self addSubview:_productDesc];
        
    }
    
    
    
    
    
    return self;
}

@end
