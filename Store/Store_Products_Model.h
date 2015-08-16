//
//  Store_Products_Model.h
//  Store
//
//  Created by tangmingming on 15/8/15.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <UIKit/UIKit.h>
//ProductID, ProductName, ProductImages, ProductInPrice, ProductPrice, ProductRealityPrice, PTID, PUID, PCID, PSID, ProductStock, ProductSaleCount, ProductDesc, PMCID
@interface Store_Products_Model : UIView
/**商品编号*/
@property(nonatomic,strong)NSString *ProductID;
/**商品名称*/
@property(nonatomic,strong)NSString *ProductName;
/**商品图片数组*/
@property(nonatomic,strong)NSArray * ProductImages;
/**进价*/
@property(nonatomic,assign)double ProductInPrice;
/**售价*/
@property(nonatomic,assign)double ProductPrice;
/**实际价格*/
@property(nonatomic,assign)double ProductRealityPrice;
/**商品类型*/
@property(nonatomic,assign)NSInteger PTID;
/**商品颜色*/
@property(nonatomic,assign)NSInteger PCID;
/**商品单位*/
@property(nonatomic,assign)NSInteger PUID;
/**商品规格*/
@property(nonatomic,assign)NSInteger PSID;
/**库存*/
@property(nonatomic,assign)NSInteger ProductStock;
/**已售数量*/
@property(nonatomic,assign)NSInteger ProductSaleCount;
/**描叙*/
@property(nonatomic,strong)NSString *ProductDesc;
/**物业，小区编号*/
@property(nonatomic,assign)NSInteger PMCID;
@end
