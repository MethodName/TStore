//
//  ShopCarProductModel.h
//  Store
//
//  Created by tangmingming on 15/8/19.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarProductModel : NSObject


/**商品编号*/
@property(nonatomic,strong)NSString *ProductID;
/**商品名称*/
@property(nonatomic,strong)NSString *ProductName;
/**商品图片*/
@property(nonatomic,strong)NSString * ProductImage;
/**实际价格*/
@property(nonatomic,assign)double ProductRealityPrice;
/**商品单位*/
@property(nonatomic,assign)NSString* PUName;
/**商品规格*/
@property(nonatomic,assign)NSString* PSName;
/**库存*/
@property(nonatomic,assign)NSInteger ProductStock;
/**描叙*/
@property(nonatomic,strong)NSString *ProductDesc;
/**数量*/
@property(nonatomic,assign)NSInteger ProductShopCarCout;


@end
