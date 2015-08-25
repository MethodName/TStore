//
//  Product.h
//  Store
//
//  Created by tangmingming on 15/8/25.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject




/**
*  颜色编号
*/
@property(nonatomic,assign)NSInteger pcID;
/**
 *  物业管理编号
 */
@property(nonatomic,assign)NSInteger pmcID;
/**
 *  已售数量
 */
@property(nonatomic,assign)NSInteger productSaleCount;
/**
 *  商品状态
 */
@property(nonatomic,assign)NSInteger productState;
/**
 *  商品库存
 */
@property(nonatomic,assign)NSInteger productStock;
/**
 *  商品单位编号
 */
@property(nonatomic,assign)NSInteger psID;
/**
 *  商品类型编号
 */
@property(nonatomic,assign)NSInteger ptID;
/**
 *  商品规格编号
 */
@property(nonatomic,assign)NSInteger puID;
/**
 *  颜色
 */
@property(nonatomic,strong)NSString * pcName;
/**
 *  小区编号
 */
@property(nonatomic,strong)NSString * pmcName;
/**
 *  商品描述
 */
@property(nonatomic,strong)NSString * productDesc;

/**
 *  备注
 */
@property(nonatomic,strong)NSString * desc;
/**
 *  商品编号
 */
@property(nonatomic,strong)NSString * productID;
/**
 *  商品图片
 */
@property(nonatomic,strong)NSString * productImages;
/**
 *  商品名字
 */
@property(nonatomic,strong)NSString * productName;
/**
 *  商品单位
 */
@property(nonatomic,strong)NSString * psName;
/**
 *  商品类型
 */
@property(nonatomic,strong)NSString * ptName;
/**
 *  商品规格
 */
@property(nonatomic,strong)NSString * puName;

/**
 *  商品价格
 */
@property(nonatomic,assign)double productPrice;

/**
 *  商品售价
 */
@property(nonatomic,assign)double productRealityPrice;
/**
 *  上架时间
 */
@property(nonatomic,assign)NSInteger productDate;



/*
 desc = 0;
 pcID = 1;
 pcName = "\U7ea2";
 pmcID = 1;
 pmcName = "\U7269\U4e1a";
 productDate = 1440092949010;
 productDesc = 666;
 productID = SP201508210005;
 productImages = "1440092945776f3fa4825c77f334ab8ba896a844ba8a8.jpg";
 productName = "\U6d4b\U8bd51";
 productPrice = 5;
 productRealityPrice = 5;
 productSaleCount = 0;
 productState = 1;
 productStock = 0;
 psID = 1;
 psName = "\U7bb1/\U53f0";
 ptID = 3;
 ptName = "\U98df\U7269";
 puID = 1;
 puName = "\U53f0";
 */



@end
