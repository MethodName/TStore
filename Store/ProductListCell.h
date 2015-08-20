//
//  ProductListCell.h
//  Store
//
//  Created by tangmingming on 15/8/17.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreProductsModel.h"

@interface ProductListCell : UITableViewCell

@property(nonatomic,strong)UIImageView *productImage;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UILabel *productDetail;

@property(nonatomic,strong)UILabel *productPrice;

@property(nonatomic,strong)UILabel *PSName;

@property(nonatomic,strong)UILabel *productScaleCount;

@property(nonatomic,strong)UIButton *addShopCar;


-(void)setCellDataWith:(StoreProductsModel *)product;

@end
