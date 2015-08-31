//
//  ProductShopCar.h
//  Store
//
//  Created by tangmingming on 15/8/28.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductShopCar : NSObject


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

/**
 *  在购物车中的数量
 */
@property(nonatomic,assign)NSInteger bayCount;

/**
 *  是否被选中
 */
@property(nonatomic,assign)BOOL isSelected;

/**
 *  行号
 */

@property(nonatomic,assign)NSInteger cellNum;

@property(nonatomic,strong)NSString * shopCarID;

@end
