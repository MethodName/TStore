//
//  MainProductCell.m
//  Store
//
//  Created by tangmingming on 15/8/16.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "MainProductCell.h"

@implementation MainProductCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = self.contentView.frame.size.width;
        CGFloat height = 100;
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, height-30, height-30)];
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(width*0.5, 5, width*0.4, 20)];
        [_productName setTextColor:[UIColor orangeColor]];
        _productDetail = [[UILabel alloc]initWithFrame:CGRectMake(width*0.5, _productName.frame.origin.y + 20, width*0.5, 20)];
        [_productDetail setFont:[UIFont systemFontOfSize:12]];
        [_productDetail setNumberOfLines:0];
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(width*0.5, 80, 100, 20)];
        [_productPrice setTextColor:[UIColor redColor]];
        [_productPrice setFont:[UIFont systemFontOfSize:13]];
        
        
        [self.contentView addSubview:_productImage];
        [self.contentView addSubview:_productName];
        [self.contentView addSubview:_productDetail];
        [self.contentView addSubview:_productPrice];
    }
    return self;
}


@end
