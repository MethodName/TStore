//
//  ProductDetailCell.m
//  Store
//
//  Created by tangmingming on 15/8/18.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 20)];
        [_name setTextColor:[UIColor lightGrayColor]];
        [_name setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_name];
        
      
        
    
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 25)];
        [_productName setFont:[UIFont fontWithName:@"Verdana-Bold" size:20.0]];
        [self.contentView addSubview:_productName];
        
        
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 25)];
        [_productPrice setFont:[UIFont fontWithName:@"Thonburi-Bold" size:18.0]];
        [_productPrice setTextColor:[UIColor redColor]];
        [self.contentView addSubview:_productPrice];
        
        _haoPing = [[UIButton alloc]initWithFrame:CGRectMake(width*0.3+20, 15, 60, 20)];
        [_haoPing setTitleColor:[UIColor orangeColor] forState:0];
        [_haoPing.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_haoPing setHidden:YES];
        [self.contentView addSubview:_haoPing];
        
        _zhongPing = [[UIButton alloc]initWithFrame:CGRectMake(width*0.5+20, 15, 60, 20)];
        [_zhongPing setTitleColor:[UIColor orangeColor] forState:0];
        [_zhongPing.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_zhongPing setHidden:YES];
        [self.contentView addSubview:_zhongPing];
        
        _chaPing = [[UIButton alloc]initWithFrame:CGRectMake(width*0.7+20, 15, 60, 20)];
        [_chaPing setTitleColor:[UIColor orangeColor] forState:0];
        [_chaPing.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_chaPing setHidden:YES];
        [self.contentView addSubview:_chaPing];
        
        _collectBtn = [[IconTitleButton alloc]initWithFrame:CGRectMake(width-60, 2, 44, 44)];
        [_collectBtn.titleText setText:@"收藏"];
        [_collectBtn.iconImageView setImage:[UIImage imageNamed:@"collect_press"]];
        [_collectBtn setHidden:YES];
        [_collectBtn setTag:0];
      
        [self.contentView addSubview:_collectBtn];
        
        
    }
    return self;
}



@end
