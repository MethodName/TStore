//
//  ShopCarProductCell.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarProductModel.h"

@interface ShopCarProductCell : UITableViewCell

@property(nonatomic,strong)UIButton *selectedBtn;

@property(nonatomic,strong)UIImageView *productImage;

@property(nonatomic,strong)UILabel *productDetail;

@property(nonatomic,strong)UILabel *productPrice;

@property(nonatomic,strong)UILabel *productCount;

@property(nonatomic,strong)UISegmentedControl *countSegmented;

@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UIButton *subBtn;

@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,strong)UIButton *centerNum;


-(void)setShopCarListItemShopCarProductModel:(ShopCarProductModel *)product;



@end
