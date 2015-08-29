//
//  ShopCarProductCell.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductShopCar.h"


@protocol ShopCarProductCellDelegate <NSObject>

@optional
-(void)productCountChage:(NSInteger )count CellRow:(NSInteger)cellRow;

-(void)refreshCellWithRow:(NSInteger)row;

@end

@interface ShopCarProductCell : UITableViewCell


@property(nonatomic,weak)id<ShopCarProductCellDelegate>delegate;
/**
 *  是否选中按钮
 */
@property(nonatomic,strong)UIButton *selectedBtn;
/**
 *  商品图片
 */
@property(nonatomic,strong)UIImageView *productImage;
/**
 *  商品详情
 */
@property(nonatomic,strong)UILabel *productDetail;
/**
 *  商品价格
 */
@property(nonatomic,strong)UILabel *productPrice;
/**
 *  数量
 */
@property(nonatomic,strong)UILabel *productCount;

/**
 *  删除按钮
 */
@property(nonatomic,strong)UIButton *deleteBtn;
/**
 *  商品名字
 */
@property(nonatomic,strong)UILabel *productName;
/**
 *  减少按钮
 */
@property(nonatomic,strong)UIButton *subBtn;
/**
 *  增加按钮
 */
@property(nonatomic,strong)UIButton *addBtn;
/**
 *  减少按钮增加按钮中间商品数量
 */
@property(nonatomic,strong)UIButton *centerNum;
/**
 *  商品库存
 */
@property(nonatomic,assign)NSInteger productStock;


-(void)setShopCarListItemShopCarProductModel:(ProductShopCar *)product;





@end
