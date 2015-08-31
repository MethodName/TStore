//
//  StoreOrder.h
//  Store
//
//  Created by tangmingming on 15/8/30.
//  Copyright (c) 2015年 tangmingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreOrder : NSObject




/*
 OrderID, UserID, OrderDate, OrderConsignee, OrderAddress, OrderTelephone, OrderSumPrice, OrderState, OrderDesc, PMCID, FixDate
 **/
/**
*  订单编号
*/
@property(nonatomic,strong)NSString *orderID;

/**
 *  用户编号
 */
@property(nonatomic,assign)NSInteger userID;

/**
 *  订单时间
 */
@property(nonatomic,assign)NSInteger orderDate;

/**
 *  收件人
 */
@property(nonatomic,strong)NSString *orderConsignee;

/**
 *  收货地址
 */
@property(nonatomic,strong)NSString *orderAddress;

/**
 *  联系电话
 */
@property(nonatomic,strong)NSString *orderTelephone;

/**
 *  订单总金额
 */
@property(nonatomic,assign)double orderSumPrice;

/**
 *  运费
 */
@property(nonatomic,assign)double orderFreight;
/**
 *  订单状态
 */
@property(nonatomic,assign)NSInteger orderState;
/**
 *  物业编号
 */
@property(nonatomic,assign)NSInteger pMCID;



@end
