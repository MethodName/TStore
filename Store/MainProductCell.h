//
//  MainProductCell.h
//  Store
//
//  Created by tangmingming on 15/8/16.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"


@protocol MainProductCellDelegate <NSObject>

-(void)addShopCarCWithProductID:(NSString *)productID;

@end

@interface MainProductCell : UITableViewCell


@property(nonatomic,weak)id<MainProductCellDelegate>delegate;

@property(nonatomic,strong)NSString *productID;

@property(nonatomic,strong)UIImageView *productImage;

@property(nonatomic,strong)UILabel *productName;

@property(nonatomic,strong)UILabel *productDetail;

@property(nonatomic,strong)UILabel *productPrice;

@property(nonatomic,strong)UILabel *productScaleCount;

@property(nonatomic,strong)UIButton *addShopCar;


-(void)setCellDataWithProduct:(Product *)product;

@end
